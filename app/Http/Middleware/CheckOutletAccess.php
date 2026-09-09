<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class CheckOutletAccess
{
    public function handle(Request $request, Closure $next): Response
    {
        $user = $request->user();

        if (!$user) {
            return response()->json(['message' => 'Unauthenticated.'], 401);
        }

        if (in_array($user->role, ['admin', 'cse'])) {
            return $next($request);
        }

        $outletId = $request->route('outlet') 
            ?? $request->route('outletId') 
            ?? $request->route('id')
            ?? $request->input('outlet_id');

        if (is_object($outletId) && isset($outletId->id)) {
            $outletId = $outletId->id;
        }

        if ($outletId && !$user->hasOutletAccess($outletId)) {
            return response()->json([
                'status' => 'error',
                'message' => 'Akses ditolak. Anda tidak memiliki otorisasi untuk mengakses data Outlet ini.'
            ], 403);
        }

        return $next($request);
    }
}