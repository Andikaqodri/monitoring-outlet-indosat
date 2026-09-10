import 'dart:async';

import 'package:flutter/material.dart';
import 'package:custodiaa/core/network/otp_api.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:custodiaa/core/theme/app_colors.dart';

/// Lupa Kata Sandi page — 3-step flow (Phone → OTP → Reset).
class LupaKataSandiPage extends StatefulWidget {
  const LupaKataSandiPage({super.key});

  @override
  State<LupaKataSandiPage> createState() => _LupaKataSandiPageState();
}

enum _Step { phone, otp, reset }

class _LupaKataSandiPageState extends State<LupaKataSandiPage> {
  _Step _step = _Step.phone;
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _showPassword = false;
  bool _isLoading = false;
  int _countdown = 180;
  Timer? _timer;
  String _error = '';

  String get _title {
    switch (_step) {
      case _Step.phone: return 'Lupa Kata Sandi';
      case _Step.otp: return 'Verifikasi Kode';
      case _Step.reset: return 'Buat Kata Sandi Baru';
    }
  }

  String get _desc {
    switch (_step) {
      case _Step.phone: return 'Masukkan nomor telepon yang terdaftar, kami akan kirim kode verifikasi.';
      case _Step.otp: return 'Masukkan kode verifikasi yang dikirim ke nomor telepon kamu.';
      case _Step.reset: return 'Buat kata sandi baru untuk akun kamu.';
    }
  }

