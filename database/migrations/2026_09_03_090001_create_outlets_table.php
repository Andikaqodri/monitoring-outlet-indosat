<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('outlets', function (Blueprint $table) {
            $table->id();
            $table->string('code', 50)->unique();
            $table->string('name', 150);
            $table->string('owner_name', 100);
            $table->string('phone', 25);
            $table->text('address');
            $table->string('type', 50)->default('Gerai Mitra');
            $table->string('cluster', 100)->default('Surabaya Pusat');
            $table->string('status', 20)->default('ACTIVE'); // ACTIVE, PENDING, INACTIVE, REJECTED
            $table->timestamps();
            
            $table->index(['cluster', 'status']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('outlets');
    }
};