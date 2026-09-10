import 'package:flutter/material.dart';
import 'package:custodiaa/core/theme/app_colors.dart';
import 'package:custodiaa/presentation/pages/dashboard/dashboard_page.dart';
import 'package:custodiaa/presentation/pages/reels/reels_page.dart';
import 'package:custodiaa/presentation/pages/riwayat/riwayat_page.dart';
import 'package:custodiaa/presentation/pages/akun/akun_page.dart';

/// Main app layout with bottom navigation — Flutter equivalent of AppLayout.tsx.
class AppLayout extends StatefulWidget {
  const AppLayout({super.key});

  @override
  State<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  int _currentIndex = 0;

  late final List<Widget> _pages = [
    DashboardPage(onOpenProfile: () => setState(() => _currentIndex = 3)),
    const ReelsPage(),
    const RiwayatPage(),
    const AkunPage(),
  ];

  static const _tabs = [
    _TabItem(label: 'Beranda', icon: Icons.home_outlined, activeIcon: Icons.home_rounded),
    _TabItem(label: 'Reels', icon: Icons.video_library_outlined, activeIcon: Icons.video_library_rounded, badge: 3),
    _TabItem(label: 'Riwayat', icon: Icons.history_rounded, activeIcon: Icons.history_rounded, badge: 2),
    _TabItem(label: 'Akun', icon: Icons.person_outline_rounded, activeIcon: Icons.person_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background100,
      body: SafeArea(
        bottom: false,
        child: IndexedStack(
          index: _currentIndex,
          children: _pages,
        ),
      ),
      // Floating bottom navigation
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.background50.withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.18),
              blurRadius: 32,
              offset: const Offset(0, 8),
              spreadRadius: -8,
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(_tabs.length, (i) {
            final tab = _tabs[i];
            final isActive = _currentIndex == i;
            return GestureDetector(
              onTap: () => setState(() => _currentIndex = i),
              behavior: HitTestBehavior.opaque,
              child: SizedBox(
                width: 64,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Active pill background
                    if (isActive)
                      Container(
                        width: 64,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.white.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: AppColors.white.withValues(alpha: 0.5),
                          ),
                        ),
                      ),
                    // Icon + label
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Icon(
                              isActive ? tab.activeIcon : tab.icon,
                              size: 20,
                              color: isActive
                                  ? AppColors.primary600
                                  : AppColors.foreground400,
                            ),
                            if (tab.badge != null && !isActive)
                              Positioned(
                                right: -6,
                                top: -4,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 4),
                                  height: 14,
                                  constraints: const BoxConstraints(minWidth: 14),
                                  decoration: BoxDecoration(
                                    color: AppColors.accent500,
                                    borderRadius: BorderRadius.circular(100),
                                    border: Border.all(
                                      color: AppColors.background50,
                                      width: 2,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${tab.badge}',
                                      style: const TextStyle(
                                        fontSize: 8,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.background50,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          tab.label,
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            color: isActive
                                ? AppColors.primary700
                                : AppColors.foreground500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _TabItem {
  final String label;
  final IconData icon;
  final IconData activeIcon;
  final int? badge;

  const _TabItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
    this.badge,
  });
}
