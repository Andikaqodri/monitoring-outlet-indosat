<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('stocks', function (Blueprint $table) {
            $table->id();
            $table->foreignId('outlet_id')->constrained()->cascadeOnDelete();
            $table->foreignId('card_id')->constrained()->cascadeOnDelete();
            $table->integer('current_stock')->default(0);
            $table->timestamps();

            $table->unique(['outlet_id', 'card_id']);
        });

        Schema::create('stock_batches', function (Blueprint $table) {
            $table->id();
            $table->string('batch_no', 60)->unique();
            $table->foreignId('supplier_id')->nullable()->constrained()->nullOnDelete();
            $table->foreignId('outlet_id')->constrained()->cascadeOnDelete();
            $table->foreignId('card_id')->constrained()->cascadeOnDelete();
            $table->integer('qty');
            $table->date('received_date');
            $table->foreignId('received_by')->nullable()->constrained('users')->nullOnDelete();
            $table->text('notes')->nullable();
            $table->timestamps();
        });

        Schema::create('stock_mutations', function (Blueprint $table) {
            $table->id();
            $table->foreignId('outlet_id')->constrained()->cascadeOnDelete();
            $table->foreignId('card_id')->constrained()->cascadeOnDelete();
            $table->string('type', 30); // STOCK_IN, SALE, RETURN, ADJUSTMENT, TRANSFER, REPLACEMENT
            $table->integer('qty');
            $table->integer('previous_stock');
            $table->integer('current_stock');
            $table->string('reference_no', 80)->nullable();
            $table->foreignId('user_id')->nullable()->constrained()->nullOnDelete();
            $table->text('notes')->nullable();
            $table->timestamps();

            $table->index(['outlet_id', 'card_id', 'type']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('stock_mutations');
        Schema::dropIfExists('stock_batches');
        Schema::dropIfExists('stocks');
    }
};