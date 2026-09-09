<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Stock extends Model
{
    protected $fillable = [
        'outlet_id',
        'card_id',
        'current_stock',
    ];

    public function outlet()
    {
        return $this->belongsTo(Outlet::class);
    }

    public function card()
    {
        return $this->belongsTo(Card::class);
    }
}