import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:custodiaa/core/theme/app_colors.dart';
import 'package:custodiaa/models/outlet_data_model.dart';
import 'package:custodiaa/core/navigation/app_router.dart';

class StepEvidence extends StatefulWidget {
  final OutletData data;
  final VoidCallback onBack;

  const StepEvidence({
    super.key,
    required this.data,
    required this.onBack,
  });

  @override
  State<StepEvidence> createState() => _StepEvidenceState();
}

class _StepEvidenceState extends State<StepEvidence> {
  String? _fotoOutletPath;
  String? _fotoOwnerPath;
  bool _isDemoOutlet = false;
  bool _isDemoOwner = false;
  bool _done = false;
  final ImagePicker _picker = ImagePicker();

  bool get _canFinish =>
      (_fotoOutletPath != null || _isDemoOutlet) &&
      (_fotoOwnerPath != null || _isDemoOwner);

  Future<void> _pickImage(bool isOutlet) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      if (image != null) {
        setState(() {
          if (isOutlet) {
            _fotoOutletPath = image.path;
            _isDemoOutlet = false;
          } else {
            _fotoOwnerPath = image.path;
            _isDemoOwner = false;
          }
        });
      }
    } catch (e) {
      // Fallback for platforms where file picker may not be available or permitted
      setState(() {
        if (isOutlet) {
          _isDemoOutlet = true;
          _fotoOutletPath = 'https://images.unsplash.com/photo-1578916171728-46686eac8d58?w=500';
        } else {
          _isDemoOwner = true;
          _fotoOwnerPath = 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=500';
        }
      });
    }
  }

  void _useDemoPhotos() {
    setState(() {
      _isDemoOutlet = true;
      _fotoOutletPath = 'https://images.unsplash.com/photo-1578916171728-46686eac8d58?w=500';
      _isDemoOwner = true;
      _fotoOwnerPath = 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=500';
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_done) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.accent100,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.accent200),
        ),
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: const BoxDecoration(
                color: AppColors.accent500,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, size: 32, color: Colors.white),
            ),
            const SizedBox(height: 16),
            const Text(
              'Outlet Berhasil Terdaftar',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.accent900,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Data outlet ${widget.data.namaOutlet} (${widget.data.wilayah}) sudah lengkap dan berhasil terdaftar.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: AppColors.accent800),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    AppRouter.home,
                    (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent500,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Kembali ke Dashboard',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Evidence / Bukti Foto',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.foreground950,
              ),
            ),
            TextButton(
              onPressed: _useDemoPhotos,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                'Pakai Contoh Foto',
                style: TextStyle(fontSize: 11, color: AppColors.primary600, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        const Text(
          'Unggah foto outlet dan pemilik sebagai bukti kunjungan.',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.foreground500,
          ),
        ),
        const SizedBox(height: 20),

        // Foto Outlet
        _buildUploadCard(
          title: 'Foto Outlet',
          icon: Icons.store_outlined,
          hint: 'Tambah foto outlet',
          imagePath: _fotoOutletPath,
          isDemo: _isDemoOutlet,
          onTap: () => _pickImage(true),
        ),
        const SizedBox(height: 16),

        // Foto Owner
        _buildUploadCard(
          title: 'Foto Pemilik (Owner)',
          icon: Icons.person_outline,
          hint: 'Tambah foto pemilik',
          imagePath: _fotoOwnerPath,
          isDemo: _isDemoOwner,
          onTap: () => _pickImage(false),
        ),
        const SizedBox(height: 16),

        // Ready Banner
        if (_canFinish)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.secondary100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Outlet: ${widget.data.namaOutlet}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondary900,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Semua evidence lengkap. Siap menyelesaikan pendaftaran.',
                  style: TextStyle(fontSize: 12, color: AppColors.secondary700),
                ),
              ],
            ),
          ),
        const SizedBox(height: 24),

        // Action Buttons
        Row(
          children: [
            SizedBox(
              width: 110,
              height: 48,
              child: OutlinedButton.icon(
                onPressed: widget.onBack,
                icon: const Icon(Icons.arrow_back, size: 18),
                label: const Text('Kembali'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.foreground700,
                  side: const BorderSide(color: AppColors.background300),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: _canFinish ? () => setState(() => _done = true) : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary600,
                    disabledBackgroundColor: AppColors.primary600.withValues(alpha: 0.4),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Selesaikan Pendaftaran',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildUploadCard({
    required String title,
    required IconData icon,
    required String hint,
    required String? imagePath,
    required bool isDemo,
    required VoidCallback onTap,
  }) {
    final hasImage = imagePath != null;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.background200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.foreground800,
            ),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: onTap,
            child: Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.background100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.background300,
                  style: hasImage ? BorderStyle.none : BorderStyle.solid,
                ),
              ),
              clipBehavior: Clip.antiAlias,
              child: hasImage
                  ? Stack(
                      fit: StackFit.expand,
                      children: [
                        isDemo
                            ? Image.network(imagePath, fit: BoxFit.cover)
                            : (kIsWeb
                                ? Image.network(imagePath, fit: BoxFit.cover)
                                : Image.file(File(imagePath), fit: BoxFit.cover)),
                        Container(
                          color: Colors.black26,
                          alignment: Alignment.center,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.background50,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'Ganti foto',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: AppColors.foreground900,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(icon, size: 36, color: AppColors.foreground400),
                          const SizedBox(height: 8),
                          Text(
                            hint,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.foreground400,
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
