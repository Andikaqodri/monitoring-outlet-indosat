<?php

namespace App\Services\Otp;

interface OtpServiceInterface
{
    public function sendOtp(string $phone, string $type = 'REGISTER'): array;
    public function verifyOtp(string $phone, string $code, string $type = 'REGISTER'): bool;
}