<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class StockBatch extends Model
{
    protected $fillable = [
        'batch_no',
        'supplier_id',
        'outlet_id',
        'card_id',
        'qty',
        'received_date',
        'received_by',
        'notes',
    ];

    protected $casts = [
        'received_date' => 'date',
    ];

    public function supplier()
    {
        return $this->belongsTo(Supplier::class);
    }

    public function outlet()
    {
        return $this->belongsTo(Outlet::class);
    }

    public function card()
    {
        return $this->belongsTo(Card::class);
    }

    public function receiver()
    {
        return $this->belongsTo(User::class, 'received_by');
    }
}