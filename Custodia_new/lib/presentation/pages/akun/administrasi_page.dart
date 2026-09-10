import 'package:flutter/material.dart';
import 'package:custodiaa/core/theme/app_colors.dart';
import 'package:custodiaa/mock_data/outlets.dart';
import 'package:custodiaa/presentation/widgets/reveal.dart';

class AdministrasiPage extends StatefulWidget {
  const AdministrasiPage({super.key});

  @override
  State<AdministrasiPage> createState() => _AdministrasiPageState();
}

class _AdministrasiPageState extends State<AdministrasiPage> {
  String _query = '';
  String _selectedKategori = 'semua';

  final List<Map<String, String>> _kategoriTabs = [
    {'id': 'semua', 'label': 'Semua'},
    {'id': 'pemain', 'label': 'Pemain'},
    {'id': 'reaktif', 'label': 'Reaktif'},
    {'id': 'pasif', 'label': 'Pasif'},
  ];

  @override
  Widget build(BuildContext context) {
    final totalStok = daftarOutlet.fold<int>(0, (sum, o) => sum + o.stokIccid);
    final totalAwal = daftarOutlet.fold<int>(0, (sum, o) => sum + o.stokAwal);
    final terpakai = totalAwal - totalStok;
    final menipis = daftarOutlet.where((o) => o.stokIccid < 20).length;

    final outletTersaring = daftarOutlet.where((o) {
      final cocokKategori = _selectedKategori == 'semua' ||
          o.kategori.name.toLowerCase() == _selectedKategori.toLowerCase();
      final q = _query.toLowerCase();
      final cocokQuery = q.isEmpty ||
          o.nama.toLowerCase().contains(q) ||
          o.kota.toLowerCase().contains(q) ||
          o.bsm.toLowerCase().contains(q);
      return cocokKategori && cocokQuery;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background100,
      appBar: AppBar(
        backgroundColor: AppColors.background50,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.foreground800),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Manajemen Stok',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.foreground950,
              ),
            ),
            Text(
              'Kartu SIM & eSIM per outlet',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.foreground400,
              ),
            ),
          ],
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: AppColors.background200),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Summary KPI Grid
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.45,
                  children: [
                    _buildKpiCard(
                      icon: Icons.layers_outlined,
                      iconBg: AppColors.primary100,
                      iconColor: AppColors.primary600,
                      value: '$totalStok',
                      label: 'Total Stok Tersisa',
                    ),
                    _buildKpiCard(
                      icon: Icons.sim_card_outlined,
                      iconBg: AppColors.cyan100,
                      iconColor: AppColors.cyan700,
                      value: '$terpakai',
                      label: 'Kartu Terpakai',
                    ),
                    _buildKpiCard(
                      icon: Icons.store_outlined,
                      iconBg: AppColors.secondary100,
                      iconColor: AppColors.secondary900,
                      value: '${daftarOutlet.length}',
                      label: 'Total Outlet',
                    ),
                    _buildKpiCard(
                      icon: Icons.warning_amber_rounded,
                      iconBg: AppColors.accent100,
                      iconColor: AppColors.accent700,
                      value: '$menipis',
                      label: 'Stok Menipis',
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Search Input
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.background50,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.background300),
                  ),
                  child: TextField(
                    onChanged: (val) => setState(() => _query = val),
                    style: const TextStyle(fontSize: 14, color: AppColors.foreground950),
                    decoration: InputDecoration(
                      hintText: 'Cari outlet atau kota...',
                      hintStyle: const TextStyle(fontSize: 14, color: AppColors.foreground400),
                      prefixIcon: const Icon(Icons.search, size: 20, color: AppColors.foreground400),
                      suffixIcon: _query.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.close, size: 18, color: AppColors.foreground400),
                              onPressed: () => setState(() => _query = ''),
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 13),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Category Filter Tabs
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.background100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: _kategoriTabs.map((tab) {
                      final isActive = _selectedKategori == tab['id'];
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedKategori = tab['id']!),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: isActive ? AppColors.background50 : Colors.transparent,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: isActive
                                  ? [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.04),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Text(
                              tab['label']!,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                                color: isActive
                                    ? AppColors.foreground950
                                    : AppColors.foreground500,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 16),

                // Outlet Stock List
                if (outletTersaring.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 36),
                    child: Center(
                      child: Text(
                        'Outlet tidak ditemukan.',
                        style: TextStyle(color: AppColors.foreground400),
                      ),
                    ),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: outletTersaring.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, idx) {
                      final o = outletTersaring[idx];
                      final persen = ((o.stokIccid / o.stokAwal) * 100).round();
                      final isKritis = o.stokIccid < 10;
                      final isMenipis = o.stokIccid >= 10 && o.stokIccid < 20;

                      Color statusColor = const Color(0xFF22C55E);
                      String statusText = 'Aman';
                      if (isKritis) {
                        statusColor = AppColors.accent600;
                        statusText = 'Kritis';
                      } else if (isMenipis) {
                        statusColor = const Color(0xFFF59E0B);
                        statusText = 'Menipis';
                      }

                      return Reveal(
                        delay: Duration(milliseconds: idx * 25),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.background50,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: AppColors.background200),
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
                                      color: AppColors.primary100,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(Icons.store_outlined, size: 20, color: AppColors.primary600),
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
                                                o.nama,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColors.foreground950,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: statusColor.withValues(alpha: 0.15),
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: Text(
                                                statusText,
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                  color: statusColor,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          '${o.kota} · ${o.bsm}',
                                          style: const TextStyle(fontSize: 12, color: AppColors.foreground400),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),

                              // Progress bar
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      style: const TextStyle(fontSize: 12, color: AppColors.foreground500),
                                      children: [
                                        const TextSpan(text: 'Stok tersisa '),
                                        TextSpan(
                                          text: '${o.stokIccid}',
                                          style: TextStyle(fontWeight: FontWeight.bold, color: statusColor),
                                        ),
                                        TextSpan(text: ' / ${o.stokAwal}'),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    '$persen%',
                                    style: const TextStyle(fontSize: 12, color: AppColors.foreground400),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: (o.stokIccid / o.stokAwal).clamp(0.0, 1.0),
                                  backgroundColor: AppColors.background200,
                                  valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                                  minHeight: 6,
                                ),
                              ),
                              const SizedBox(height: 12),

                              const Divider(color: AppColors.background200, height: 1),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Transaksi bulan ini',
                                    style: TextStyle(fontSize: 12, color: AppColors.foreground400),
                                  ),
                                  Text(
                                    '${o.transaksi}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.foreground900,
                                    ),
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
        ),
      ),
    );
  }

  Widget _buildKpiCard({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String value,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.background50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.background200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: iconColor),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.foreground950),
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: AppColors.foreground400),
          ),
        ],
      ),
    );
  }
}
