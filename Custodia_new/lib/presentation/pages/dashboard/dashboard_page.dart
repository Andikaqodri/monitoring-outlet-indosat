import 'package:flutter/material.dart';
import 'package:custodiaa/core/theme/app_colors.dart';
import 'package:custodiaa/presentation/widgets/banner_slider.dart';
import 'package:custodiaa/presentation/widgets/reveal.dart';
import 'package:custodiaa/presentation/widgets/count_up.dart';
import 'package:custodiaa/presentation/pages/dashboard/widgets/weekly_chart.dart';
import 'package:custodiaa/core/navigation/app_router.dart';

class DashboardPage extends StatelessWidget {
  final VoidCallback? onOpenProfile;

  const DashboardPage({super.key, this.onOpenProfile});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Header Magenta Penuh Lebar ──
              _buildMagentaHeader(context),

              // ── Body Content ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),

                    // ── 1. Statistik 4 Kolom + Alert Bar ──
                    Reveal(
                      child: _buildStatistikCard(context),
                    ),

                    const SizedBox(height: 20),

                    // ── 2. Layanan Cepat ──
                    Reveal(
                      delay: const Duration(milliseconds: 60),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Layanan Cepat',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.foreground950,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildLayananCepatCard(context),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ── 3. Aktivitas Mingguan ──
                    Reveal(
                      delay: const Duration(milliseconds: 100),
                      child: _buildAktivitasMingguanCard(),
                    ),

                    const SizedBox(height: 16),

                    // ── 4. Banner Promo Slider ──
                    const Reveal(
                      delay: Duration(milliseconds: 140),
                      child: BannerSlider(),
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Header Magenta ──
  Widget _buildMagentaHeader(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(
        color: Color(0xFFC6168D),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: Stack(
        children: [
          // Floating background bokeh circles - dipepetkan persis ke pojok kanan atas
          Positioned(
            top: -40,
            right: -40,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.12),
              ),
            ),
          ),
          Positioned(
            bottom: -30,
            left: -20,
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFFCB05).withValues(alpha: 0.15),
              ),
            ),
          ),

          // Header Content
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              // Greeting on left, Notification & Profile circle on right
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Senin, 19 Agustus 2026',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.white70,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Halo, Agus 👋',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Icon Notifikasi
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/notifikasi'),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withValues(alpha: 0.18),
                              ),
                              child: const Icon(
                                Icons.notifications_none_rounded,
                                size: 22,
                                color: Colors.white,
                              ),
                            ),
                            Positioned(
                              right: 2,
                              top: 2,
                              child: Container(
                                width: 9,
                                height: 9,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFCB05),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: const Color(0xFFC6168D),
                                    width: 1.5,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Lingkaran Profile
                      GestureDetector(
                        onTap: () {
                          if (onOpenProfile != null) {
                            onOpenProfile!();
                          } else {
                            Navigator.pushNamed(context, '/akun');
                          }
                        },
                        child: Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.35),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Text(
                              'AS',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFC6168D),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Target Harian Card (White)
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Left Text & Progress
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Target Harian',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.foreground700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              const CountUpWidget(
                                end: 94,
                                style: TextStyle(
                                  fontSize: 34,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.foreground950,
                                ),
                              ),
                              const Text(
                                '%',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.foreground500,
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Text(
                                '121 / 128 transaksi',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: AppColors.foreground500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Gradient Progress Bar
                          Container(
                            height: 8,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: AppColors.background200,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: 0.94,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFFF43F5E),
                                      Color(0xFFFFCB05),
                                      Color(0xFFE11D48),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 8),

                    // Right Illustration: Woman holding SIM card
                    Image.network(
                      'https://readdy.ai/api/search-image?query=Friendly%20flat%20illustration%20of%20a%20young%20person%20smiling%20and%20holding%20a%20small%20SIM%20card%20between%20their%20fingers%20modern%20mobile%20app%20vector%20style%20warm%20magenta%20and%20orange%20gradient%20color%20palette%20clean%20minimal%20white%20background%20bold%20outlines%20friendly%20character%20design%20digital%20art%20telecom%20dashboard%20card%20small%20micro%20sim%20card%20in%20hand%20mobile%20phone%20sales%20celebrating%20achievement&width=180&height=220&seq=dashboard-target-person-01&orientation=portrait&nocache=true',
                      height: 115,
                      width: 100,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 115,
                        width: 100,
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.sim_card_rounded,
                          size: 50,
                          color: Color(0xFFC6168D),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

  // ── 1. Statistik 4 Kolom Card ──
  Widget _buildStatistikCard(BuildContext context) {
    final stats = [
      {'label': 'Transaksi\nHari Ini', 'icon': Icons.bar_chart_rounded, 'nilai': 128},
      {'label': 'Berhasil\nDiproses', 'icon': Icons.verified_rounded, 'nilai': 121},
      {'label': 'Menunggu\nVerifikasi', 'icon': Icons.assignment_rounded, 'nilai': 5},
      {'label': 'Gagal /\nDitolak', 'icon': Icons.cancel_rounded, 'nilai': 2},
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.background200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // 4 Icons Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: stats.map((stat) {
              return Expanded(
                child: Column(
                  children: [
                    SizedBox(
                      height: 28,
                      child: Text(
                        stat['label'] as String,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          height: 1.2,
                          color: AppColors.foreground500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 48,
                      height: 48,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFFCB05),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        stat['icon'] as IconData,
                        size: 26,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    CountUpWidget(
                      end: stat['nilai'] as int,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.foreground950,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 16),

          // Red Warning Bar
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () => Navigator.of(context).pushNamed(AppRouter.notifikasi),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFED1C24).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Row(
                  children: [
                    CircleAvatar(
                      radius: 11,
                      backgroundColor: Color(0x33ED1C24),
                      child: Icon(
                        Icons.priority_high_rounded,
                        size: 13,
                        color: Color(0xFFED1C24),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '5 transaksi menunggu verifikasi',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFED1C24),
                        ),
                      ),
                    ),
                    Icon(
                      Icons.chevron_right_rounded,
                      size: 18,
                      color: Color(0xFFED1C24),
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

  // ── 2. Layanan Cepat Card ──
  Widget _buildLayananCepatCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.background200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            Navigator.of(context).pushNamed(
              AppRouter.layananDetail,
              arguments: 'ganti-kartu',
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Magenta icon
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEC008C),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.assignment_outlined,
                    size: 26,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 14),

                // Text
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ganti Kartu',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.foreground950,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'Satu form untuk semua kebutuhan ganti kartu.',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.foreground500,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                // Button "Proses ➔"
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEC008C),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Proses',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_rounded,
                        size: 14,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── 3. Aktivitas Mingguan Card ──
  Widget _buildAktivitasMingguanCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.background200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Aktivitas Mingguan',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.foreground950,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFFDE8F3),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  '7 hari',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFC6168D),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const WeeklyChart(),
        ],
      ),
    );
  }
}
