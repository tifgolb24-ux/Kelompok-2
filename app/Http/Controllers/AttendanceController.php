<?php

namespace App\Http\Controllers;

use App\Exceptions\FaceRecognitionApiException;
use App\Models\Member;
use App\Models\MemberAttendance;
use App\Models\MemberTransaction;
use App\Services\FaceRecognitionApi;
use Carbon\Carbon;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\DB;
use App\Traits\HandlesEsp32Cam;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Str;

class AttendanceController extends Controller
{
    use HandlesEsp32Cam;

    public function index(Request $request, FaceRecognitionApi $faceApi)
    {
        $selectedDate = $request->query('date', Carbon::today()->format('Y-m-d'));

        // Get attendances for selected date
        $attendances = MemberAttendance::with(['member', 'user'])
            ->whereDate('attendance_time', $selectedDate)
            ->latest('attendance_time')
            ->get();

        // Stats
        $totalSelectedDate = $attendances->count();
        $totalAllAttendances = MemberAttendance::count();

        $isSqlite = DB::getDriverName() === 'sqlite';

        if ($isSqlite) {
            $uniqueDays = DB::table('member_attendances')
                ->selectRaw("COUNT(DISTINCT strftime('%Y-%m-%d', attendance_time)) as count")
                ->value('count') ?: 1;

            $uniqueWeeks = DB::table('member_attendances')
                ->selectRaw("COUNT(DISTINCT strftime('%Y-%W', attendance_time)) as count")
                ->value('count') ?: 1;

            $uniqueMonths = DB::table('member_attendances')
                ->selectRaw("COUNT(DISTINCT strftime('%Y-%m', attendance_time)) as count")
                ->value('count') ?: 1;
        } else {
            $uniqueDays = DB::table('member_attendances')
                ->selectRaw('COUNT(DISTINCT DATE(attendance_time)) as count')
                ->value('count') ?: 1;

            $uniqueWeeks = DB::table('member_attendances')
                ->selectRaw('COUNT(DISTINCT YEARWEEK(attendance_time, 1)) as count')
                ->value('count') ?: 1;

            $uniqueMonths = DB::table('member_attendances')
                ->selectRaw('COUNT(DISTINCT DATE_FORMAT(attendance_time, "%Y-%m")) as count')
                ->value('count') ?: 1;
        }

        $averageDaily = round($totalAllAttendances / $uniqueDays, 1);
        $averageWeekly = round($totalAllAttendances / $uniqueWeeks, 1);
        $averageMonthly = round($totalAllAttendances / $uniqueMonths, 1);

        $apiReady = $faceApi->isReady();

        return view('attendance.index', compact(
            'attendances',
            'selectedDate',
            'totalSelectedDate',
            'averageDaily',
            'averageWeekly',
            'averageMonthly',
            'apiReady'
        ));
    }

    public function store(Request $request)
    {
        $request->validate([
            'identifier' => 'required|string',
        ]);

        $identifier = $request->identifier;
        $member = Member::where('member_id', $identifier)
            ->orWhere('name', 'like', "%{$identifier}%")
            ->first();

        if (! $member) {
            return back()->with('error', 'Member tidak ditemukan. Pastikan ID / Nama / Barcode benar.');
        }

        if ($member->status === 'pending') {
            return back()->with('error', 'Member ini belum aktif. Jika baru mendaftar, pastikan sudah melunasi pembayaran di Kasir.');
        }

        // Cek apakah punya tagihan belum dibayar
        $hasUnpaid = MemberTransaction::where('member_id', $member->id)
            ->where('payment_status', 'unpaid')
            ->exists();

        if ($hasUnpaid) {
            return back()->with('error', 'Member ini memiliki tagihan yang BELUM LUNAS. Absensi ditolak sebelum pembayaran diselesaikan di menu Kasir.');
        }

        if ($member->status === 'expired' || Carbon::now()->gt($member->expiry_date)) {
            return back()->with('error', 'Keanggotaan member ini sudah KEDALUWARSA pada '.Carbon::parse($member->expiry_date)->format('d M Y').'. Silakan perpanjang terlebih dahulu.');
        }

        // Cek apakah sudah absen hari ini untuk mencegah double scan
        $alreadyScanned = MemberAttendance::where('member_id', $member->id)
            ->whereDate('attendance_time', Carbon::today())
            ->exists();

        $today = Carbon::today();
        $expiry = Carbon::parse($member->expiry_date)->startOfDay();
        $daysLeft = (int) $today->diffInDays($expiry, false);

        $scannedData = [
            'name' => $member->name,
            'member_id' => $member->member_id,
            'member_type' => $member->member_type,
            'photo_path' => $member->photo_path ? asset('storage/'.$member->photo_path) : null,
            'expiry_date' => Carbon::parse($member->expiry_date)->format('d M Y'),
            'days_left' => $daysLeft,
            'scan_time' => Carbon::now()->format('H:i:s'),
        ];

        if ($alreadyScanned) {
            $scannedData['already_scanned'] = true;

            return back()
                ->with('warning', 'Member '.$member->name.' sudah melakukan absensi hari ini.')
                ->with('scanned_member', $scannedData);
        }

        // Record attendance
        MemberAttendance::create([
            'member_id' => $member->id,
            'user_id' => Auth::id(), // Petugas yang scan
            'attendance_time' => Carbon::now(),
        ]);

        $statusMsg = 'Absensi berhasil untuk: '.$member->name.' (Masa aktif tersisa '.max(0, $daysLeft).' hari)';

        return back()
            ->with('success', $statusMsg)
            ->with('scanned_member', $scannedData);
    }

