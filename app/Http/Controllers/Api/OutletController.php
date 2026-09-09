<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Outlet;
use Illuminate\Http\Request;
use Illuminate\Support\Str;

class OutletController extends Controller
{
    public function index(Request $request)
    {
        $user = $request->user();
        $query = Outlet::query();

        // Authorization filter: Admin & CSE lihat semua, staf/owner hanya lihat outletnya
        if (!in_array($user->role, ['admin', 'cse'])) {
            $allowedOutletIds = $user->outlets()->pluck('outlets.id')->toArray();
            $query->whereIn('id', $allowedOutletIds);
        }

        if ($request->filled('cluster')) {
            $query->where('cluster', 'like', "%{$request->cluster}%");
        }

        if ($request->filled('status')) {
            $query->where('status', $request->status);
        }

        if ($request->filled('search')) {
            $s = $request->search;
            $query->where(function ($q) use ($s) {
                $q->where('name', 'like', "%$s%")
                  ->orWhere('code', 'like', "%$s%")
                  ->orWhere('owner_name', 'like', "%$s%");
            });
        }

        $outlets = $query->withCount('stocks')->paginate($request->input('per_page', 15));

        return response()->json([
            'status' => 'success',
            'data' => $outlets,
        ]);
    }

    public function show(Request $request, $id)
    {
        $user = $request->user();

        if (!$user->hasOutletAccess($id)) {
            return response()->json([
                'status' => 'error',
                'message' => 'Akses ditolak ke outlet ini.'
            ], 403);
        }

        $outlet = Outlet::with(['stocks.card', 'users', 'onboarding'])->findOrFail($id);

        return response()->json([
            'status' => 'success',
            'data' => $outlet,
        ]);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'name' => 'required|string|max:150',
            'owner_name' => 'required|string|max:100',
            'phone' => 'required|string|max:25',
            'address' => 'required|string',
            'type' => 'nullable|string',
            'cluster' => 'nullable|string',
            'code' => 'nullable|string|unique:outlets,code',
        ]);

        if (empty($validated['code'])) {
            $validated['code'] = 'OUT-' . strtoupper(Str::random(6));
        }

        $outlet = Outlet::create($validated);

        return response()->json([
            'status' => 'success',
            'message' => 'Outlet berhasil ditambahkan.',
            'data' => $outlet,
        ], 201);
    }

    public function update(Request $request, $id)
    {
        $outlet = Outlet::findOrFail($id);

        $validated = $request->validate([
            'name' => 'sometimes|required|string|max:150',
            'owner_name' => 'sometimes|required|string|max:100',
            'phone' => 'sometimes|required|string|max:25',
            'address' => 'sometimes|required|string',
            'type' => 'nullable|string',
            'cluster' => 'nullable|string',
            'status' => 'nullable|string|in:ACTIVE,PENDING,INACTIVE,REJECTED',
        ]);

        $outlet->update($validated);

        return response()->json([
            'status' => 'success',
            'message' => 'Data outlet berhasil diperbarui.',
            'data' => $outlet,
        ]);
    }
}