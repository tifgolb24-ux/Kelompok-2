<?php

namespace App\Http\Controllers;

use App\Exceptions\FaceRecognitionApiException;
use App\Models\Member;
use App\Services\FaceRecognitionApi;
use App\Traits\HandlesEsp32Cam;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;
use Illuminate\Validation\ValidationException;

class FaceEnrollmentController extends Controller
{
    use HandlesEsp32Cam;
    public function index(Request $request, FaceRecognitionApi $faceApi)
    {
        $search = trim((string) $request->query('search', ''));
        $members = Member::query()
            ->select([
                'id',
                'member_id',
                'name',
                'email',
                'phone',
                'date_of_birth',
                'gender',
                'address',
                'status',
                'face_enrollment_status',
                'face_enrolled_at',
            ])
            ->when($search !== '', function ($query) use ($search) {
                $query->where(function ($members) use ($search) {
                    $members->where('name', 'like', "%{$search}%")
                        ->orWhere('member_id', 'like', "%{$search}%");
                });
            })
            ->orderBy('name')
            ->paginate(12)
            ->withQueryString();

        $selectedMember = $request->filled('member_id')
            ? Member::findOrFail($request->integer('member_id'))
            : null;
        $apiReady = $faceApi->isReady();

        return view('face-enrollment.index', compact('members', 'search', 'selectedMember', 'apiReady'));
    }

    public function start(Request $request, Member $member, FaceRecognitionApi $faceApi): JsonResponse
    {
        try {
            $request->validate(['consent' => ['accepted']]);

            $model = $faceApi->modelStatus();
            if (($model['status'] ?? null) !== 'ready' || ($model['engine'] ?? null) !== 'opencv_sface') {
                throw new FaceRecognitionApiException(
                    'Pendaftaran membutuhkan model OpenCV YuNet/SFace yang siap. Mode mock/demo tidak dapat digunakan.',
                    503,
                    'REAL_FACE_ENGINE_REQUIRED',
                );
            }

            $resolveMemberApiId = function () use ($member, $faceApi): string {
                return $faceApi->findOrCreateMember([
                    'member_code' => $member->member_id,
                    'full_name' => $member->name,
                    'email' => $member->email,
                    'phone' => $member->phone,
                    'date_of_birth' => $member->date_of_birth
                        ? \Illuminate\Support\Carbon::parse($member->date_of_birth)->format('Y-m-d')
                        : null,
                    'gender' => $member->gender,
                    'address' => $member->address,
                    'status' => $member->status,
                ]);
            };

            if (! $member->face_api_member_id) {
                $member->face_api_member_id = $resolveMemberApiId();
                $member->save();
            }

            try {
                $faceApi->createConsent(
                    $member->face_api_member_id,
                    'Website-BisaGym operator user ID: '.$request->user()->getAuthIdentifier(),
                );
                $session = $faceApi->startEnrollment($member->face_api_member_id);
            } catch (FaceRecognitionApiException $apiExc) {
                // Jika member ID lama tidak ditemukan di database API baru (misal ganti service/database baru):
                if ($apiExc->status === 404) {
                    $member->face_api_member_id = $resolveMemberApiId();
                    $member->save();

                    $faceApi->createConsent(
                        $member->face_api_member_id,
                        'Website-BisaGym operator user ID: '.$request->user()->getAuthIdentifier(),
                    );
                    $session = $faceApi->startEnrollment($member->face_api_member_id);
                } else {
                    throw $apiExc;
                }
            }

            $member->face_enrollment_session_id = $session['id'];
            $member->face_enrollment_status = 'IN_PROGRESS';
            $member->save();

            return response()->json([
                'session_id' => $session['id'],
                'required_poses' => $session['required_poses'],
                'engine' => $session['engine'],
                'expires_at' => $session['expires_at'],
            ]);
        } catch (ValidationException $exception) {
            return response()->json([
                'message' => 'Persetujuan biometrik harus dicentang sebelum melanjutkan.',
                'errors' => $exception->errors(),
            ], 422);
        } catch (FaceRecognitionApiException $exception) {
            return $this->apiError($exception);
        }
    }

