<?php

namespace App\Providers;

use Illuminate\Support\ServiceProvider;
use LogicException;

class AppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     */
    public function register(): void
    {
        //
    }

    /**
     * Bootstrap any application services.
     */
    public function boot(): void
    {
        if (! $this->app->environment('production')) {
            return;
        }

        if (config('database.default') !== 'mysql') {
            throw new LogicException('Production must configure DB_CONNECTION=mysql.');
        }

        $connection = config('database.connections.mysql', []);
        foreach (['host', 'database', 'username', 'password'] as $setting) {
            if (! is_string($connection[$setting] ?? null) || trim($connection[$setting]) === '') {
                throw new LogicException('Production must configure DB_'.strtoupper($setting).'.');
            }
        }
    }
}
