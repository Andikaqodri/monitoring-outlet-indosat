<?php

namespace App\Providers;

use Illuminate\Support\ServiceProvider;

class AppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     */
    public function register(): void
    {
        $this->app->bind(
            \App\Services\Otp\OtpServiceInterface::class,
            config('services.otp.provider', 'mock') === 'fonnte'
                ? \App\Services\Otp\FonnteOtpService::class
                : \App\Services\Otp\MockOtpService::class
        );
    }

    /**
     * Bootstrap any application services.
     */
    public function boot(): void
    {
        //
    }
}
