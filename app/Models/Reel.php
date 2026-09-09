<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Reel extends Model
{
    protected $fillable = [
        'user_id',
        'outlet_id',
        'title',
        'caption',
        'video_url',
        'thumbnail_url',
        'likes_count',
        'comments_count',
        'shares_count',
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