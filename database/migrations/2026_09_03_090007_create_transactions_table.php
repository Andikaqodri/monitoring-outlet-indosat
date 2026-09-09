<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('transactions', function (Blueprint $table) {
            $table->id();
            $table->string('transaction_no', 60)->unique();
            $table->foreignId('outlet_id')->constrained()->cascadeOnDelete();
            $table->foreignId('user_id')->nullable()->constrained()->nullOnDelete();
            $table->foreignId('card_id')->constrained()->cascadeOnDelete();
            $table->integer('qty')->default(1);
            $table->decimal('unit_price', 12, 2);
            $table->decimal('total_price', 12, 2);
            $table->string('customer_name', 100)->nullable();
            $table->string('customer_phone', 25)->nullable();
            $table->string('status', 20)->default('SUCCESS'); // SUCCESS, PENDING, CANCELLED
            $table->timestamp('transaction_date')->useCurrent();
            $table->timestamps();

            $table->index(['outlet_id', 'transaction_date', 'status']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('transactions');
    }
};