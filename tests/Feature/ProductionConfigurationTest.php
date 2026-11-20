<?php

namespace Tests\Feature;

use App\Exceptions\FaceRecognitionApiException;
use App\Providers\AppServiceProvider;
use App\Services\FaceRecognitionApi;
use LogicException;
use Tests\TestCase;

class ProductionConfigurationTest extends TestCase
{
    public function test_production_rejects_sqlite_as_the_application_database(): void
    {
        $this->app['env'] = 'production';
        config(['database.default' => 'sqlite']);

        $this->expectException(LogicException::class);
        $this->expectExceptionMessage('Production must configure DB_CONNECTION=mysql.');

        (new AppServiceProvider($this->app))->boot();
    }

    public function test_production_requires_explicit_mysql_connection_settings(): void
    {
        $this->app['env'] = 'production';
        config([
            'database.default' => 'mysql',
            'database.connections.mysql' => [
                'host' => 'db.example.test',
                'database' => 'website',
                'username' => 'website_user',
                'password' => '',
            ],
        ]);

        $this->expectException(LogicException::class);
        $this->expectExceptionMessage('Production must configure DB_PASSWORD.');

        (new AppServiceProvider($this->app))->boot();
    }

    public function test_production_rejects_a_local_biometric_api_url(): void
    {
        $this->app['env'] = 'production';
        config(['services.bisagym_face.url' => 'http://127.0.0.1:8001']);

        $this->expectException(FaceRecognitionApiException::class);
        $this->expectExceptionMessage('Production harus menggunakan URL HTTPS API biometrik');

        app(FaceRecognitionApi::class)->modelStatus();
    }
}
