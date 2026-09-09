<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\ActivityLog;
use App\Models\CardReplacement;
use App\Models\Outlet;
use App\Models\Stock;
use App\Models\Transaction;
use Carbon\Carbon;
use Illuminate\Http\Request;

class DashboardController extends Controller
{
    public function overview(Request $request)
    {
        $user = $request->user();

        // Scope outlet IDs
        if (in_array($user->role, ['admin', 'cse'])) {
            $outletIds = Outlet::pluck('id')->toArray();
        } else {
            $outletIds = $user->outlets()->pluck('outlets.id')->toArray();
        }

        $today = Carbon::today();

        // Metrik Transaksi
        $txQuery = Transaction::whereIn('outlet_id', $outletIds);
        $txToday = (clone $txQuery)->whereDate('transaction_date', $today)->get();

        $totalTxCountToday = $txToday->count();
        $successTxToday = $txToday->where('status', 'SUCCESS')->count();
        $pendingTxToday = $txToday->where('status', 'PENDING')->count();
        $failedTxToday = $txToday->where('status', 'CANCELLED')->count();
        $omsetToday = $txToday->where('status', 'SUCCESS')->sum('total_price');

        // Target harian (dinamis atau persentase tercapai)
        $dailyTarget = 500000.00 * max(1, count($outletIds));
        $targetPercentage = $dailyTarget > 0 ? round(($omsetToday / $dailyTarget) * 100, 1) : 0;

        // Metrik Stok Kartu/CCIB
        $totalStock = Stock::whereIn('outlet_id', $outletIds)->sum('current_stock');
        $lowStocks = Stock::with(['card', 'outlet'])
                          ->whereIn('outlet_id', $outletIds)
                          ->where('current_stock', '<=', 10)
                          ->get();

        // Ganti kartu hari ini
        $replacementsToday = CardReplacement::whereIn('outlet_id', $outletIds)
                                            ->whereDate('created_at', $today)
                                            ->count();

        // Transaksi terbaru
        $recentTransactions = Transaction::with(['outlet', 'card'])
                                          ->whereIn('outlet_id', $outletIds)
                                          ->latest('transaction_date')
                                          ->take(5)
                                          ->get();

        // Log aktivitas terbaru
        $recentLogs = ActivityLog::latest()->take(5)->get();

        return response()->json([
            'status' => 'success',
            'data' => [
                'outlets_count' => count($outletIds),
                'transactions_today' => [
                    'total' => $totalTxCountToday,
                    'success' => $successTxToday,
                    'pending' => $pendingTxToday,
                    'failed' => $failedTxToday,
                    'omset' => $omsetToday,
                    'target_daily' => $dailyTarget,
                    'target_percentage' => $targetPercentage,
                ],
                'stocks' => [
                    'total_units' => $totalStock,
                    'low_stock_count' => $lowStocks->count(),
                    'low_stock_items' => $lowStocks,
                ],
                'card_replacements_today' => $replacementsToday,
                'recent_transactions' => $recentTransactions,
                'recent_activities' => $recentLogs,
            ]
        ]);
    }
}