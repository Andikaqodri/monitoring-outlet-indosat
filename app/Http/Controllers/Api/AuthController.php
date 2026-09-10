<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\ActivityLog;
use App\Models\User;
use App\Models\UserOutlet;
use App\Services\Otp\OtpServiceInterface;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\ValidationException;

class AuthController extends Controller
{
    public function __construct(protected OtpServiceInterface $otpService) {}

    public function register(Request $request)
    {
        $validated = $request->validate([
            'name' => 'required|string|max:100',
            'email' => 'required|email|unique:users,email',
            'password' => 'required|string|min:6',
            'phone' => 'required|string|max:25',
            'nip' => 'nullable|string|max:50|unique:users,nip',
            'role' => 'nullable|string|in:admin,cse,outlet_owner,sales,verifikator',
            'outlet_id' => 'nullable|exists:outlets,id',
        ]);

        $user = User::create([
            'name' => $validated['name'],
            'email' => $validated['email'],
            'password' => Hash::make($validated['password']),
            'phone' => $validated['phone'],
            'nip' => $validated['nip'] ?? null,
            'role' => $validated['role'] ?? 'sales',
            'status' => 'pending', // Menunggu verifikasi OTP / approval
        ]);

        if (!empty($validated['outlet_id'])) {
            UserOutlet::create([
                'user_id' => $user->id,
                'outlet_id' => $validated['outlet_id'],
                'role_in_outlet' => $user->role === 'outlet_owner' ? 'owner' : 'staff',
            ]);
        }

        // Kirim OTP pendaftaran
        $otpResponse = $this->otpService->sendOtp($user->phone, 'REGISTER');

        ActivityLog::create([
            'user_id' => $user->id,
            'activity' => 'Registrasi Akun Baru',
            'details' => "Pendaftaran akun baru: {$user->email} ({$user->role})",
            'ip_address' => $request->ip(),
            'user_agent' => $request->userAgent(),
        ]);

        $token = $user->createToken('auth_token')->plainTextToken;

        return response()->json([
            'status' => 'success',
            'message' => 'Registrasi berhasil. Silakan verifikasi OTP yang telah dikirim.',
            'data' => [
                'user' => $user->load('outlets'),
                'token' => $token,
                'otp' => $otpResponse,
            ]
        ], 201);
    }

    public function login(Request $request)
    {
        $request->validate([
            'identifier' => 'required|string', // Bisa email atau NIP/ID Karyawan
            'password' => 'required|string',
        ]);

        $identifier = $request->input('identifier');
        $user = User::where('email', $identifier)
                    ->orWhere('nip', $identifier)
                    ->first();

        if (!$user || !Hash::check($request->input('password'), $user->password)) {
            throw ValidationException::withMessages([
                'identifier' => ['Email/NIP atau kata sandi yang Anda masukkan salah.'],
            ]);
        }

        $user->tokens()->delete(); // Batasi 1 sesi aktif per login (single session token)
        $token = $user->createToken('auth_token')->plainTextToken;

        ActivityLog::create([
            'user_id' => $user->id,
            'activity' => 'Login Berhasil',
            'details' => "Login melalui API ({$user->role})",
            'ip_address' => $request->ip(),
            'user_agent' => $request->userAgent(),
        ]);

        return response()->json([
            'status' => 'success',
            'message' => 'Login berhasil.',
            'data' => [
                'user' => $user->load('outlets'),
                'token' => $token,
            ]
        ]);
    }

    public function logout(Request $request)
    {
        $user = $request->user();
        if ($user) {
            $user->currentAccessToken()->delete();

            ActivityLog::create([
                'user_id' => $user->id,
                'activity' => 'Logout',
                'details' => 'User keluar dari sistem.',
                'ip_address' => $request->ip(),
            ]);
        }

        return response()->json([
            'status' => 'success',
            'message' => 'Logout berhasil.',
        ]);
    }

    public function me(Request $request)
    {
        return response()->json([
            'status' => 'success',
            'data' => $request->user()->load('outlets'),
        ]);
    }

