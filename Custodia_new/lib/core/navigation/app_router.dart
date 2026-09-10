import 'package:flutter/material.dart';
import 'package:custodiaa/presentation/layout/splash_screen.dart';
import 'package:custodiaa/presentation/layout/app_layout.dart';
import 'package:custodiaa/presentation/pages/login/login_page.dart';
import 'package:custodiaa/presentation/pages/lupa_kata_sandi/lupa_kata_sandi_page.dart';
import 'package:custodiaa/presentation/pages/register/register_page.dart';
import 'package:custodiaa/presentation/pages/layanan/layanan_hub_page.dart';
import 'package:custodiaa/presentation/pages/layanan/layanan_detail_page.dart';
import 'package:custodiaa/presentation/pages/riwayat/riwayat_page.dart';
import 'package:custodiaa/presentation/pages/notifikasi/notifikasi_page.dart';
import 'package:custodiaa/presentation/pages/akun/akun_page.dart';
import 'package:custodiaa/presentation/pages/akun/edit_akun_page.dart';
import 'package:custodiaa/presentation/pages/akun/hubungi_page.dart';
import 'package:custodiaa/presentation/pages/akun/administrasi_page.dart';
import 'package:custodiaa/presentation/pages/reels/reels_page.dart';

class AppRouter {
  AppRouter._();

  static const String splash = '/splash';
  static const String login = '/login';
  static const String lupaKataSandi = '/lupa-kata-sandi';
  static const String register = '/register';
  static const String home = '/';
  static const String layanan = '/layanan';
  static const String layananDetail = '/layanan/detail';
  static const String riwayat = '/riwayat';
  static const String notifikasi = '/notifikasi';
  static const String akun = '/akun';
  static const String akunEdit = '/akun/edit';
  static const String akunHubungi = '/akun/hubungi';
  static const String akunAdministrasi = '/akun/administrasi';
  static const String reels = '/reels';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return _fade(const SplashScreen());
      case login:
        return _slide(const LoginPage());
      case lupaKataSandi:
        return _slide(const LupaKataSandiPage());
      case register:
        return _slide(const RegisterPage());
      case home:
        return _fade(const AppLayout());
      case layanan:
        return _slide(const LayananHubPage());
      case layananDetail:
        final jenisLayanan = settings.arguments as String? ?? 'ganti-kartu';
        return _slide(LayananDetailPage(jenisLayanan: jenisLayanan));
      case riwayat:
        return _slide(const RiwayatPage());
      case notifikasi:
        return _slide(const NotifikasiPage());
      case akun:
        return _slide(const AkunPage());
      case akunEdit:
        return _slide(const EditAkunPage());
      case akunHubungi:
        return _slide(const HubungiPage());
      case akunAdministrasi:
        return _slide(const AdministrasiPage());
      case reels:
        return _slide(const ReelsPage());
      default:
        return _fade(const Scaffold(
          body: Center(child: Text('Halaman tidak ditemukan')),
        ));
    }
  }

  static PageRouteBuilder _fade(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) =>
          FadeTransition(opacity: animation, child: child),
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  static PageRouteBuilder _slide(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final offsetAnimation = Tween<Offset>(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));
        return SlideTransition(position: offsetAnimation, child: child);
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}
