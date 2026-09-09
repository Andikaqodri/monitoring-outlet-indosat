<?php

use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\CardController;
use App\Http\Controllers\Api\CardReplacementController;
use App\Http\Controllers\Api\DashboardController;
use App\Http\Controllers\Api\OnboardingController;
use App\Http\Controllers\Api\OutletController;
use App\Http\Controllers\Api\ReelController;
use App\Http\Controllers\Api\StockController;
use App\Http\Controllers\Api\TransactionController;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes - Indosat Monitoring Outlet & Kartu/CCIB
|--------------------------------------------------------------------------
*/

Route::prefix('v1')->group(function () {

    // === 1. AUTHENTICATION & OTP (PUBLIC) ===
    Route::post('/auth/register', [AuthController::class, 'register']);
    Route::post('/auth/login', [AuthController::class, 'login']);
    Route::post('/otp/send', [AuthController::class, 'sendOtp']);
    Route::post('/otp/verify', [AuthController::class, 'verifyOtp']);
    Route::post('/auth/forgot-password', [AuthController::class, 'forgotPassword']);
    Route::post('/auth/reset-password', [AuthController::class, 'resetPassword']);

    // === 2. PROTECTED ROUTES (SANCTUM BEARER TOKEN) ===
    Route::middleware('auth:sanctum')->group(function () {

        // User & Profile
        Route::get('/auth/me', [AuthController::class, 'me']);
        Route::put('/auth/profile', [AuthController::class, 'updateProfile']);
        Route::post('/auth/logout', [AuthController::class, 'logout']);

        // Dashboard Metrics Overview
        Route::get('/dashboard/overview', [DashboardController::class, 'overview']);

        // Outlets (Scoping via user access)
        Route::get('/outlets', [OutletController::class, 'index']);
        Route::get('/outlets/{id}', [OutletController::class, 'show']);
        Route::post('/outlets', [OutletController::class, 'store']);
        Route::put('/outlets/{id}', [OutletController::class, 'update']);

        // Onboarding, Agreement & Approval
        Route::post('/onboarding/agreement', [OnboardingController::class, 'submitAgreement']);
        Route::post('/onboarding/evidence', [OnboardingController::class, 'uploadEvidence']);
        Route::get('/onboarding/status/{outletId}', [OnboardingController::class, 'status']);
        Route::post('/onboarding/approve/{outletId}', [OnboardingController::class, 'approve']);

        // Cards / CCIB Master Catalogue
        Route::get('/cards', [CardController::class, 'index']);
        Route::get('/cards/{id}', [CardController::class, 'show']);
        Route::post('/cards', [CardController::class, 'store']);

        // Stocks & Mutasi
        Route::get('/outlets/{outletId}/stocks', [StockController::class, 'index']);
        Route::post('/stocks/in', [StockController::class, 'stockIn']);
        Route::get('/outlets/{outletId}/stocks/mutations', [StockController::class, 'mutations']);

        // Transaksi Penjualan
        Route::post('/transactions', [TransactionController::class, 'store']);
        Route::get('/transactions', [TransactionController::class, 'index']);
        Route::get('/transactions/{id}', [TransactionController::class, 'show']);

        // Layanan Ganti Kartu
        Route::post('/card-replacements', [CardReplacementController::class, 'store']);
        Route::get('/card-replacements', [CardReplacementController::class, 'index']);

        // Reels (Video Pendek)
        Route::get('/reels', [ReelController::class, 'index']);
        Route::post('/reels', [ReelController::class, 'store']);
        Route::post('/reels/{id}/like', [ReelController::class, 'like']);
    });
});