  int get _stepIndex => _step.index;

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _handleSendCode() async {
    setState(() {
      _error = '';
      _isLoading = true;
    });
    if (_phoneController.text.trim().length < 8) {
      setState(() => _error = 'Masukkan nomor telepon yang valid.');
      setState(() => _isLoading = false);
      return;
    }

    try {
      await OtpApi.sendForgotPassword(_phoneController.text.trim());
      if (!mounted) return;
      setState(() {
        _step = _Step.otp;
        _countdown = 180;
      });
      _startCountdown();
    } catch (error) {
      if (mounted) {
        setState(() => _error = error.toString().replaceFirst('Exception: ', ''));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleVerifyOtp() async {
    setState(() => _error = '');
    if (_countdown <= 0) {
      setState(() => _error = 'Kode OTP sudah kedaluwarsa. Kirim ulang kode.');
      return;
    }
    if (_otpController.text.trim().length != 6) {
      setState(() => _error = 'Masukkan 6 digit kode verifikasi.');
      return;
    }

    setState(() => _isLoading = true);
    try {
      await OtpApi.verifyForgotPassword(
        _phoneController.text.trim(),
        _otpController.text.trim(),
      );
      if (mounted) setState(() => _step = _Step.reset);
    } catch (error) {
      if (mounted) {
        setState(() => _error = error.toString().replaceFirst('Exception: ', ''));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleReset() async {
    setState(() => _error = '');
    if (_newPasswordController.text.length < 6) {
      setState(() => _error = 'Kata sandi minimal 6 karakter.');
      return;
    }
    if (_newPasswordController.text != _confirmPasswordController.text) {
      setState(() => _error = 'Konfirmasi kata sandi tidak cocok.');
      return;
    }

    setState(() => _isLoading = true);
    try {
      await OtpApi.resetPassword(
        _phoneController.text.trim(),
        _otpController.text.trim(),
        _newPasswordController.text,
      );
      if (mounted) Navigator.pushReplacementNamed(context, '/login');
    } catch (error) {
      if (mounted) {
        setState(() => _error = error.toString().replaceFirst('Exception: ', ''));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _startCountdown() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown <= 1) {
        timer.cancel();
        if (mounted) setState(() => _countdown = 0);
      } else if (mounted) {
        setState(() => _countdown--);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background100,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 448),
          child: Container(
            color: AppColors.background50,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Hero
                  Stack(
                    children: [
                      Positioned.fill(
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Color(0xFFFFF0F7), Color(0xFFFFD6EC)],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 40, 24, 36),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: SvgPicture.asset(
                                'assets/images/elemen/Logo.svg',
                                width: 220,
                                height: 26,
                                fit: BoxFit.contain,
                              ),
                            ),
                            const SizedBox(height: 32),
                            Text(_title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.foreground950)),
                            const SizedBox(height: 8),
                            Text(_desc, style: const TextStyle(fontSize: 14, color: AppColors.foreground700)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // Form
                  Transform.translate(
                    offset: const Offset(0, -32),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: const BoxDecoration(
                        color: AppColors.background50,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Stepper
                          _buildStepper(),
                          const SizedBox(height: 24),
                          // Step content
                          if (_step == _Step.phone) _buildPhoneStep(),
                          if (_step == _Step.otp) _buildOtpStep(),
                          if (_step == _Step.reset) _buildResetStep(),
                          const SizedBox(height: 24),
                          // Back to login
                          Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text('Ingat kata sandi? ', style: TextStyle(fontSize: 14, color: AppColors.foreground500)),
                                GestureDetector(
                                  onTap: () => Navigator.pushReplacementNamed(context, '/login'),
                                  child: const Text('Masuk', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.primary600)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
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

  Widget _buildStepper() {
    return Row(
      children: List.generate(3, (i) {
        final isDone = _stepIndex > i;
        final isActive = _stepIndex == i;
        return Expanded(
          child: Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDone ? AppColors.primary500 : isActive ? AppColors.primary600 : AppColors.background200,
                ),
                child: Center(
                  child: isDone
                      ? const Icon(Icons.check, size: 14, color: AppColors.background50)
                      : Text('${i + 1}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: isActive ? AppColors.background50 : AppColors.foreground500)),
                ),
              ),
              if (i < 2)
                Expanded(
                  child: Container(
                    height: 2,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: isDone ? AppColors.primary500 : AppColors.background200,
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildPhoneStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('No. Telepon', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.foreground800)),
        const SizedBox(height: 6),
        TextField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            hintText: '08xx-xxxx-xxxx',
            prefixIcon: const Icon(Icons.smartphone, size: 18, color: AppColors.foreground400),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        if (_error.isNotEmpty) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(color: AppColors.accent100, borderRadius: BorderRadius.circular(8)),
            child: Text(_error, style: const TextStyle(fontSize: 12, color: AppColors.accent700)),
          ),
        ],
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _handleSendCode,
            child: const Text('Kirim Kode Verifikasi'),
          ),
        ),
      ],
    );
  }

  Widget _buildOtpStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: const TextStyle(fontSize: 14, color: AppColors.foreground600),
            children: [
              const TextSpan(text: 'Kode dikirim ke '),
              TextSpan(text: _phoneController.text.isEmpty ? '-' : _phoneController.text, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.foreground900)),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _countdown > 0
              ? 'Kode berlaku ${(_countdown ~/ 60).toString().padLeft(2, '0')}:${(_countdown % 60).toString().padLeft(2, '0')}'
              : 'Kode OTP sudah kedaluwarsa.',
          style: const TextStyle(fontSize: 12, color: AppColors.foreground500),
        ),
        const SizedBox(height: 12),
        const Text('Kode Verifikasi', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.foreground800)),
        const SizedBox(height: 6),
        TextField(
          controller: _otpController,
          keyboardType: TextInputType.number,
          maxLength: 6,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, letterSpacing: 8),
          decoration: InputDecoration(
            hintText: '••••••',
            counterText: '',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        if (_error.isNotEmpty) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(color: AppColors.accent100, borderRadius: BorderRadius.circular(8)),
            child: Text(_error, style: const TextStyle(fontSize: 12, color: AppColors.accent700)),
          ),
        ],
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _handleVerifyOtp,
            child: _isLoading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : const Text('Verifikasi'),
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: TextButton(
            onPressed: () => setState(() => _step = _Step.phone),
            child: const Text('Ubah nomor telepon', style: TextStyle(color: AppColors.foreground500)),
          ),
        ),
      ],
    );
  }

  Widget _buildResetStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Kata Sandi Baru', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.foreground800)),
        const SizedBox(height: 6),
        TextField(
          controller: _newPasswordController,
          obscureText: !_showPassword,
          decoration: InputDecoration(
            hintText: 'Minimal 6 karakter',
            prefixIcon: const Icon(Icons.lock_outline, size: 18, color: AppColors.foreground400),
            suffixIcon: IconButton(
              icon: Icon(_showPassword ? Icons.visibility_off : Icons.visibility, size: 18, color: AppColors.foreground400),
              onPressed: () => setState(() => _showPassword = !_showPassword),
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 16),
        const Text('Konfirmasi Kata Sandi', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.foreground800)),
        const SizedBox(height: 6),
        TextField(
          controller: _confirmPasswordController,
          obscureText: !_showPassword,
          decoration: InputDecoration(
            hintText: 'Ulangi kata sandi',
            prefixIcon: const Icon(Icons.lock_outline, size: 18, color: AppColors.foreground400),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        if (_error.isNotEmpty) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(color: AppColors.accent100, borderRadius: BorderRadius.circular(8)),
            child: Text(_error, style: const TextStyle(fontSize: 12, color: AppColors.accent700)),
          ),
        ],
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _handleReset,
            child: _isLoading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : const Text('Simpan Kata Sandi'),
          ),
        ),
      ],
    );
  }
}
