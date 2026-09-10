<?php

namespace App\Services\Otp;

use App\Models\Otp;
use Carbon\Carbon;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;
use RuntimeException;

class FonnteOtpService implements OtpServiceInterface
{
    public function sendOtp(string $phone, string $type = 'REGISTER'): array
    {
        $normalizedPhone = $this->normalizePhone($phone);
        $code = (string) random_int(100000, 999999);
        $expiresAt = Carbon::now()->addMinutes(10);
        $message = "Kode OTP Anda: {$code}. Berlaku selama 10 menit. Jangan berikan kode ini kepada siapa pun.";

        $response = Http::asForm()
            ->withHeaders([
                'Authorization' => (string) config('services.fonnte.token'),
            ])
            ->post((string) config('services.fonnte.url'), [
                'target' => $normalizedPhone,
                'message' => $message,
            ]);

        $responseData = $response->json();
        if (!$response->successful() || ($responseData['status'] ?? true) === false) {
            Log::error('Fonnte rejected OTP request', [
                'http_status' => $response->status(),
                'response' => $responseData ?? $response->body(),
            ]);

            $providerMessage = is_array($responseData)
                ? ($responseData['reason'] ?? $responseData['message'] ?? null)
                : null;

            throw new RuntimeException(
                $providerMessage
                    ? "OTP gagal dikirim: {$providerMessage}"
                    : 'OTP gagal dikirim ke WhatsApp. Silakan coba lagi.'
            );
        }

        Otp::create([
            'phone' => $normalizedPhone,
            'otp_code' => $code,
            'type' => $type,
            'is_verified' => false,
            'expires_at' => $expiresAt,
        ]);

        return [
            'success' => true,
            'message' => 'Kode OTP berhasil dikirim ke WhatsApp Anda.',
            'expires_at' => $expiresAt->toIso8601String(),
        ];
    }

    public function verifyOtp(string $phone, string $code, string $type = 'REGISTER'): bool
    {
        $otp = Otp::where('phone', $this->normalizePhone($phone))
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

    private function normalizePhone(string $phone): string
    {
        $normalizedPhone = preg_replace('/\D+/', '', $phone) ?? '';

        if (str_starts_with($normalizedPhone, '0')) {
            $normalizedPhone = '62' . substr($normalizedPhone, 1);
        } elseif (str_starts_with($normalizedPhone, '8')) {
            $normalizedPhone = '62' . $normalizedPhone;
        }

        if (!preg_match('/^62[0-9]{9,13}$/', $normalizedPhone)) {
            throw new RuntimeException('Nomor WhatsApp tidak valid. Gunakan format 628123456789.');
        }

        return $normalizedPhone;
    }
}
