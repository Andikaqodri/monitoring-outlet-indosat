<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Transaction;
use App\Services\TransactionService;
use Exception;
use Illuminate\Http\Request;

class TransactionController extends Controller
{
    public function __construct(protected TransactionService $transactionService) {}

    public function store(Request $request)
    {
        $validated = $request->validate([
            'outlet_id' => 'required|exists:outlets,id',
            'card_id' => 'required|exists:cards,id',
            'qty' => 'required|integer|min:1',
            'customer_name' => 'nullable|string|max:100',
            'customer_phone' => 'nullable|string|max:25',
        ]);

        $user = $request->user();
        if (!$user->hasOutletAccess($validated['outlet_id'])) {
            return response()->json(['message' => 'Akses ditolak ke outlet ini.'], 403);
        }

        try {
            $transaction = $this->transactionService->createSale($validated, $user->id);

            return response()->json([
                'status' => 'success',
                'message' => 'Transaksi penjualan berhasil diproses.',
                'data' => $transaction->load(['outlet', 'card', 'user']),
            ], 201);
        } catch (Exception $e) {
            return response()->json([
                'status' => 'error',
                'message' => $e->getMessage(),
            ], 422);
        }
    }

    public function index(Request $request)
    {
        $user = $request->user();
        $query = Transaction::with(['outlet', 'card', 'user']);

        if (!in_array($user->role, ['admin', 'cse'])) {
            $allowedOutletIds = $user->outlets()->pluck('outlets.id')->toArray();
            $query->whereIn('outlet_id', $allowedOutletIds);
        } elseif ($request->filled('outlet_id')) {
            $query->where('outlet_id', $request->outlet_id);
        }

        if ($request->filled('status')) {
            $query->where('status', $request->status);
        }

        if ($request->filled('date')) {
            $query->whereDate('transaction_date', $request->date);
        }

        $transactions = $query->latest('transaction_date')->paginate($request->input('per_page', 15));

        return response()->json([
            'status' => 'success',
            'data' => $transactions,
        ]);
    }

    public function show(Request $request, $id)
    {
        $user = $request->user();
        $transaction = Transaction::with(['outlet', 'card', 'user'])->findOrFail($id);

        if (!$user->hasOutletAccess($transaction->outlet_id)) {
            return response()->json(['message' => 'Akses ditolak.'], 403);
        }

        return response()->json([
            'status' => 'success',
            'data' => $transaction,
        ]);
    }
}