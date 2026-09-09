<?php

namespace App\Services;

use App\Models\ActivityLog;
use App\Models\Card;
use App\Models\Transaction;
use Exception;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

class TransactionService
{
    public function __construct(protected StockService $stockService) {}

    public function createSale(array $data, int $userId): Transaction
    {
        return DB::transaction(function () use ($data, $userId) {
            $card = Card::findOrFail($data['card_id']);
            $qty = $data['qty'] ?? 1;
            $unitPrice = $card->base_price;
            $totalPrice = $unitPrice * $qty;
            $transactionNo = 'TRX-' . date('Ymd') . '-' . strtoupper(Str::random(6));

            // Kurangi stok secara atomik
            $this->stockService->reduceStock(
                outletId: $data['outlet_id'],
                cardId: $card->id,
                qty: $qty,
                type: 'SALE',
                referenceNo: $transactionNo,
                userId: $userId,
                notes: 'Penjualan kartu CCIB: ' . $card->name
            );

            $transaction = Transaction::create([
                'transaction_no' => $transactionNo,
                'outlet_id' => $data['outlet_id'],
                'user_id' => $userId,
                'card_id' => $card->id,
                'qty' => $qty,
                'unit_price' => $unitPrice,
                'total_price' => $totalPrice,
                'customer_name' => $data['customer_name'] ?? null,
                'customer_phone' => $data['customer_phone'] ?? null,
                'status' => 'SUCCESS',
                'transaction_date' => now(),
            ]);

            ActivityLog::create([
                'user_id' => $userId,
                'activity' => 'Transaksi Penjualan',
                'details' => "Penjualan $qty unit {$card->name} di outlet ID {$data['outlet_id']} ($transactionNo)",
                'ip_address' => request()->ip(),
            ]);

            return $transaction;
        });
    }
}