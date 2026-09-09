<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Card;
use Illuminate\Http\Request;

class CardController extends Controller
{
    public function index(Request $request)
    {
        $query = Card::query();

        if ($request->filled('type')) {
            $query->where('type', $request->type);
        }

        if ($request->filled('status')) {
            $query->where('status', $request->status);
        }

        $cards = $query->get();

        return response()->json([
            'status' => 'success',
            'data' => $cards,
        ]);
    }

    public function show($id)
    {
        $card = Card::with('stocks.outlet')->findOrFail($id);

        return response()->json([
            'status' => 'success',
            'data' => $card,
        ]);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'code' => 'required|string|unique:cards,code',
            'name' => 'required|string|max:150',
            'type' => 'nullable|string|in:CCIB,PERDANA,POSTPAID',
            'package_name' => 'nullable|string',
            'quota' => 'nullable|string',
            'base_price' => 'required|numeric|min:0',
            'description' => 'nullable|string',
        ]);

        $card = Card::create($validated);

        return response()->json([
            'status' => 'success',
            'message' => 'Produk kartu CCIB berhasil ditambahkan.',
            'data' => $card,
        ], 201);
    }
}