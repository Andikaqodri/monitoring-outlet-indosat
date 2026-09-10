import 'package:flutter/material.dart';
import 'package:custodiaa/core/theme/app_colors.dart';
import 'package:custodiaa/mock_data/transactions.dart';
import 'package:custodiaa/presentation/widgets/reveal.dart';

class RiwayatPage extends StatefulWidget {
  const RiwayatPage({super.key});

  @override
  State<RiwayatPage> createState() => _RiwayatPageState();
}

class _RiwayatPageState extends State<RiwayatPage> {
  String _filter = 'Semua';
  String _cari = '';
  final List<String> _filterList = ['Semua', 'Sukses', 'Pending', 'Gagal'];

  @override
  Widget build(BuildContext context) {
    final filteredData = daftarTransaksi.where((t) {
      final cocokStatus = _filter == 'Semua' || t.status.toLowerCase() == _filter.toLowerCase();
      final q = _cari.toLowerCase();
      final cocokCari = q.isEmpty ||
          t.nama.toLowerCase().contains(q) ||
          t.nomor.toLowerCase().contains(q) ||
          t.id.toLowerCase().contains(q);
      return cocokStatus && cocokCari;
    }).toList();

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
                  // Header Gradient Teal
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF32BCAD), Color(0xFF5CD1C3), Color(0xFF1FA398)],
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
                          const Text(
                            'Riwayat Transaksi',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Semua transaksi layanan kartu dari outlet.',
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
                        // Search bar
                        Reveal(
                          delay: const Duration(milliseconds: 50),
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.background50,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppColors.background300),
                            ),
                            child: TextField(
                              onChanged: (val) => setState(() => _cari = val),
                              style: const TextStyle(fontSize: 14, color: AppColors.foreground950),
                              decoration: InputDecoration(
                                hintText: 'Cari nama, nomor, atau ID...',
                                hintStyle: const TextStyle(fontSize: 14, color: AppColors.foreground400),
                                prefixIcon: const Icon(Icons.search, size: 20, color: AppColors.foreground400),
                                suffixIcon: _cari.isNotEmpty
                                    ? IconButton(
                                        icon: const Icon(Icons.close, size: 18, color: AppColors.foreground400),
                                        onPressed: () => setState(() => _cari = ''),
                                      )
                                    : null,
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Filter Pills
                        SizedBox(
                          height: 38,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: _filterList.length,
                            separatorBuilder: (context, index) => const SizedBox(width: 8),
                            itemBuilder: (context, idx) {
                              final f = _filterList[idx];
                              final isActive = _filter == f;
                              return GestureDetector(
                                onTap: () => setState(() => _filter = f),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: isActive ? const Color(0xFF32BCAD) : AppColors.background100,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    f,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: isActive ? Colors.white : AppColors.foreground600,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Transactions List
                        if (filteredData.isEmpty)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 48),
                            child: Column(
                              children: [
                                Icon(Icons.inbox_outlined, size: 48, color: AppColors.foreground300),
                                SizedBox(height: 12),
                                Text(
                                  'Tidak ada transaksi yang cocok.',
                                  style: TextStyle(fontSize: 14, color: AppColors.foreground500),
                                ),
                              ],
                            ),
                          )
                        else
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: filteredData.length,
                            separatorBuilder: (context, index) => const SizedBox(height: 12),
                            itemBuilder: (context, idx) {
                              final trx = filteredData[idx];
                              return Reveal(
                                delay: Duration(milliseconds: idx * 30),
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: AppColors.background50,
                                    borderRadius: BorderRadius.circular(18),
                                    border: Border.all(color: AppColors.background200),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.02),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFD2F4EE),
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: const Icon(
                                              Icons.sim_card_outlined,
                                              size: 20,
                                              color: Color(0xFF1FA398),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        trx.nama,
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.bold,
                                                          color: AppColors.foreground950,
                                                        ),
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                    ),
                                                    _buildStatusBadge(trx.status),
                                                  ],
                                                ),
                                                const SizedBox(height: 2),
                                                Text(
                                                  trx.layanan,
                                                  style: const TextStyle(fontSize: 12, color: AppColors.foreground500),
                                                ),
                                                const SizedBox(height: 2),
                                                Text(
                                                  trx.nomor,
                                                  style: const TextStyle(fontSize: 12, color: AppColors.foreground400),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      const Divider(color: AppColors.background200, height: 1),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            trx.id,
                                            style: const TextStyle(
                                              fontSize: 11,
                                              fontFamily: 'monospace',
                                              color: AppColors.foreground400,
                                            ),
                                          ),
                                          Text(
                                            '${trx.tanggal} · ${trx.waktu}',
                                            style: const TextStyle(fontSize: 12, color: AppColors.foreground400),
                                          ),
                                        ],
                                      ),
                                    ],
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

  Widget _buildStatusBadge(String status) {
    Color bgColor;
    Color textColor;

    switch (status.toLowerCase()) {
      case 'sukses':
        bgColor = const Color(0xFFD2F4EE);
        textColor = const Color(0xFF18988A);
        break;
      case 'pending':
        bgColor = const Color(0xFFE6F7F4);
        textColor = const Color(0xFF2FA89B);
        break;
      default:
        bgColor = const Color(0xFFEFF9F7);
        textColor = const Color(0xFF5F8F8A);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: textColor),
      ),
    );
  }
}
