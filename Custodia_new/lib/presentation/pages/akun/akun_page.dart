import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:custodiaa/core/theme/app_colors.dart';
import 'package:custodiaa/core/navigation/app_router.dart';
import 'package:custodiaa/presentation/widgets/reveal.dart';

class AkunPage extends StatelessWidget {
  const AkunPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background100,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Profile Header Banner
                  GestureDetector(
                    onTap: () => Navigator.of(context).pushNamed(AppRouter.akunEdit),
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFFFFCB05), Color(0xFFFFD93D), Color(0xFFFFAA00)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(24),
                          bottomRight: Radius.circular(24),
                        ),
                      ),
                      child: Row(
                        children: [
                          // Avatar with edit badge
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white70, width: 3),
                                ),
                                child: const Icon(
                                  Icons.person,
                                  size: 44,
                                  color: AppColors.foreground800,
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: AppColors.background200),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.1),
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.edit,
                                    size: 13,
                                    color: AppColors.foreground800,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 16),

                          // Info
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'SH042484',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF5A4D00),
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'Agus Saputra',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.foreground950,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  '+62 858-5171-5758',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF4A4000),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Arrow
                          const Icon(
                            Icons.chevron_right,
                            size: 28,
                            color: Color(0xFF5A4D00),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Menu Card
                  Transform.translate(
                    offset: const Offset(0, -12),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.background50,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            _buildMenuItem(
                              context,
                              icon: Icons.manage_accounts_outlined,
                              label: 'Pengaturan Pengguna',
                              onTap: () => Navigator.of(context).pushNamed(AppRouter.akunEdit),
                            ),
                            const Divider(color: AppColors.background200, height: 1, indent: 64),
                            _buildMenuItem(
                              context,
                              icon: Icons.confirmation_number_outlined,
                              label: 'Redeem Voucher',
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Fitur Redeem Voucher segera hadir!'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              },
                            ),
                            const Divider(color: AppColors.background200, height: 1, indent: 64),
                            _buildMenuItem(
                              context,
                              icon: Icons.qr_code_2_rounded,
                              label: 'Info Produk & Program',
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Info produk & program promo terbaru.'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              },
                            ),
                            const Divider(color: AppColors.background200, height: 1, indent: 64),
                            _buildMenuItem(
                              context,
                              icon: Icons.inventory_2_outlined,
                              label: 'Administrasi Stok',
                              onTap: () => Navigator.of(context).pushNamed(AppRouter.akunAdministrasi),
                            ),
                            const Divider(color: AppColors.background200, height: 1, indent: 64),
                            _buildMenuItem(
                              context,
                              icon: Icons.headset_mic_outlined,
                              label: 'Hubungi Kami',
                              onTap: () => Navigator.of(context).pushNamed(AppRouter.akunHubungi),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Logout Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Reveal(
                      delay: const Duration(milliseconds: 100),
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            AppRouter.login,
                            (route) => false,
                          );
                        },
                        icon: const Icon(Icons.logout_rounded, size: 18, color: Color(0xFFB45309)),
                        label: const Text(
                          'Keluar',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFB45309),
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: const Color(0xFFFEFCE8),
                          side: const BorderSide(color: Color(0xFFFDE047)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: SvgPicture.asset(
                      'assets/images/elemen/Logo.svg',
                      height: 24,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Center(
                    child: Text(
                      'Versi 1.0.0 • Custodia Mobile',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.foreground400,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFF4D4D4F),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 20, color: Colors.white),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.foreground800,
                  ),
                ),
              ),
              const Icon(Icons.chevron_right, size: 22, color: AppColors.foreground300),
            ],
          ),
        ),
      ),
    );
  }
}