    public function sample(Request $request, Member $member, FaceRecognitionApi $faceApi): JsonResponse
    {
        try {
            $validated = $request->validate([
                'session_id' => ['required', 'string', 'size:36'],
                'pose_type' => ['required', 'in:FRONT,LEFT,RIGHT'],
                'esp32_url' => ['nullable', 'string'],
            ]);

            if ($member->face_enrollment_status !== 'IN_PROGRESS'
                || $member->face_enrollment_session_id !== $validated['session_id']) {
                return response()->json([
                    'message' => 'Sesi pendaftaran tidak aktif. Mulai ulang pendaftaran wajah.',
                ], 409);
            }

            $image = null;
            if ($request->filled('esp32_url')) {
                $image = $this->fetchEsp32Frame($request->input('esp32_url'));
                if (! $image) {
                    return response()->json([
                        'message' => 'Gagal mengambil gambar dari ESP32-CAM. Pastikan modul menyala dan alamat IP benar.',
                        'code' => 'CAMERA_CAPTURE_FAILED',
                    ], 422);
                }
            } else {
                $image = $request->getContent();
            }

            if ($image === '' || strlen($image) > 5_000_000 || strlen($image) < 100) {
                return response()->json([
                    'message' => 'Gambar kosong atau melebihi batas ukuran 5 MB.',
                ], 422);
            }

            $result = $faceApi->uploadSample(
                $validated['session_id'],
                $validated['pose_type'],
                $image,
            );

            return response()->json([
                'pose_type' => $result['pose_type'],
                'quality_score' => $result['quality_score'],
                'engine' => $result['engine'],
            ]);
        } catch (ValidationException $exception) {
            return response()->json([
                'message' => 'Data sampel tidak valid.',
                'errors' => $exception->errors(),
            ], 422);
        } catch (FaceRecognitionApiException $exception) {
            return $this->apiError($exception);
        }
    }

    public function complete(Member $member, FaceRecognitionApi $faceApi): JsonResponse
    {
        try {
            if ($member->face_enrollment_status !== 'IN_PROGRESS'
                || ! $member->face_enrollment_session_id) {
                return response()->json([
                    'message' => 'Tidak ada sesi pendaftaran wajah yang aktif.',
                ], 409);
            }

            $result = $faceApi->completeEnrollment($member->face_enrollment_session_id);
            $member->face_enrollment_status = 'ENROLLED';
            $member->face_enrollment_session_id = null;
            $member->face_enrolled_at = now();
            $member->save();

            return response()->json([
                'status' => $result['status'],
                'model' => $result['model'],
                'sample_count' => $result['sample_count'],
            ]);
        } catch (FaceRecognitionApiException $exception) {
            return $this->apiError($exception);
        }
    }

    public function revoke(Member $member, FaceRecognitionApi $faceApi): JsonResponse
    {
        try {
            if (! $member->face_api_member_id || $member->face_enrollment_status !== 'ENROLLED') {
                return response()->json([
                    'message' => 'Member ini tidak memiliki profil wajah aktif.',
                ], 409);
            }

            try {
                $profile = $faceApi->faceProfileStatus($member->face_api_member_id);
                if ($profile['enrolled'] ?? false) {
                    $faceApi->revokeFaceProfile(
                        $member->face_api_member_id,
                        'Persetujuan biometrik dicabut melalui Website-BisaGym.',
                    );
                }
                $faceApi->revokeActiveConsents(
                    $member->face_api_member_id,
                    'Persetujuan biometrik dicabut melalui Website-BisaGym.',
                );
            } catch (FaceRecognitionApiException $e) {
                if ($e->status !== 404) {
                    throw $e;
                }
            }

            $member->face_enrollment_status = 'REVOKED';
            $member->face_enrolled_at = null;
            $member->face_enrollment_session_id = null;
            $member->save();

            return response()->json(['status' => 'REVOKED']);
        } catch (FaceRecognitionApiException $exception) {
            return $this->apiError($exception);
        }
    }

    private function apiError(FaceRecognitionApiException $exception): JsonResponse
    {
        if ($exception->status >= 500) {
            Log::warning('Face enrollment API request failed.', [
                'api_code' => $exception->apiCode,
                'status' => $exception->status,
            ]);
        }

        return response()->json([
            'message' => $exception->getMessage(),
            'code' => $exception->apiCode,
        ], $exception->status);
    }
}
