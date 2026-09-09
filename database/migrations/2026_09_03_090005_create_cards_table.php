<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('cards', function (Blueprint $table) {
            $table->id();
            $table->string('code', 50)->unique(); // e.g. CCIB-001
            $table->string('name', 150); // e.g. Kartu Perdana Freedom Internet 25GB
            $table->string('type', 50)->default('CCIB'); // CCIB, PERDANA, POSTPAID
            $table->string('package_name', 100)->nullable();
            $table->string('quota', 50)->nullable();
            $table->decimal('base_price', 12, 2)->default(0);
            $table->text('description')->nullable();
            $table->string('status', 20)->default('ACTIVE');
            $table->timestamps();

            $table->index(['type', 'status']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('cards');
    }
};