    public function faceCheckin(Request $request, FaceRecognitionApi $faceApi): JsonResponse
    {
        try {
            $imageBytes = null;
            if ($request->hasFile('frame')) {
                $imageBytes = file_get_contents($request->file('frame')->getRealPath());
            } elseif ($request->filled('image')) {
                $imageBytes = base64_decode(preg_replace('#^data:image/\w+;base64,#i', '', (string) $request->input('image')));
            } elseif ($request->filled('esp32_url')) {
                $imageBytes = $this->fetchEsp32Frame($request->input('esp32_url'));
                if (! $imageBytes) {
                    return response()->json([
                        'decision' => 'DENY',
                        'code' => 'ESP32_UNREACHABLE',
                        'title' => 'Kamera ESP32-CAM Tidak Merespons',
                        'message' => 'Gagal mengambil gambar dari ESP32-CAM. Pastikan perangkat aktif, terhubung ke Wi-Fi, dan alamat IP benar.',
                    ], 422);
                }
            } elseif ($request->getContent() !== '' && ! in_array($request->getContent(), ['{}', '[]'], true)) {
                $imageBytes = $request->getContent();
            }

            if (! $imageBytes || strlen($imageBytes) < 50) {
                return response()->json([
                    'decision' => 'DENY',
                    'code' => 'EMPTY_IMAGE',
                    'title' => 'Gambar Tidak Ditemukan',
                    'message' => 'Kamera belum menghasilkan foto wajah yang valid.',
                ], 422);
            }

            $analysis = $faceApi->analyzeLiveCameraFrame($imageBytes);

            $faces = $analysis['faces'] ?? [];
            if (empty($faces)) {
                return response()->json([
                    'decision' => 'DENY',
                    'code' => 'NO_FACE',
                    'title' => 'Wajah Tidak Terlihat',
                    'message' => 'Posisikan wajah tepat di dalam bingkai panduan kamera.',
                ]);
            }

            if (count($faces) > 1) {
                return response()->json([
                    'decision' => 'DENY',
                    'code' => 'MULTIPLE_FACES',
                    'title' => 'Terdeteksi Banyak Wajah',
                    'message' => 'Pastikan hanya satu orang yang berada di depan kamera saat check-in.',
                ]);
            }

            $detected = $faces[0];
            $registration = $detected['registration'] ?? 'UNREGISTERED';
            $reasonCode = $detected['reason_code'] ?? null;

            if ($registration !== 'REGISTERED' || empty($detected['member'])) {
                $msg = 'Wajah belum terdaftar di sistem gym. Silakan hubungi kasir/staf untuk mendaftarkan wajah.';
                if ($reasonCode === 'LOW_IMAGE_QUALITY' || $reasonCode === 'FACE_TOO_SMALL') {
                    $msg = 'Foto wajah kurang jelas atau terlalu jauh. Silakan mendekat ke kamera.';
                }

                return response()->json([
                    'decision' => 'DENY',
                    'code' => $reasonCode ?: 'UNREGISTERED',
                    'title' => 'Wajah Belum Terdaftar',
                    'message' => $msg,
                ]);
            }

            $matchedMemberData = $detected['member'];
            $memberCode = $matchedMemberData['member_code'] ?? '';
            $fullName = $matchedMemberData['full_name'] ?? '';

            $member = Member::where('member_id', $memberCode)->first();
            if (! $member && filled($fullName)) {
                $member = Member::where('name', $fullName)->first();
            }

            if (! $member) {
                return response()->json([
                    'decision' => 'DENY',
                    'code' => 'MEMBER_NOT_FOUND',
                    'title' => 'Data Member Tidak Cocok',
                    'message' => 'Wajah dikenali tapi data member tidak ditemukan di sistem lokal.',
                ]);
            }

            // Validasi status member di Laravel
            if ($member->status === 'pending') {
                return response()->json([
                    'decision' => 'DENY',
                    'code' => 'MEMBER_PENDING',
                    'title' => 'Membership Belum Aktif',
                    'message' => 'Member '.$member->name.' belum aktif. Silakan lunasi pembayaran terlebih dahulu.',
                    'member' => ['name' => $member->name, 'member_id' => $member->member_id],
                ]);
            }

            $hasUnpaid = MemberTransaction::where('member_id', $member->id)
                ->where('payment_status', 'unpaid')
                ->exists();

            if ($hasUnpaid) {
                return response()->json([
                    'decision' => 'DENY',
                    'code' => 'UNPAID_INVOICE',
                    'title' => 'Tagihan Belum Lunas',
                    'message' => 'Member '.$member->name.' memiliki tagihan yang belum dibayar di kasir.',
                    'member' => ['name' => $member->name, 'member_id' => $member->member_id],
                ]);
            }

            if ($member->status === 'expired' || Carbon::now()->gt($member->expiry_date)) {
                return response()->json([
                    'decision' => 'DENY',
                    'code' => 'MEMBERSHIP_EXPIRED',
                    'title' => 'Membership Kedaluwarsa',
                    'message' => 'Masa keanggotaan sudah berakhir pada '.Carbon::parse($member->expiry_date)->format('d M Y').'. Hubungi kasir untuk perpanjangan.',
                    'member' => ['name' => $member->name, 'member_id' => $member->member_id],
                ]);
            }

            $alreadyScanned = MemberAttendance::where('member_id', $member->id)
                ->whereDate('attendance_time', Carbon::today())
                ->exists();

            $today = Carbon::today();
            $expiry = Carbon::parse($member->expiry_date)->startOfDay();
            $daysLeft = (int) $today->diffInDays($expiry, false);

            if ($alreadyScanned) {
                return response()->json([
                    'decision' => 'DENY',
                    'code' => 'DUPLICATE_CHECKIN',
                    'title' => 'Sudah Absen Hari Ini',
                    'message' => 'Member '.$member->name.' sudah tercatat hadir hari ini.',
                    'member' => [
                        'name' => $member->name,
                        'member_id' => $member->member_id,
                        'photo_path' => $member->photo_path ? asset('storage/'.$member->photo_path) : null,
                        'days_left' => $daysLeft,
                        'expiry_date' => Carbon::parse($member->expiry_date)->format('d M Y'),
                    ],
                ]);
            }

            // Catat kehadiran
            MemberAttendance::create([
                'member_id' => $member->id,
                'user_id' => Auth::id(),
                'attendance_time' => Carbon::now(),
            ]);

            return response()->json([
                'decision' => 'ALLOW',
                'code' => 'ACCESS_GRANTED',
                'title' => 'Akses Diizinkan',
                'message' => 'Selamat berlatih! Pintu siap dibuka.',
                'member' => [
                    'name' => $member->name,
                    'member_id' => $member->member_id,
                    'member_type' => $member->member_type ?? 'Member',
                    'photo_path' => $member->photo_path ? asset('storage/'.$member->photo_path) : null,
                    'days_left' => $daysLeft,
                    'expiry_date' => Carbon::parse($member->expiry_date)->format('d M Y'),
                    'attendance_time' => Carbon::now()->format('H:i:s'),
                ],
            ]);
        } catch (FaceRecognitionApiException $e) {
            return response()->json([
                'decision' => 'DENY',
                'code' => $e->apiCode ?: 'API_ERROR',
                'title' => 'Layanan Biometrik Gangguan',
                'message' => $e->getMessage(),
            ], min(max($e->status, 400), 599));
        }
    }

