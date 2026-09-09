<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Outlet extends Model
{
    use HasFactory;

    protected $fillable = [
        'code',
        'name',
        'owner_name',
        'phone',
        'address',
        'type',
        'cluster',
        'status',
    ];

    public function users()
    {
        return $this->belongsToMany(User::class, 'user_outlets')
                    ->withPivot('role_in_outlet')
                    ->withTimestamps();
    }

    public function stocks()
    {
        return $this->hasMany(Stock::class);
    }

    public function stockBatches()
    {
        return $this->hasMany(StockBatch::class);
    }

    public function stockMutations()
    {
        return $this->hasMany(StockMutation::class);
    }

    public function transactions()
    {
        return $this->hasMany(Transaction::class);
    }

    public function cardReplacements()
    {
        return $this->hasMany(CardReplacement::class);
    }

    public function onboarding()
    {
        return $this->hasOne(OutletOnboarding::class);
    }
}