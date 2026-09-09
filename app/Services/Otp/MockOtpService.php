<?php

namespace App\Services\Otp;

use App\Models\Otp;
use Carbon\Carbon;
use Illuminate\Support\Facades\Log;

class MockOtpService implements OtpServiceInterface
{
    public function sendOtp(string $phone, string $type = 'REGISTER'): array
    {
        // In development/mock mode: produce 6-digit OTP code (e.g. 123456 or random)
        $code = config('app.env') === 'production' ? (string) random_int(100000, 999999) : '123456';
        $expiresAt = Carbon::now()->addMinutes(10);

        Otp::create([
            'phone' => $phone,
            'otp_code' => $code,
            'type' => $type,
            'is_verified' => false,
            'expires_at' => $expiresAt,
        ]);

        Log::info("OTP sent to $phone for $type: $code (expires at $expiresAt)");

        return [
            'success' => true,
            'message' => 'Kode OTP berhasil dikirim ke nomor WhatsApp/SMS Anda.',
            'expires_at' => $expiresAt->toIso8601String(),
            // Mock preview for developer testing
            'mock_code' => config('app.debug') ? $code : null,
        ];
    }

    public function verifyOtp(string $phone, string $code, string $type = 'REGISTER'): bool
    {
        $otp = Otp::where('phone', $phone)
                  ->where('type', $type)
                  ->where('otp_code', $code)
                  ->where('is_verified', false)
                  ->where('expires_at', '>=', Carbon::now())
                  ->latest()
                  ->first();

        if (!$otp) {
            return false;
        }

        $otp->update(['is_verified' => true]);
        return true;
    }
}