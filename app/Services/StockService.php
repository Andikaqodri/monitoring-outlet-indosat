<?php

namespace App\Services;

use App\Models\Stock;
use App\Models\StockMutation;
use Exception;
use Illuminate\Support\Facades\DB;

class StockService
{
    public function addStock(
        int $outletId,
        int $cardId,
        int $qty,
        string $type = 'STOCK_IN',
        ?string $referenceNo = null,
        ?int $userId = null,
        ?string $notes = null
    ): Stock {
        return DB::transaction(function () use ($outletId, $cardId, $qty, $type, $referenceNo, $userId, $notes) {
            $stock = Stock::firstOrCreate(
                ['outlet_id' => $outletId, 'card_id' => $cardId],
                ['current_stock' => 0]
            );

            $prevStock = $stock->current_stock;
            $newStock = $prevStock + $qty;

            $stock->update(['current_stock' => $newStock]);

            StockMutation::create([
                'outlet_id' => $outletId,
                'card_id' => $cardId,
                'type' => $type,
                'qty' => $qty,
                'previous_stock' => $prevStock,
                'current_stock' => $newStock,
                'reference_no' => $referenceNo,
                'user_id' => $userId,
                'notes' => $notes,
            ]);

            return $stock;
        });
    }

    public function reduceStock(
        int $outletId,
        int $cardId,
        int $qty,
        string $type = 'SALE',
        ?string $referenceNo = null,
        ?int $userId = null,
        ?string $notes = null
    ): Stock {
        return DB::transaction(function () use ($outletId, $cardId, $qty, $type, $referenceNo, $userId, $notes) {
            $stock = Stock::where('outlet_id', $outletId)
                          ->where('card_id', $cardId)
                          ->lockForUpdate()
                          ->first();

            if (!$stock || $stock->current_stock < $qty) {
                $available = $stock ? $stock->current_stock : 0;
                throw new Exception("Stok tidak mencukupi untuk outlet ID $outletId. Tersedia: $available, Dibutuhkan: $qty.");
            }

            $prevStock = $stock->current_stock;
            $newStock = $prevStock - $qty;

            $stock->update(['current_stock' => $newStock]);

            StockMutation::create([
                'outlet_id' => $outletId,
                'card_id' => $cardId,
                'type' => $type,
                'qty' => -$qty,
                'previous_stock' => $prevStock,
                'current_stock' => $newStock,
                'reference_no' => $referenceNo,
                'user_id' => $userId,
                'notes' => $notes,
            ]);

            return $stock;
        });
    }
}