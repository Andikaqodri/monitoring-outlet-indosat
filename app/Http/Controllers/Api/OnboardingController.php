<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Outlet;
use App\Models\OutletOnboarding;
use Illuminate\Http\Request;

class OnboardingController extends Controller
{
    public function submitAgreement(Request $request)
    {
        $validated = $request->validate([
            'outlet_id' => 'required|exists:outlets,id',
            'agreement_signed' => 'required|boolean',
        ]);

        $onboarding = OutletOnboarding::firstOrNew(['outlet_id' => $validated['outlet_id']]);
        $onboarding->user_id = $request->user()->id;
        $onboarding->agreement_signed = $validated['agreement_signed'];
        $onboarding->agreement_signed_at = now();
        $onboarding->save();

        return response()->json([
            'status' => 'success',
            'message' => 'Persetujuan agreement berhasil disimpan.',
            'data' => $onboarding,
        ]);
    }

    public function uploadEvidence(Request $request)
    {
        $request->validate([
            'outlet_id' => 'required|exists:outlets,id',
            'evidence_file' => 'required|file|mimes:jpg,jpeg,png,pdf|max:5120',
        ]);

        $path = $request->file('evidence_file')->store('evidence', 'public');

        $onboarding = OutletOnboarding::firstOrNew(['outlet_id' => $request->input('outlet_id')]);
        $onboarding->user_id = $request->user()->id;
        $onboarding->evidence_file_path = '/storage/' . $path;
        $onboarding->approval_status = 'PENDING';
        $onboarding->save();

        return response()->json([
            'status' => 'success',
            'message' => 'Berkas evidence berhasil diunggah.',
            'data' => $onboarding,
        ]);
    }

    public function status($outletId)
    {
        $onboarding = OutletOnboarding::where('outlet_id', $outletId)->first();

        return response()->json([
            'status' => 'success',
            'data' => $onboarding ?? [
                'outlet_id' => $outletId,
                'agreement_signed' => false,
                'otp_verified' => false,
                'approval_status' => 'PENDING',
            ],
        ]);
    }

    public function approve(Request $request, $outletId)
    {
        $request->validate([
            'approval_status' => 'required|in:APPROVED,REJECTED',
            'notes' => 'nullable|string',
        ]);

        $onboarding = OutletOnboarding::where('outlet_id', $outletId)->firstOrFail();
        $onboarding->update([
            'approval_status' => $request->input('approval_status'),
            'approved_by' => $request->user()->id,
            'notes' => $request->input('notes'),
        ]);

        if ($request->input('approval_status') === 'APPROVED') {
            Outlet::where('id', $outletId)->update(['status' => 'ACTIVE']);
        }

        return response()->json([
            'status' => 'success',
            'message' => 'Status onboarding outlet berhasil diperbarui.',
            'data' => $onboarding,
        ]);
    }
}