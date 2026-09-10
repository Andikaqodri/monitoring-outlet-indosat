import 'package:flutter/material.dart';
import 'package:custodiaa/core/theme/app_colors.dart';
import 'package:custodiaa/mock_data/notifications.dart';
import 'package:custodiaa/models/notification_model.dart';
import 'package:custodiaa/presentation/widgets/reveal.dart';

class NotifikasiPage extends StatefulWidget {
  const NotifikasiPage({super.key});

  @override
  State<NotifikasiPage> createState() => _NotifikasiPageState();
}

class _NotifikasiPageState extends State<NotifikasiPage> {
  late List<NotifikasiModel> _notifikasiList;
  String _filter = 'semua';

  @override
  void initState() {
    super.initState();
    _notifikasiList = List.from(daftarNotifikasi);
  }

  int get _belumDibacaCount => _notifikasiList.where((n) => !n.dibaca).length;

  void _tandaiSemuaDibaca() {
    setState(() {
      for (final n in _notifikasiList) {
        n.dibaca = true;
      }
    });
  }

  void _tandaiDibaca(String id) {
    setState(() {
      final item = _notifikasiList.firstWhere((n) => n.id == id);
      item.dibaca = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filter == 'semua'
        ? _notifikasiList
        : _notifikasiList.where((n) => !n.dibaca).toList();

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
                  // Header Gradient
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.primary600, AppColors.accent500, AppColors.primary500],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(24),
                        bottomRight: Radius.circular(24),
                      ),
                    ),
                    child: Reveal(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Top bar: Back button at top-left + unread badge
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    if (Navigator.canPop(context)) {
                                      Navigator.pop(context);
                                    } else {
                                      Navigator.pushReplacementNamed(context, '/');
                                    }
                                  },
                                  borderRadius: BorderRadius.circular(20),
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white.withValues(alpha: 0.2),
                                      border: Border.all(
                                        color: Colors.white.withValues(alpha: 0.3),
                                        width: 1,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.arrow_back_rounded,
                                      size: 22,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              if (_belumDibacaCount > 0)
                                Container(
                                  height: 32,
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    '$_belumDibacaCount baru',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Notifikasi',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Pembaruan transaksi & info outlet Anda.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: Column(
                      children: [
                        // Filter Tabs + Mark All Read
                        Reveal(
                          delay: const Duration(milliseconds: 50),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: AppColors.background100,
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: Row(
                                  children: [
                                    _buildFilterButton('Semua', 'semua'),
                                    _buildFilterButton(
                                      _belumDibacaCount > 0
                                          ? 'Belum Dibaca ($_belumDibacaCount)'
                                          : 'Belum Dibaca',
                                      'belum',
                                    ),
                                  ],
                                ),
                              ),
                              TextButton(
                                onPressed: _tandaiSemuaDibaca,
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  minimumSize: Size.zero,
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: const Text(
                                  'Tandai semua dibaca',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Notification Items
                        if (filtered.isEmpty)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 48),
                            child: Column(
                              children: [
                                Icon(Icons.notifications_off_outlined, size: 48, color: AppColors.foreground300),
                                SizedBox(height: 12),
                                Text(
                                  'Semua notifikasi sudah dibaca.',
                                  style: TextStyle(fontSize: 14, color: AppColors.foreground500),
                                ),
                              ],
                            ),
                          )
                        else
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: filtered.length,
                            separatorBuilder: (context, index) => const SizedBox(height: 10),
                            itemBuilder: (context, idx) {
                              final notif = filtered[idx];
                              return Reveal(
                                delay: Duration(milliseconds: idx * 30),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(18),
                                  onTap: () => _tandaiDibaca(notif.id),
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: notif.dibaca
                                          ? AppColors.background50
                                          : AppColors.primary50.withValues(alpha: 0.5),
                                      borderRadius: BorderRadius.circular(18),
                                      border: Border.all(
                                        color: notif.dibaca
                                            ? AppColors.background200
                                            : AppColors.primary200,
                                      ),
                                    ),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Stack(
                                          clipBehavior: Clip.none,
                                          children: [
                                            Container(
                                              width: 42,
                                              height: 42,
                                              decoration: BoxDecoration(
                                                color: _getIconBgColor(notif.warna),
                                                borderRadius: BorderRadius.circular(14),
                                              ),
                                              child: Icon(
                                                _getIconData(notif.icon),
                                                size: 20,
                                                color: _getIconFgColor(notif.warna),
                                              ),
                                            ),
                                            if (!notif.dibaca)
                                              Positioned(
                                                top: -2,
                                                right: -2,
                                                child: Container(
                                                  width: 10,
                                                  height: 10,
                                                  decoration: BoxDecoration(
                                                    color: AppColors.primary500,
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                      color: AppColors.background50,
                                                      width: 2,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                notif.judul,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: notif.dibaca
                                                      ? FontWeight.w500
                                                      : FontWeight.bold,
                                                  color: notif.dibaca
                                                      ? AppColors.foreground900
                                                      : AppColors.foreground950,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                notif.deskripsi,
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  height: 1.4,
                                                  color: AppColors.foreground500,
                                                ),
                                              ),
                                              const SizedBox(height: 6),
                                              Text(
                                                '${notif.tanggal} · ${notif.waktu}',
                                                style: const TextStyle(
                                                  fontSize: 11,
                                                  color: AppColors.foreground400,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterButton(String label, String value) {
    final isActive = _filter == value;
    return GestureDetector(
      onTap: () => setState(() => _filter = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary500 : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isActive ? Colors.white : AppColors.foreground600,
          ),
        ),
      ),
    );
  }

  Color _getIconBgColor(String warna) {
    switch (warna) {
      case 'primary':
        return AppColors.primary100;
      case 'accent':
        return AppColors.accent100;
      case 'secondary':
        return AppColors.secondary100;
      case 'cyan':
        return AppColors.cyan100;
      default:
        return AppColors.primary100;
    }
  }

  Color _getIconFgColor(String warna) {
    switch (warna) {
      case 'primary':
        return AppColors.primary600;
      case 'accent':
        return AppColors.accent700;
      case 'secondary':
        return AppColors.secondary800;
      case 'cyan':
        return AppColors.cyan700;
      default:
        return AppColors.primary600;
    }
  }

  IconData _getIconData(String icon) {
    if (icon.contains('shield') || icon.contains('verified')) {
      return Icons.verified_user_outlined;
    } else if (icon.contains('sim') || icon.contains('card')) {
      return Icons.sim_card_outlined;
    } else if (icon.contains('alert') || icon.contains('warning')) {
      return Icons.warning_amber_rounded;
    } else if (icon.contains('rocket') || icon.contains('5g')) {
      return Icons.rocket_launch_outlined;
    }
    return Icons.notifications_outlined;
  }
}
