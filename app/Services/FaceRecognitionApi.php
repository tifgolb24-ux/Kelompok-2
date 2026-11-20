<?php

namespace App\Services;

use App\Exceptions\FaceRecognitionApiException;
use Illuminate\Contracts\Encryption\DecryptException;
use Illuminate\Http\Client\ConnectionException;
use Illuminate\Http\Client\Response;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\Crypt;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;

class FaceRecognitionApi
{
    private function baseUrl(): string
    {
        $url = trim((string) config('services.bisagym_face.url'));

        if ($url === '') {
            throw new FaceRecognitionApiException('URL API biometrik belum dikonfigurasi.');
        }

        if (app()->environment('production')) {
            $scheme = parse_url($url, PHP_URL_SCHEME);
            $host = parse_url($url, PHP_URL_HOST);
            if ($scheme !== 'https' || ! is_string($host)
                || in_array(strtolower($host), ['localhost', '127.0.0.1', '::1'], true)) {
                throw new FaceRecognitionApiException(
                    'Production harus menggunakan URL HTTPS API biometrik yang dapat dijangkau server.',
                );
            }
        }

        return rtrim($url, '/');
    }

    public function isConfigured(): bool
    {
        return filled(config('services.bisagym_face.email'))
            && filled(config('services.bisagym_face.password'))
            && filled(config('services.bisagym_face.url'));
    }

    public function isReady(): bool
    {
        if (! $this->isConfigured()) {
            return false;
        }

        try {
            $health = $this->modelStatus();

            return ($health['status'] ?? null) === 'ready'
                && ($health['engine'] ?? null) === 'opencv_sface';
        } catch (FaceRecognitionApiException) {
            return false;
        }
    }

    public function modelStatus(): array
    {
        try {
            $response = Http::connectTimeout(3)
                ->timeout(5)
                ->get($this->baseUrl().'/health/model');
        } catch (ConnectionException $exception) {
            throw new FaceRecognitionApiException(
                'API biometrik tidak dapat dihubungi. Pastikan service biometrik (bisagym-api) berjalan.',
                503,
                'BIOMETRIC_API_UNAVAILABLE',
                $exception,
            );
        }

        if (! $response->successful()) {
            throw new FaceRecognitionApiException(
                'Model wajah API belum siap. Periksa status service biometrik.',
                503,
                'FACE_MODEL_UNAVAILABLE',
            );
        }

        return $response->json() ?? [];
    }

    public function findOrCreateMember(array $member): string
    {
        $branchId = $this->branchId();
        $query = http_build_query([
            'search' => $member['member_code'],
            'branch_id' => $branchId,
            'limit' => 200,
        ]);
        $items = $this->request('GET', '/members?'.$query)['items'] ?? [];
        $matching = array_values(array_filter(
            $items,
            fn (array $item): bool => ($item['member_code'] ?? null) === $member['member_code']
        ));

        if (count($matching) > 1) {
            throw new FaceRecognitionApiException(
                'Kode member ini tercatat lebih dari sekali di API biometrik. Hubungi administrator.',
                409,
                'AMBIGUOUS_MEMBER_MAPPING',
            );
        }

        if ($matching !== []) {
            if (mb_strtolower(trim($matching[0]['full_name'] ?? '')) !== mb_strtolower(trim($member['full_name']))) {
                throw new FaceRecognitionApiException(
                    'Kode member sudah digunakan oleh nama berbeda di API biometrik. Periksa pemetaan member.',
                    409,
                    'MEMBER_MAPPING_CONFLICT',
                );
            }

            return $matching[0]['id'];
        }

        $created = $this->request('POST', '/members', [
            'branch_id' => $branchId,
            'member_code' => $member['member_code'],
            'full_name' => $member['full_name'],
            'email' => $member['email'],
            'phone' => $member['phone'],
            'date_of_birth' => $member['date_of_birth'],
            'gender' => $member['gender'],
            'address' => $member['address'],
            'status' => $member['status'] === 'active' ? 'ACTIVE' : 'INACTIVE',
        ]);

        return $created['id'];
    }

    public function createConsent(string $memberId, string $operatorReference): array
    {
        return $this->request('POST', "/members/{$memberId}/biometric-consents", [
            'consent_version' => 'v2.1',
            'capture_purpose' => 'Kontrol akses gym',
            'retention_policy' => 'Template wajah disimpan sampai persetujuan dicabut; gambar mentah diproses sesaat dan tidak disimpan.',
            'signature_reference' => $operatorReference,
        ]);
    }

    public function startEnrollment(string $memberId): array
    {
        return $this->request('POST', '/enrollments/sessions', ['member_id' => $memberId]);
    }

    public function uploadSample(string $sessionId, string $pose, string $image): array
    {
        return $this->request(
            'POST',
            '/enrollments/sessions/'.$sessionId.'/samples?'.http_build_query(['pose_type' => $pose]),
            $image,
            'image/jpeg',
        );
    }

    public function completeEnrollment(string $sessionId): array
    {
        return $this->request('POST', "/enrollments/sessions/{$sessionId}/complete");
    }

    public function faceProfileStatus(string $memberId): array
    {
        return $this->request('GET', "/members/{$memberId}/face-profile/status");
    }

    public function revokeFaceProfile(string $memberId, string $reason): void
    {
        $this->request(
            'DELETE',
            '/members/'.$memberId.'/face-profile?'.http_build_query(['reason' => $reason]),
        );
    }

    public function revokeActiveConsents(string $memberId, string $reason): void
    {
        $consents = $this->request('GET', "/members/{$memberId}/biometric-consents")['items'] ?? [];
        foreach ($consents as $consent) {
            if (($consent['revoked_at'] ?? null) === null) {
                $this->request(
                    'POST',
                    '/biometric-consents/'.$consent['id'].'/revoke',
                    ['reason' => $reason],
                );
            }
        }
    }

