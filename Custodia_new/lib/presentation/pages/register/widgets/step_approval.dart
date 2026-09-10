import 'package:flutter/material.dart';
import 'package:custodiaa/core/theme/app_colors.dart';
import 'package:custodiaa/models/outlet_data_model.dart';

class StepApproval extends StatelessWidget {
  final OutletData data;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const StepApproval({
    super.key,
    required this.data,
    required this.onNext,
    required this.onBack,
  });

  String _formatDateTime(DateTime dt) {
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}, $h.$m';
  }

  @override
  Widget build(BuildContext context) {
    final tanggal = _formatDateTime(DateTime.now());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header centered
        Center(
          child: Column(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  color: AppColors.accent100,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.done_all_rounded,
                  size: 32,
                  color: AppColors.accent900,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Agreement Disetujui',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.2,
                  color: AppColors.foreground950,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Outlet berhasil terautentikasi dan menyetujui surat agreement.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.foreground500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Info Card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.background50,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.background200),
          ),
          child: Column(
            children: [
              _buildRow('Outlet', data.namaOutlet.isNotEmpty ? data.namaOutlet : '-'),
              const SizedBox(height: 12),
              _buildRow('Pemilik', data.namaPemilik.isNotEmpty ? data.namaPemilik : '-'),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Status',
                    style: TextStyle(fontSize: 14, color: AppColors.foreground500),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.accent100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check, size: 14, color: AppColors.accent900),
                        SizedBox(width: 4),
                        Text(
                          'Disetujui',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.accent900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildRow('Waktu', tanggal),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Camera tip banner
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.secondary100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.camera_alt_outlined, size: 18, color: AppColors.secondary900),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Langkah terakhir: unggah bukti foto outlet dan pemilik untuk melengkapi data.',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.secondary900,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Action Buttons
        Row(
          children: [
            SizedBox(
              width: 112,
              height: 48,
              child: OutlinedButton(
                onPressed: onBack,
                style: OutlinedButton.styleFrom(
                  backgroundColor: AppColors.background50,
                  foregroundColor: AppColors.foreground700,
                  side: const BorderSide(color: AppColors.background300),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: EdgeInsets.zero,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.arrow_back_rounded, size: 18),
                    SizedBox(width: 4),
                    Text(
                      'Kembali',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: onNext,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary600,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Lanjut ke Evidence',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: AppColors.foreground500),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.foreground900,
          ),
        ),
      ],
    );
  }
}
