<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Reel;
use Illuminate\Http\Request;

class ReelController extends Controller
{
    public function index()
    {
        $reels = Reel::with(['user:id,name,avatar', 'outlet:id,name,code'])
                     ->latest()
                     ->paginate(10);

        return response()->json([
            'status' => 'success',
            'data' => $reels,
        ]);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'outlet_id' => 'nullable|exists:outlets,id',
            'title' => 'nullable|string|max:150',
            'caption' => 'nullable|string',
            'video_file' => 'required|file|mimes:mp4,mov,avi|max:51200', // Max 50MB
        ]);

        $path = $request->file('video_file')->store('reels', 'public');

        $reel = Reel::create([
            'user_id' => $request->user()->id,
            'outlet_id' => $validated['outlet_id'] ?? null,
            'title' => $validated['title'] ?? null,
            'caption' => $validated['caption'] ?? null,
            'video_url' => '/storage/' . $path,
        ]);

        return response()->json([
            'status' => 'success',
            'message' => 'Video reel berhasil diunggah.',
            'data' => $reel,
        ], 201);
    }

    public function like($id)
    {
        $reel = Reel::findOrFail($id);
        $reel->increment('likes_count');

        return response()->json([
            'status' => 'success',
            'data' => [
                'id' => $reel->id,
                'likes_count' => $reel->likes_count,
            ]
        ]);
    }
}