<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('outlet_onboardings', function (Blueprint $table) {
            $table->id();
            $table->foreignId('outlet_id')->constrained()->cascadeOnDelete();
            $table->foreignId('user_id')->nullable()->constrained()->nullOnDelete();
            $table->boolean('agreement_signed')->default(false);
            $table->timestamp('agreement_signed_at')->nullable();
            $table->boolean('otp_verified')->default(false);
            $table->timestamp('otp_verified_at')->nullable();
            $table->string('approval_status', 20)->default('PENDING'); // PENDING, APPROVED, REJECTED
            $table->foreignId('approved_by')->nullable()->constrained('users')->nullOnDelete();
            $table->string('evidence_file_path')->nullable();
            $table->text('notes')->nullable();
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('outlet_onboardings');
    }
};