    public function testEsp32(Request $request): JsonResponse
    {
        $request->validate([
            'esp32_url' => 'required|string',
        ]);

        try {
            $bytes = $this->fetchEsp32Frame($request->input('esp32_url'));
            if ($bytes && strlen($bytes) > 500) {
                return response()->json([
                    'success' => true,
                    'message' => 'Koneksi ke ESP32-CAM berhasil! Frame gambar valid ('.round(strlen($bytes) / 1024, 1).' KB).',
                ]);
            }

            return response()->json([
                'success' => false,
                'message' => 'Tidak dapat mengambil frame dari ESP32-CAM. Pastikan modul menyala dan alamat URL benar.',
            ], 422);
        } catch (\Throwable $e) {
            return response()->json([
                'success' => false,
                'message' => 'Error saat menghubungi ESP32-CAM: '.$e->getMessage(),
            ], 422);
        }
    }

    public function esp32Frame(Request $request)
    {
        $url = $request->query('url');
        if (! $url) {
            return response('Parameter url diperlukan', 400);
        }

        $bytes = $this->fetchEsp32Frame($url);
        if (! $bytes) {
            return response('Gagal mengambil frame dari ESP32-CAM', 502);
        }

        return response($bytes, 200, [
            'Content-Type' => 'image/jpeg',
            'Cache-Control' => 'no-cache, no-store, must-revalidate',
            'Pragma' => 'no-cache',
            'Expires' => '0',
        ]);
    }

