<?php

namespace Database\Seeders;

use App\Models\Card;
use App\Models\Outlet;
use App\Models\Stock;
use App\Models\StockBatch;
use App\Models\StockMutation;
use App\Models\Supplier;
use App\Models\Transaction;
use App\Models\User;
use App\Models\UserOutlet;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class DatabaseSeeder extends Seeder
{
    public function run(): void
    {
        // 1. Users
        $admin = User::create([
            'name' => 'Administrator Kayoon',
            'email' => 'admin@indosat.com',
            'nip' => 'IND-001',
            'phone' => '085700000001',
            'role' => 'admin',
            'password' => Hash::make('password'),
            'status' => 'active',
        ]);

        $cse = User::create([
            'name' => 'CSE Area Surabaya',
            'email' => 'cse.surabaya@indosat.com',
            'nip' => 'IND-002',
            'phone' => '085700000002',
            'role' => 'cse',
            'password' => Hash::make('password'),
            'status' => 'active',
        ]);

        $owner = User::create([
            'name' => 'Budi Santoso (Owner Kayoon)',
            'email' => 'owner.kayoon@mitra.com',
            'nip' => 'MTR-001',
            'phone' => '085700000003',
            'role' => 'outlet_owner',
            'password' => Hash::make('password'),
            'status' => 'active',
        ]);

        $sales = User::create([
            'name' => 'Ahmad Sales Kayoon',
            'email' => 'sales.kayoon@mitra.com',
            'nip' => 'SLS-001',
            'phone' => '085700000004',
            'role' => 'sales',
            'password' => Hash::make('password'),
            'status' => 'active',
        ]);

        // 2. Outlets
        $outlets = [
            [
                'code' => 'OUT-SUB-01',
                'name' => 'Gerai Indosat Kayoon (Pusat)',
                'owner_name' => 'Budi Santoso',
                'phone' => '031-5345678',
                'address' => 'Jl. Kayoon No 72, Genteng, Surabaya',
                'type' => 'Gerai Resmi',
                'cluster' => 'Surabaya Pusat',
                'status' => 'ACTIVE',
            ],
            [
                'code' => 'OUT-SUB-02',
                'name' => 'Gerai IM3 Mall Galaxy',
                'owner_name' => 'Siti Rahmawati',
                'phone' => '031-5934567',
                'address' => 'Galaxy Mall Lt. 2 No. 245, Dharmahusada, Surabaya',
                'type' => 'Gerai Mall',
                'cluster' => 'Surabaya Timur',
                'status' => 'ACTIVE',
            ],
            [
                'code' => 'OUT-SUB-03',
                'name' => 'Gerai IM3 Tunjungan Plaza',
                'owner_name' => 'Dimas Pratama',
                'phone' => '031-5478901',
                'address' => 'Tunjungan Plaza 3 Lt. 3, Jl. Basuki Rahmat, Surabaya',
                'type' => 'Gerai Mall',
                'cluster' => 'Surabaya Pusat',
                'status' => 'ACTIVE',
            ],
            [
                'code' => 'OUT-SUB-04',
                'name' => 'Mitra Berkah Cell Wiyung',
                'owner_name' => 'Hendra Wijaya',
                'phone' => '085711223344',
                'address' => 'Jl. Raya Menganti No. 45, Wiyung, Surabaya',
                'type' => 'Mitra Kios',
                'cluster' => 'Surabaya Barat',
                'status' => 'ACTIVE',
            ],
        ];

        $createdOutlets = [];
        foreach ($outlets as $item) {
            $createdOutlets[] = Outlet::create($item);
        }

        // 3. User Outlets
        UserOutlet::create(['user_id' => $owner->id, 'outlet_id' => $createdOutlets[0]->id, 'role_in_outlet' => 'owner']);
        UserOutlet::create(['user_id' => $sales->id, 'outlet_id' => $createdOutlets[0]->id, 'role_in_outlet' => 'staff']);

        // 4. Suppliers
        $supplier = Supplier::create([
            'code' => 'SUPP-001',
            'name' => 'PT Distribusi Seluler Nusantara',
            'contact_person' => 'Hartono',
            'phone' => '021-5556677',
            'address' => 'Kawasan Industri Rungkut, Surabaya',
            'status' => 'ACTIVE',
        ]);

        // 5. Cards / CCIB
        $cards = [
            [
                'code' => 'CCIB-FI-03',
                'name' => 'Freedom Internet 3GB',
                'type' => 'CCIB',
                'package_name' => 'Freedom Internet 3GB',
                'quota' => '3 GB',
                'base_price' => 25000.00,
                'description' => '100% Kuota Utama 24 Jam Nasional',
                'status' => 'ACTIVE',
            ],
            [
                'code' => 'CCIB-FI-09',
                'name' => 'Freedom Internet 9GB',
                'type' => 'CCIB',
                'package_name' => 'Freedom Internet 9GB',
                'quota' => '9 GB',
                'base_price' => 40000.00,
                'description' => 'Kuota Utama 9GB + Nelpon Sepuasnya',
                'status' => 'ACTIVE',
            ],
            [
                'code' => 'CCIB-FI-25',
                'name' => 'Freedom Internet 25GB',
                'type' => 'CCIB',
                'package_name' => 'Freedom Internet 25GB',
                'quota' => '25 GB',
                'base_price' => 75000.00,
                'description' => 'Kuota Utama 25GB 5G Ready',
                'status' => 'ACTIVE',
            ],
            [
                'code' => 'CCIB-FI-50',
                'name' => 'Freedom Internet 50GB',
                'type' => 'CCIB',
                'package_name' => 'Freedom Internet 50GB',
                'quota' => '50 GB',
                'base_price' => 120000.00,
                'description' => 'Super Kuota 50GB Prioritas',
                'status' => 'ACTIVE',
            ],
        ];

        $createdCards = [];
        foreach ($cards as $c) {
            $createdCards[] = Card::create($c);
        }

        // 6. Stocks & Batches
        foreach ($createdOutlets as $o) {
            foreach ($createdCards as $c) {
                $qty = 50;
                Stock::create([
                    'outlet_id' => $o->id,
                    'card_id' => $c->id,
                    'current_stock' => $qty,
                ]);

                StockMutation::create([
                    'outlet_id' => $o->id,
                    'card_id' => $c->id,
                    'type' => 'STOCK_IN',
                    'qty' => $qty,
                    'previous_stock' => 0,
                    'current_stock' => $qty,
                    'reference_no' => 'INIT-BATCH-' . $o->id . '-' . $c->id,
                    'user_id' => $admin->id,
                    'notes' => 'Stok awal setup outlet',
                ]);
            }
        }

        // 7. Dummy Sale Transaction
        Transaction::create([
            'transaction_no' => 'TRX-' . date('Ymd') . '-0001',
            'outlet_id' => $createdOutlets[0]->id,
            'user_id' => $sales->id,
            'card_id' => $createdCards[2]->id, // 25GB
            'qty' => 1,
            'unit_price' => 75000.00,
            'total_price' => 75000.00,
            'customer_name' => 'Rizky Maulana',
            'customer_phone' => '085712345678',
            'status' => 'SUCCESS',
            'transaction_date' => now(),
        ]);
    }
}