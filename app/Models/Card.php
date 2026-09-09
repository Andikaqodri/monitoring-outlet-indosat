<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Card extends Model
{
    use HasFactory;

    protected $fillable = [
        'code',
        'name',
        'type',
        'package_name',
        'quota',
        'base_price',
        'description',
        'status',
    ];

    public function stocks()
    {
        return $this->hasMany(Stock::class);
    }

    public function mutations()
    {
        return $this->hasMany(StockMutation::class);
    }

    public function transactions()
    {
        return $this->hasMany(Transaction::class);
    }
}