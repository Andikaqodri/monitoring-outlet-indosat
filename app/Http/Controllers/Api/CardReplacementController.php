<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\CardReplacement;
use Illuminate\Http\Request;
use Illuminate\Support\Str;

class CardReplacementController extends Controller
{
    public function store(Request $request)
    {
        $validated = $request->validate([
            'outlet_id' => 'required|exists:outlets,id',
            'customer_name' => 'required|string|max:100',
            'customer_nik' => 'required|string|size:16',
            'customer_phone' => 'required|string|max:25',
            'old_iccid' => 'required|string|max:30',
            'new_iccid' => 'required|string|max:30',
            'reason' => 'nullable|string|max:100',
            'fee' => 'nullable|numeric|min:0',
        ]);

        $user = $request->user();
        if (!$user->hasOutletAccess($validated['outlet_id'])) {
            return response()->json(['message' => 'Akses ditolak ke outlet ini.'], 403);
        }

        $ticketNo = 'REP-' . date('Ymd') . '-' . strtoupper(Str::random(6));

        $replacement = CardReplacement::create([
            'ticket_no' => $ticketNo,
            'outlet_id' => $validated['outlet_id'],
            'user_id' => $user->id,
            'customer_name' => $validated['customer_name'],
            'customer_nik' => $validated['customer_nik'],
            'customer_phone' => $validated['customer_phone'],
            'old_iccid' => $validated['old_iccid'],
            'new_iccid' => $validated['new_iccid'],
            'reason' => $validated['reason'] ?? 'Rusak / Tidak Terbaca',
            'fee' => $validated['fee'] ?? 25000.00,
            'status' => 'COMPLETED',
        ]);

        return response()->json([
            'status' => 'success',
            'message' => 'Permohonan ganti kartu berhasil diproses.',
            'data' => $replacement->load(['outlet', 'user']),
        ], 201);
    }

    public function index(Request $request)
    {
        $user = $request->user();
        $query = CardReplacement::with(['outlet', 'user']);

        if (!in_array($user->role, ['admin', 'cse'])) {
            $allowedOutletIds = $user->outlets()->pluck('outlets.id')->toArray();
            $query->whereIn('outlet_id', $allowedOutletIds);
        } elseif ($request->filled('outlet_id')) {
            $query->where('outlet_id', $request->outlet_id);
        }

        if ($request->filled('status')) {
            $query->where('status', $request->status);
        }

        $items = $query->latest()->paginate($request->input('per_page', 15));

        return response()->json([
            'status' => 'success',
            'data' => $items,
        ]);
    }
}