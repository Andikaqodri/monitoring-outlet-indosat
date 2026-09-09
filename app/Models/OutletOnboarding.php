<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class OutletOnboarding extends Model
{
    protected $fillable = [
        'outlet_id',
        'user_id',
        'agreement_signed',
        'agreement_signed_at',
        'otp_verified',
        'otp_verified_at',
        'approval_status',
        'approved_by',
        'evidence_file_path',
        'notes',
    ];

    protected $casts = [
        'agreement_signed' => 'boolean',
        'otp_verified' => 'boolean',
        'agreement_signed_at' => 'datetime',
        'otp_verified_at' => 'datetime',
    ];

    public function outlet()
    {
        return $this->belongsTo(Outlet::class);
    }

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function approver()
    {
        return $this->belongsTo(User::class, 'approved_by');
    }
}