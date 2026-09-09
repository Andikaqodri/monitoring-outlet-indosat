<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('card_replacements', function (Blueprint $table) {
            $table->id();
            $table->string('ticket_no', 60)->unique();
            $table->foreignId('outlet_id')->constrained()->cascadeOnDelete();
            $table->foreignId('user_id')->nullable()->constrained()->nullOnDelete();
            $table->string('customer_name', 100);
            $table->string('customer_nik', 16);
            $table->string('customer_phone', 25);
            $table->string('old_iccid', 30);
            $table->string('new_iccid', 30);
            $table->string('reason', 100)->default('Rusak / Tidak Terbaca');
            $table->decimal('fee', 12, 2)->default(25000.00);
            $table->string('status', 20)->default('COMPLETED'); // PENDING, APPROVED, COMPLETED, REJECTED
            $table->string('evidence_file_path')->nullable();
            $table->timestamps();

            $table->index(['outlet_id', 'status']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('card_replacements');
    }
};