    /**
     * Proxy MJPEG stream dari ESP32-CAM melalui Laravel
     * untuk mengatasi masalah CORS / jaringan berbeda.
     */
    public function esp32Stream(Request $request)
    {
        $url = $request->query('url');
        if (! $url) {
            return response('Parameter url diperlukan', 400);
        }

        $streamUrl = $this->normalizeEsp32Url($url);
        $parsed = parse_url($streamUrl);
        $host = $parsed['host'] ?? '127.0.0.1';

        // Tentukan URL stream: port 81 untuk IP lokal lama, atau /stream langsung untuk tunnel HTTPS/domain
        if (str_contains($streamUrl, '/stream')) {
            $target = $streamUrl;
        } else {
            $scheme = $parsed['scheme'] ?? 'http';
            if ($scheme === 'https' || preg_match('/[a-z]/i', str_replace('.', '', $host))) {
                $target = "{$streamUrl}/stream";
            } else {
                $target = "{$scheme}://{$host}:81/stream";
            }
        }

        // Gunakan Symfony StreamedResponse untuk proxy stream
        return response()->stream(function () use ($target) {
            $ch = curl_init($target);
            curl_setopt_array($ch, [
                CURLOPT_RETURNTRANSFER => false,
                CURLOPT_TIMEOUT => 0,           // tanpa batas waktu
                CURLOPT_CONNECTTIMEOUT => 5,
                CURLOPT_FOLLOWLOCATION => true,
                CURLOPT_HTTPHEADER => [
                    'ngrok-skip-browser-warning: 1',
                    'bypass-tunnel-reminder: 1',
                    'User-Agent: BisaGym-ESP32-Client/1.0',
                ],
                CURLOPT_WRITEFUNCTION => function ($ch, $data) {
                    echo $data;
                    if (ob_get_level() > 0) ob_flush();
                    flush();

                    if (connection_aborted()) {
                        return 0; // stop curl
                    }

                    return strlen($data);
                },
            ]);
            curl_exec($ch);
            curl_close($ch);
        }, 200, [
            'Content-Type' => 'multipart/x-mixed-replace;boundary=frame',
            'Cache-Control' => 'no-cache, no-store',
            'Access-Control-Allow-Origin' => '*',
            'X-Accel-Buffering' => 'no',
        ]);
    }

    public function storeKioskFeedback(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'status' => 'required|in:berhasil,gagal',
            'name' => 'nullable|string|max:64',
        ]);

        $payload = [
            'id' => (string) Str::uuid(),
            'status' => $validated['status'],
            'name' => $validated['name'] ?? '',
            'ts' => now()->timestamp,
        ];

        Cache::put('bisagym_kiosk_feedback', $payload, now()->addSeconds(15));

        return response()->json(['ok' => true, 'feedback' => $payload]);
    }

    public function kioskFeedback(): JsonResponse
    {
        $payload = Cache::get('bisagym_kiosk_feedback', [
            'id' => '',
            'status' => 'idle',
            'name' => '',
        ]);

        return response()->json($payload);
    }
}
