import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:custodiaa/core/theme/app_colors.dart';
import 'package:custodiaa/models/outlet_data_model.dart';
import 'package:custodiaa/presentation/pages/register/widgets/step_outlet.dart';
import 'package:custodiaa/presentation/pages/register/widgets/step_agreement.dart';
import 'package:custodiaa/presentation/pages/register/widgets/step_otp.dart';
import 'package:custodiaa/presentation/pages/register/widgets/step_approval.dart';
import 'package:custodiaa/presentation/pages/register/widgets/step_evidence.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  static const List<String> _stepLabels = [
    'Outlet',
    'Agreement',
    'OTP',
    'Approval',
    'Evidence',
  ];

  int _step = 0;
  final OutletData _outletData = OutletData();

  void _updateData(String key, String value) {
    setState(() {
      switch (key) {
        case 'idOutlet':
          _outletData.idOutlet = int.tryParse(value);
          break;
        case 'namaOutlet':
          _outletData.namaOutlet = value;
          break;
        case 'wilayah':
          _outletData.wilayah = value;
          break;
        case 'cluster':
          _outletData.cluster = value;
          break;
        case 'tipeOutlet':
          _outletData.tipeOutlet = value;
          break;
        case 'alamat':
          _outletData.alamat = value;
          break;
        case 'namaPemilik':
          _outletData.namaPemilik = value;
          break;
        case 'noHp':
          _outletData.noHp = value;
          break;
      }
    });
  }

  void _goNext() {
    setState(() {
      if (_step < _stepLabels.length - 1) {
        _step++;
      }
    });
  }

  void _goBack() {
    setState(() {
      if (_step > 0) {
        _step--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background100,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Container(
              color: AppColors.background50,
              child: Column(
                children: [
                  // Header branding
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    color: AppColors.background50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset(
                              'assets/images/elemen/Logo.svg',
                              height: 28,
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary50,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: AppColors.primary200),
                              ),
                              child: const Text(
                                'Pendaftaran',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary700,
                                ),
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.close,
                            color: AppColors.foreground700,
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                          style: IconButton.styleFrom(
                            backgroundColor: AppColors.background100,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Stepper Progress
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                    decoration: const BoxDecoration(
                      color: AppColors.background50,
                      border: Border(
                        bottom: BorderSide(color: AppColors.background200),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: List.generate(_stepLabels.length * 2 - 1, (
                            index,
                          ) {
                            if (index.isOdd) {
                              final stepIndex = index ~/ 2;
                              final isCompleted = stepIndex < _step;
                              return Expanded(
                                child: Container(
                                  height: 2,
                                  color: isCompleted
                                      ? AppColors.accent500
                                      : AppColors.background200,
                                ),
                              );
                            } else {
                              final i = index ~/ 2;
                              final isCompleted = i < _step;
                              final isCurrent = i == _step;

                              Color bgColor = AppColors.background200;
                              Color textColor = AppColors.foreground500;
                              if (isCompleted) {
                                bgColor = AppColors.accent500;
                                textColor = Colors.white;
                              } else if (isCurrent) {
                                bgColor = AppColors.primary600;
                                textColor = Colors.white;
                              }

                              return Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: bgColor,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: isCompleted
                                      ? const Icon(
                                          Icons.check,
                                          size: 16,
                                          color: Colors.white,
                                        )
                                      : Text(
                                          '${i + 1}',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: textColor,
                                          ),
                                        ),
                                ),
                              );
                            }
                          }),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(_stepLabels.length, (i) {
                            final isCurrent = i == _step;
                            return SizedBox(
                              width: 50,
                              child: Text(
                                _stepLabels[i],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: isCurrent
                                      ? FontWeight.bold
                                      : FontWeight.w500,
                                  color: isCurrent
                                      ? AppColors.primary700
                                      : AppColors.foreground400,
                                ),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),

                  // Step Content Scrollable
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 20,
                      ),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        transitionBuilder: (child, animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                        child: KeyedSubtree(
                          key: ValueKey<int>(_step),
                          child: _buildCurrentStep(),
                        ),
                      ),
                    ),
                  ),

                  // Footer note
                  const Padding(
                    padding: EdgeInsets.only(
                      left: 20,
                      right: 20,
                      bottom: 16,
                      top: 4,
                    ),
                    child: Text(
                      'Kode OTP akan dikirim ke WhatsApp nomor outlet.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.foreground400,
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

  Widget _buildCurrentStep() {
    switch (_step) {
      case 0:
        return StepOutlet(
          data: _outletData,
          onChange: _updateData,
          onNext: _goNext,
        );
      case 1:
        return StepAgreement(
          data: _outletData,
          onNext: _goNext,
          onBack: _goBack,
        );
      case 2:
        return StepOtp(
          phoneNumber: _outletData.noHp,
          onVerified: _goNext,
          onBack: _goBack,
        );
      case 3:
        return StepApproval(
          data: _outletData,
          onNext: _goNext,
          onBack: _goBack,
        );
      case 4:
        return StepEvidence(data: _outletData, onBack: _goBack);
      default:
        return const SizedBox.shrink();
    }
  }
}
