<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class StockMutation extends Model
{
    protected $fillable = [
        'outlet_id',
        'card_id',
        'type',
        'qty',
        'previous_stock',
        'current_stock',
        'reference_no',
        'user_id',
        'notes',
    ];

    public function outlet()
    {
        return $this->belongsTo(Outlet::class);
    }

    public function card()
    {
        return $this->belongsTo(Card::class);
    }

    public function user()
    {
        return $this->belongsTo(User::class);
    }
}