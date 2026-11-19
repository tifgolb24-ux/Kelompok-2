<?php

namespace App\Traits;

use Illuminate\Support\Facades\Http;

trait HandlesEsp32Cam
{
    protected function normalizeEsp32Url(string $url): string
    {
        $url = trim($url);
        if (! preg_match('#^https?://#i', $url)) {
            $url = 'http://'.$url;
        }

        return rtrim($url, '/');
    }

    protected function fetchEsp32Frame(string $rawUrl): ?string
    {
        $baseUrl = $this->normalizeEsp32Url($rawUrl);
        $parsed = parse_url($baseUrl);
        $scheme = $parsed['scheme'] ?? 'http';
        $host = $parsed['host'] ?? '127.0.0.1';
        $port = isset($parsed['port']) ? ':'.$parsed['port'] : '';
        $path = $parsed['path'] ?? '';

        $candidateUrls = [];
        if (str_contains($path, 'capture') || str_ends_with($path, '.jpg')) {
            $candidateUrls[] = $baseUrl;
        } else {
            // Standard ESP32-CAM capture endpoint is /capture
            $candidateUrls[] = "{$baseUrl}/capture";
            $candidateUrls[] = "{$scheme}://{$host}/capture";
            if ($port && $port !== ':81') {
                $candidateUrls[] = "{$scheme}://{$host}{$port}/capture";
            }
            $candidateUrls[] = $baseUrl;
        }

        foreach ($candidateUrls as $targetUrl) {
            try {
                $res = Http::timeout(5)
                    ->withHeaders([
                        'ngrok-skip-browser-warning' => '1',
                        'bypass-tunnel-reminder' => 'true',
                        'User-Agent' => 'BisaGym-ESP32-Client/1.0',
                    ])
                    ->get($targetUrl);

                if ($res->successful() && strlen($res->body()) > 500) {
                    return $res->body();
                }
            } catch (\Throwable $e) {
                // coba kandidat URL berikutnya
            }
        }

        return null;
    }
}