    public function analyzeLiveCameraFrame(string $imageBytes, ?string $branchId = null): array
    {
        $branchId = $branchId ?: $this->branchId();

        return $this->request(
            'POST',
            '/live-camera/frames?'.http_build_query(['branch_id' => $branchId]),
            $imageBytes,
            'image/jpeg',
        );
    }

    public function getBranches(): array
    {
        return $this->request('GET', '/branches')['items'] ?? [];
    }

    public function getDevices(): array
    {
        return $this->request('GET', '/devices')['items'] ?? [];
    }

    public function createDevice(array $payload): array
    {
        if (empty($payload['branch_id'])) {
            $payload['branch_id'] = $this->branchId();
        }

        return $this->request('POST', '/devices', $payload);
    }

    public function updateDevice(string $deviceId, array $payload): array
    {
        return $this->request('PATCH', "/devices/{$deviceId}", $payload);
    }

    public function rotateDeviceCredential(string $deviceId): array
    {
        return $this->request('POST', "/devices/{$deviceId}/rotate-credential");
    }

    public function branchId(): string
    {
        $user = $this->request('GET', '/auth/me');
        if (filled($user['branch_id'] ?? null)) {
            return $user['branch_id'];
        }

        $branches = $this->request('GET', '/branches')['items'] ?? [];
        foreach ($branches as $branch) {
            if (($branch['code'] ?? null) === config('services.bisagym_face.branch_code')) {
                return $branch['id'];
            }
        }

        throw new FaceRecognitionApiException(
            'Cabang API biometrik tidak ditemukan. Periksa BISAGYM_FACE_API_BRANCH_CODE.',
            503,
            'BRANCH_NOT_CONFIGURED',
        );
    }

    private function request(string $method, string $path, array|string|null $body = null, ?string $contentType = null): array
    {
        $cacheKey = 'bisagym-face-api-token-'.sha1((string) config('services.bisagym_face.email'));
        $encryptedToken = Cache::get($cacheKey);
        $token = null;
        if (is_string($encryptedToken)) {
            try {
                $token = Crypt::decryptString($encryptedToken);
            } catch (DecryptException) {
                Log::warning('Discarded unreadable biometric API token cache.');
                Cache::forget($cacheKey);
            }
        }

        if (! is_string($token) || $token === '') {
            $token = $this->login($cacheKey);
        }

        $response = $this->send($method, $path, $token, $body, $contentType);
        if ($response->status() === 401) {
            Cache::forget($cacheKey);
            $response = $this->send($method, $path, $this->login($cacheKey), $body, $contentType);
        }

        if (! $response->successful()) {
            $payload = $response->json();
            $message = data_get($payload, 'error.message')
                ?? data_get($payload, 'detail')
                ?? 'API biometrik menolak permintaan.';

            throw new FaceRecognitionApiException(
                $message,
                min(max($response->status(), 400), 599),
                data_get($payload, 'error.code'),
            );
        }

        return $response->json() ?? [];
    }

    private function login(string $cacheKey): string
    {
        if (! $this->isConfigured()) {
            throw new FaceRecognitionApiException(
                'Kredensial API biometrik belum diatur. Isi BISAGYM_FACE_API_EMAIL dan BISAGYM_FACE_API_PASSWORD di .env.',
            );
        }

        try {
            $response = Http::acceptJson()
                ->connectTimeout(3)
                ->timeout(10)
                ->post($this->baseUrl().'/api/v1/auth/login', [
                    'email' => config('services.bisagym_face.email'),
                    'password' => config('services.bisagym_face.password'),
                ]);
        } catch (ConnectionException $exception) {
            throw new FaceRecognitionApiException(
                'API biometrik tidak dapat dihubungi. Pastikan service biometrik (bisagym-api) berjalan.',
                503,
                'BIOMETRIC_API_UNAVAILABLE',
                $exception,
            );
        }

        if (! $response->successful() || ! is_string($response->json('access_token'))) {
            $message = data_get($response->json(), 'error.message')
                ?? data_get($response->json(), 'detail')
                ?? 'Login service account ke API biometrik gagal.';

            throw new FaceRecognitionApiException($message, 503, 'BIOMETRIC_API_AUTH_FAILED');
        }

        $token = $response->json('access_token');
        $expiresIn = (int) $response->json('expires_in', 600);
        Cache::put($cacheKey, Crypt::encryptString($token), now()->addSeconds(max(60, $expiresIn - 60)));

        return $token;
    }

    private function send(
        string $method,
        string $path,
        string $token,
        array|string|null $body,
        ?string $contentType,
    ): Response {
        $request = Http::acceptJson()
            ->withToken($token)
            ->connectTimeout(3)
            ->timeout(20);

        if (is_string($body)) {
            $request = $request->withBody($body, $contentType ?? 'application/octet-stream');
        } elseif ($contentType !== null) {
            $request = $request->withBody((string) $body, $contentType);
        }

        try {
            $url = $this->baseUrl().'/api/v1'.$path;

            return $body === null
                ? $request->send($method, $url)
                : (is_array($body)
                    ? $request->send($method, $url, ['json' => $body])
                    : $request->send($method, $url));
        } catch (ConnectionException $exception) {
            throw new FaceRecognitionApiException(
                'API biometrik tidak dapat dihubungi. Pastikan service biometrik (bisagym-api) berjalan.',
                503,
                'BIOMETRIC_API_UNAVAILABLE',
                $exception,
            );
        }
    }
}
