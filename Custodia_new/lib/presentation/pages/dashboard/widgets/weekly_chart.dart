import 'package:flutter/material.dart';
import 'package:custodiaa/core/theme/app_colors.dart';
import 'package:custodiaa/mock_data/transactions.dart';

class WeeklyChart extends StatelessWidget {
  const WeeklyChart({super.key});

  @override
  Widget build(BuildContext context) {
    final maxVal = statistikMingguan.map((e) => e.transaksi).reduce((a, b) => a > b ? a : b).toDouble();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: statistikMingguan.asMap().entries.map((entry) {
        final i = entry.key;
        final data = entry.value;
        final fraction = (data.transaksi / maxVal).clamp(0.25, 1.0);
        final isMax = data.transaksi == maxVal.toInt();

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Bar
                SizedBox(
                  height: 90,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.1, end: fraction),
                      duration: Duration(milliseconds: 500 + i * 70),
                      curve: Curves.easeOutCubic,
                      builder: (context, val, _) {
                        return Container(
                          width: 22,
                          height: 90 * val,
                          decoration: BoxDecoration(
                            color: isMax
                                ? const Color(0xFFC6168D)
                                : const Color(0xFFF9B4D0),
                            borderRadius: BorderRadius.circular(100),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // Day label
                Text(
                  data.hari,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: isMax ? FontWeight.bold : FontWeight.w500,
                    color: isMax ? AppColors.foreground950 : AppColors.foreground400,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
