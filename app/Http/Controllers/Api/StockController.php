<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Stock;
use App\Models\StockBatch;
use App\Models\StockMutation;
use App\Services\StockService;
use Illuminate\Http\Request;
use Illuminate\Support\Str;

class StockController extends Controller
{
    public function __construct(protected StockService $stockService) {}

    public function index(Request $request, $outletId)
    {
        $user = $request->user();
        if (!$user->hasOutletAccess($outletId)) {
            return response()->json(['message' => 'Akses ditolak.'], 403);
        }

        $stocks = Stock::with('card')
                       ->where('outlet_id', $outletId)
                       ->get();

        return response()->json([
            'status' => 'success',
            'data' => $stocks,
        ]);
    }

    public function stockIn(Request $request)
    {
        $validated = $request->validate([
            'outlet_id' => 'required|exists:outlets,id',
            'card_id' => 'required|exists:cards,id',
            'supplier_id' => 'nullable|exists:suppliers,id',
            'qty' => 'required|integer|min:1',
            'batch_no' => 'nullable|string',
            'received_date' => 'nullable|date',
            'notes' => 'nullable|string',
        ]);

        $batchNo = $validated['batch_no'] ?? 'BATCH-' . date('Ymd') . '-' . strtoupper(Str::random(5));
        $receivedDate = $validated['received_date'] ?? date('Y-m-d');

        // Simpan penerimaan batch
        $batch = StockBatch::create([
            'batch_no' => $batchNo,
            'supplier_id' => $validated['supplier_id'] ?? null,
            'outlet_id' => $validated['outlet_id'],
            'card_id' => $validated['card_id'],
            'qty' => $validated['qty'],
            'received_date' => $receivedDate,
            'received_by' => $request->user()->id,
            'notes' => $validated['notes'] ?? 'Penerimaan stok dari supplier',
        ]);

        // Tambah saldo stok secara atomik
        $stock = $this->stockService->addStock(
            outletId: $validated['outlet_id'],
            cardId: $validated['card_id'],
            qty: $validated['qty'],
            type: 'STOCK_IN',
            referenceNo: $batchNo,
            userId: $request->user()->id,
            notes: 'Kartu masuk batch: ' . $batchNo
        );

        return response()->json([
            'status' => 'success',
            'message' => 'Stok kartu berhasil ditambahkan ke outlet.',
            'data' => [
                'batch' => $batch,
                'current_stock' => $stock->current_stock,
            ]
        ], 201);
    }

    public function mutations(Request $request, $outletId)
    {
        $user = $request->user();
        if (!$user->hasOutletAccess($outletId)) {
            return response()->json(['message' => 'Akses ditolak.'], 403);
        }

        $query = StockMutation::with(['card', 'user'])
                              ->where('outlet_id', $outletId);

        if ($request->filled('type')) {
            $query->where('type', $request->type);
        }

        if ($request->filled('card_id')) {
            $query->where('card_id', $request->card_id);
        }

        $mutations = $query->latest()->paginate($request->input('per_page', 20));

        return response()->json([
            'status' => 'success',
            'data' => $mutations,
        ]);
    }
}