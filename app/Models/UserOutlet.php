<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class UserOutlet extends Model
{
    protected $table = 'user_outlets';

    protected $fillable = [
        'user_id',
        'outlet_id',
        'role_in_outlet',
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function outlet()
    {
        return $this->belongsTo(Outlet::class);
    }
}