    public function updateProfile(Request $request)
    {
        $user = $request->user();

        $validated = $request->validate([
            'name' => 'sometimes|required|string|max:100',
            'phone' => 'sometimes|required|string|max:25',
            'avatar' => 'nullable|string',
        ]);

        $user->update($validated);

        return response()->json([
            'status' => 'success',
            'message' => 'Profil berhasil diperbarui.',
            'data' => $user->load('outlets'),
        ]);
    }

    public function sendOtp(Request $request)
    {
        $validated = $request->validate([
            'phone' => 'required|string',
            'type' => 'nullable|string|in:REGISTER,FORGOT_PASSWORD,ONBOARDING',
        ]);

        $res = $this->otpService->sendOtp($validated['phone'], $validated['type'] ?? 'REGISTER');

        return response()->json([
            'status' => 'success',
            'data' => $res,
        ]);
    }

    public function verifyOtp(Request $request)
    {
        $validated = $request->validate([
            'phone' => 'required|string',
            'otp_code' => 'required|string|size:6',
            'type' => 'nullable|string|in:REGISTER,FORGOT_PASSWORD,ONBOARDING',
        ]);

        $valid = $this->otpService->verifyOtp(
            $validated['phone'],
            $validated['otp_code'],
            $validated['type'] ?? 'REGISTER'
        );

        if (!$valid) {
            return response()->json([
                'status' => 'error',
                'message' => 'Kode OTP tidak valid atau telah kedaluwarsa.',
            ], 422);
        }

        // Aktifkan user jika sedang dalam alur registrasi
        $user = User::where('phone', $validated['phone'])->first();
        if ($user && $user->status === 'pending') {
            $user->update(['status' => 'active']);
        }

        return response()->json([
            'status' => 'success',
            'message' => 'Verifikasi OTP berhasil.',
        ]);
    }

    public function forgotPassword(Request $request)
    {
        $request->validate([
            'phone' => 'required|string',
        ]);

        $phone = $this->normalizePhone($request->input('phone'));
        $phoneVariants = $this->phoneVariants($phone);
        if (!User::whereIn('phone', $phoneVariants)->exists()) {
            return response()->json([
                'status' => 'error',
                'message' => 'Nomor HP belum terdaftar.',
            ], 422);
        }

        $res = $this->otpService->sendOtp($phone, 'FORGOT_PASSWORD');

        return response()->json([
            'status' => 'success',
            'message' => 'Kode verifikasi reset password telah dikirim ke nomor HP Anda.',
            'data' => $res,
        ]);
    }

    public function resetPassword(Request $request)
    {
        $validated = $request->validate([
            'phone' => 'required|string',
            'otp_code' => 'required|string|size:6',
            'new_password' => 'required|string|min:6',
        ]);

        $phone = $this->normalizePhone($validated['phone']);
        $valid = $this->otpService->verifyOtp($phone, $validated['otp_code'], 'FORGOT_PASSWORD');

        if (!$valid) {
            return response()->json([
                'status' => 'error',
                'message' => 'Kode OTP tidak valid atau telah kedaluwarsa.',
            ], 422);
        }

        $user = User::whereIn('phone', $this->phoneVariants($phone))->firstOrFail();
        $user->update(['password' => Hash::make($validated['new_password'])]);
        $user->tokens()->delete();

        return response()->json([
            'status' => 'success',
            'message' => 'Kata sandi Anda berhasil diperbarui. Silakan login kembali.',
        ]);
    }

    private function normalizePhone(string $phone): string
    {
        $normalizedPhone = preg_replace('/\D+/', '', $phone) ?? '';

        if (str_starts_with($normalizedPhone, '0')) {
            $normalizedPhone = '62' . substr($normalizedPhone, 1);
        } elseif (str_starts_with($normalizedPhone, '8')) {
            $normalizedPhone = '62' . $normalizedPhone;
        }

        return $normalizedPhone;
    }

    private function phoneVariants(string $normalizedPhone): array
    {
        $localPhone = str_starts_with($normalizedPhone, '62')
            ? '0' . substr($normalizedPhone, 2)
            : $normalizedPhone;

        return array_values(array_unique([$normalizedPhone, $localPhone]));
    }
}