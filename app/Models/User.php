<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;

class User extends Authenticatable
{
    use HasApiTokens, HasFactory, Notifiable;

    protected $fillable = [
        'name',
        'email',
        'nip',
        'phone',
        'role',
        'avatar',
        'status',
        'password',
    ];

    protected $hidden = [
        'password',
        'remember_token',
    ];

    protected function casts(): array
    {
        return [
            'email_verified_at' => 'datetime',
            'password' => 'hashed',
        ];
    }

    public function outlets()
    {
        return $this->belongsToMany(Outlet::class, 'user_outlets')
                    ->withPivot('role_in_outlet')
                    ->withTimestamps();
    }

    public function transactions()
    {
        return $this->hasMany(Transaction::class);
    }

    public function cardReplacements()
    {
        return $this->hasMany(CardReplacement::class);
    }

    public function reels()
    {
        return $this->hasMany(Reel::class);
    }

    public function hasOutletAccess(int|string $outletId): bool
    {
        if (in_array($this->role, ['admin', 'cse'])) {
            return true;
        }

        return $this->outlets()->where('outlets.id', $outletId)->exists();
    }
}