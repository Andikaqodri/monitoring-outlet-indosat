<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('user_outlets', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->cascadeOnDelete();
            $table->foreignId('outlet_id')->constrained()->cascadeOnDelete();
            $table->string('role_in_outlet', 50)->default('staff'); // owner, supervisor, staff
            $table->timestamps();

            $table->unique(['user_id', 'outlet_id']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('user_outlets');
    }
};