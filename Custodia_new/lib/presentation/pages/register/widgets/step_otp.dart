import 'dart:async';
import 'package:flutter/material.dart';
import 'package:custodiaa/core/network/otp_api.dart';
import 'package:custodiaa/core/theme/app_colors.dart';

class StepOtp extends StatefulWidget {
  final String phoneNumber;
  final VoidCallback onVerified;
  final VoidCallback onBack;

  const StepOtp({
    super.key,
    required this.phoneNumber,
    required this.onVerified,
    required this.onBack,
  });

  @override
  State<StepOtp> createState() => _StepOtpState();
}

class _StepOtpState extends State<StepOtp> {
  bool _sent = false;
  bool _isLoading = false;
  int _countdown = 180;
  Timer? _timer;
  final List<String> _digits = ['', '', '', '', '', ''];
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  String _error = '';

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  Future<void> _sendOtp() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      await OtpApi.send(widget.phoneNumber);
      if (!mounted) return;
      setState(() {
        _sent = true;
        _countdown = 180;
        for (int i = 0; i < 6; i++) {
          _digits[i] = '';
          _controllers[i].clear();
        }
      });
      _startCountdown();
    } catch (error) {
      if (mounted)
        setState(
          () => _error = error.toString().replaceFirst('Exception: ', ''),
        );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _startCountdown() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown <= 1) {
        timer.cancel();
        setState(() => _countdown = 0);
      } else {
        setState(() => _countdown--);
      }
    });
  }

  void _handleVerify() {
    if (_countdown <= 0) {
      setState(
        () => _error = 'Kode OTP sudah kedaluwarsa. Kirim ulang kode baru.',
      );
      return;
    }
    final input = _digits.join('');
    if (input.length < 6) {
      setState(() => _error = 'Masukkan 6 digit kode OTP terlebih dahulu.');
      return;
    }
    _verifyOtp(input);
  }

  Future<void> _verifyOtp(String input) async {
    setState(() {
      _isLoading = true;
      _error = '';
    });
    try {
      await OtpApi.verify(widget.phoneNumber, input);
      if (mounted) widget.onVerified();
    } catch (error) {
      if (mounted)
        setState(
          () => _error = error.toString().replaceFirst('Exception: ', ''),
        );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Verifikasi OTP',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.foreground950,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Kode OTP dikirim ke nomor outlet untuk persetujuan agreement.',
          style: TextStyle(fontSize: 14, color: AppColors.foreground500),
        ),
        const SizedBox(height: 20),

        if (!_sent) ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.background100.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.background200),
            ),
            child: Column(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.primary100,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.phone_android_rounded,
                    size: 28,
                    color: AppColors.primary700,
                  ),
                ),
                const SizedBox(height: 16),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.foreground700,
                    ),
                    children: [
                      const TextSpan(text: 'Kirim kode OTP ke nomor '),
                      TextSpan(
                        text: widget.phoneNumber.isNotEmpty
                            ? widget.phoneNumber
                            : '(belum diisi)',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.foreground950,
                        ),
                      ),
                      const TextSpan(text: ' untuk mengautentikasi outlet.'),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _sendOtp,
                    icon: const Icon(Icons.send_rounded, size: 18),
                    label: _isLoading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('Kirim OTP'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary600,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ] else ...[
          // Countdown
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Dikirim ke ${widget.phoneNumber}',
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.foreground500,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: _countdown > 0
                      ? AppColors.secondary100
                      : AppColors.accent100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _countdown > 0
                      ? '00:${_countdown.toString().padLeft(2, '0')}'
                      : 'Kedaluwarsa',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: _countdown > 0
                        ? AppColors.secondary900
                        : AppColors.accent900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // OTP Inputs
          const Text(
            'Masukkan Kode OTP',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.foreground800,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(6, (i) {
              return SizedBox(
                width: 46,
                height: 54,
                child: TextField(
                  controller: _controllers[i],
                  focusNode: _focusNodes[i],
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  maxLength: 1,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.foreground950,
                  ),
                  decoration: InputDecoration(
                    counterText: '',
                    filled: true,
                    fillColor: AppColors.background50,
                    contentPadding: EdgeInsets.zero,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: AppColors.background300,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: AppColors.background300,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: AppColors.primary300,
                        width: 2,
                      ),
                    ),
                  ),
                  onChanged: (val) {
                    _digits[i] = val;
                    if (val.isNotEmpty && i < 5) {
                      _focusNodes[i + 1].requestFocus();
                    } else if (val.isEmpty && i > 0) {
                      _focusNodes[i - 1].requestFocus();
                    }
                    setState(() {});
                  },
                ),
              );
            }),
          ),
          if (_error.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              _error,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.accent600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
          const SizedBox(height: 16),

          // Resend button / note
          Center(
            child: _countdown <= 0
                ? TextButton(
                    onPressed: _isLoading ? null : _sendOtp,
                    child: const Text(
                      'Kirim ulang OTP',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary600,
                      ),
                    ),
                  )
                : const Text(
                    'Belum terima kode? Tunggu hitungan mundur selesai.',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.foreground500,
                    ),
                  ),
          ),
        ],

        const SizedBox(height: 24),

        // Buttons
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
                  onPressed: _sent && !_isLoading ? _handleVerify : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary600,
                    disabledBackgroundColor: AppColors.primary600.withValues(
                      alpha: 0.4,
                    ),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Verifikasi & Approve',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
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
}
