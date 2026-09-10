import 'package:flutter/material.dart';
import 'package:custodiaa/core/theme/app_colors.dart';
import 'package:custodiaa/models/outlet_data_model.dart';

class StepAgreement extends StatelessWidget {
  final OutletData data;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const StepAgreement({
    super.key,
    required this.data,
    required this.onNext,
    required this.onBack,
  });

  String _formatTanggal(DateTime dt) {
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
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    final tanggal = _formatTanggal(DateTime.now());
    final clusterValue = data.clusterDisplay.isNotEmpty
        ? data.clusterDisplay
        : (data.wilayah.isNotEmpty ? data.wilayah : 'CLUSTER');
    final clusterClean =
        clusterValue.replaceAll(RegExp(r'\s+'), '').toUpperCase();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header title
        const Text(
          'Surat Agreement',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.2,
            color: AppColors.foreground950,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Surat perjanjian kerja sama dengan outlet ini telah dibuat otomatis.',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.foreground500,
          ),
        ),
        const SizedBox(height: 20),

        // Document Container
        Container(
          decoration: BoxDecoration(
            color: AppColors.background50,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.background200),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Surat
              Container(
                padding: const EdgeInsets.only(bottom: 12),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: AppColors.background200),
                  ),
                ),
                child: Column(
                  children: [
                    const Text(
                      'CUSTODIA',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 2.0,
                        color: AppColors.foreground400,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Surat Perjanjian Kerja Sama',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.foreground950,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Nomor: IND/AGR/$clusterClean/2026',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.foreground400,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Paragraph 1
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.6,
                    color: AppColors.foreground700,
                  ),
                  children: [
                    const TextSpan(text: 'Pada hari ini, '),
                    TextSpan(
                      text: tanggal,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.foreground900,
                      ),
                    ),
                    const TextSpan(
                      text: ', telah disepakati perjanjian kerja sama antara ',
                    ),
                    const TextSpan(
                      text: 'Custodia',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.foreground900,
                      ),
                    ),
                    const TextSpan(text: ' dengan:'),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Outlet Details Box
              Container(
                decoration: BoxDecoration(
                  color: AppColors.background100,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildDlRow(
                      'Outlet',
                      data.namaOutlet.isNotEmpty ? data.namaOutlet : '-',
                    ),
                    const SizedBox(height: 6),
                    _buildDlRow(
                      'Pemilik',
                      data.namaPemilik.isNotEmpty ? data.namaPemilik : '-',
                    ),
                    const SizedBox(height: 6),
                    _buildDlRow(
                      'Alamat',
                      data.alamat.isNotEmpty ? data.alamat : '-',
                    ),
                    const SizedBox(height: 6),
                    _buildDlRow(
                      'Cluster',
                      data.clusterDisplay.isNotEmpty
                          ? data.clusterDisplay
                          : '-',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Paragraph 2
              const Text(
                'Outlet bersedia menjadi mitra resmi penjualan produk Custodia, meliputi kartu perdana, paket data, dan layanan lainnya, sesuai ketentuan distribusi yang berlaku.',
                style: TextStyle(
                  fontSize: 14,
                  height: 1.6,
                  color: AppColors.foreground700,
                ),
              ),
              const SizedBox(height: 16),

              // Signatures
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.background200),
                      ),
                      child: const Column(
                        children: [
                          Text(
                            'Pihak Custodia',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.foreground500,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'CSE',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.foreground800,
                            ),
                          ),
                          SizedBox(height: 12),
                          Text(
                            '(Tanda tangan)',
                            style: TextStyle(
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                              color: AppColors.foreground400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.background200),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Pihak Outlet',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.foreground500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            data.namaPemilik.isNotEmpty
                                ? data.namaPemilik
                                : '-',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.foreground800,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            '(Tanda tangan)',
                            style: TextStyle(
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                              color: AppColors.foreground400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Info Banner
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.accent100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.info_outline_rounded,
                size: 18,
                color: AppColors.accent900,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Surat agreement berhasil dibuat. Lanjutkan ke verifikasi OTP untuk persetujuan dari pemilik outlet.',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.accent900,
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
                    'Lanjut ke Verifikasi OTP',
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

  Widget _buildDlRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 96,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.foreground500,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.foreground900,
            ),
          ),
        ),
      ],
    );
  }
}
