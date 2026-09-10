import 'package:flutter/material.dart';
import 'package:custodiaa/core/theme/app_colors.dart';
import 'package:custodiaa/mock_data/services.dart';
import 'package:custodiaa/models/service_model.dart';
import 'package:custodiaa/presentation/pages/layanan/widgets/service_form.dart';

class LayananDetailPage extends StatelessWidget {
  final String jenisLayanan;

  const LayananDetailPage({
    super.key,
    required this.jenisLayanan,
  });

  @override
  Widget build(BuildContext context) {
    final Layanan layanan = daftarLayanan.firstWhere(
      (l) => l.id == jenisLayanan,
      orElse: () => daftarLayanan.first,
    );

    return Scaffold(
      backgroundColor: AppColors.background50,
      appBar: AppBar(
        backgroundColor: AppColors.background50,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.foreground800),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              layanan.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.foreground950,
              ),
            ),
            Text(
              layanan.estimasi,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.foreground400,
              ),
            ),
          ],
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: AppColors.background200),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: ServiceForm(layanan: layanan),
        ),
      ),
    );
  }
}
