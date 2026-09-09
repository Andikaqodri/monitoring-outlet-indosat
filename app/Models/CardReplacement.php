<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class CardReplacement extends Model
{
    protected $fillable = [
        'ticket_no',
        'outlet_id',
        'user_id',
        'customer_name',
        'customer_nik',
        'customer_phone',
        'old_iccid',
        'new_iccid',
        'reason',
        'fee',
        'status',
        'evidence_file_path',
    ];

    public function outlet()
    {
        return $this->belongsTo(Outlet::class);
    }

    public function user()
    {
        return $this->belongsTo(User::class);
    }
}