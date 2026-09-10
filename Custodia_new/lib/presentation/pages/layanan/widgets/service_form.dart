import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:custodiaa/core/theme/app_colors.dart';
import 'package:custodiaa/models/service_model.dart';
import 'package:custodiaa/mock_data/services.dart';
import 'package:custodiaa/core/navigation/app_router.dart';

class ServiceForm extends StatefulWidget {
  final Layanan layanan;

  const ServiceForm({super.key, required this.layanan});

  @override
  State<ServiceForm> createState() => _ServiceFormState();
}

class _ServiceFormState extends State<ServiceForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaCtrl = TextEditingController();
  final TextEditingController _nikCtrl = TextEditingController();
  final TextEditingController _nomorCtrl = TextEditingController();
  final TextEditingController _iccidCtrl = TextEditingController();

  String? _selectedAlasan;
  String? _fotoKartuPath;
  bool _isDemoFoto = false;
  late final String _refTrx;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _refTrx = 'TRX-260819-${100 + Random().nextInt(900)}';
  }

  @override
  void dispose() {
    _namaCtrl.dispose();
    _nikCtrl.dispose();
    _nomorCtrl.dispose();
    _iccidCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      if (image != null) {
        setState(() {
          _fotoKartuPath = image.path;
          _isDemoFoto = false;
        });
      }
    } catch (e) {
      setState(() {
        _isDemoFoto = true;
        _fotoKartuPath = 'https://images.unsplash.com/photo-1589758438368-0ad531db3366?w=500';
      });
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: const BoxDecoration(
                    color: AppColors.primary100,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    size: 36,
                    color: AppColors.primary600,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Layanan Berhasil Diproses',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.foreground950,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Transaksi ${widget.layanan.title} untuk ${_namaCtrl.text.isNotEmpty ? _namaCtrl.text : "Pelanggan"} berhasil diajukan.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 13, color: AppColors.foreground500),
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.background100,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Nomor Referensi',
                        style: TextStyle(fontSize: 11, color: AppColors.foreground400),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _refTrx,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'monospace',
                          color: AppColors.foreground950,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      Navigator.of(context).pushReplacementNamed(AppRouter.riwayat);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary600,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    child: const Text('Lihat Riwayat', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      Navigator.of(context).pushReplacementNamed(AppRouter.home);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.foreground700,
                      side: const BorderSide(color: AppColors.background300),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text('Kembali ke Beranda'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final rupiahFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Form(
      key: _formKey,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Layanan
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.primary100,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.sim_card_outlined,
                          size: 24,
                          color: AppColors.primary600,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          widget.layanan.tagline,
                          style: const TextStyle(fontSize: 13, color: AppColors.foreground500),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Data Pelanggan Card
                  _buildSectionCard(
                    title: 'Data Pelanggan',
                    icon: Icons.person_outline,
                    children: [
                      _buildLabel('Nama Lengkap'),
                      _buildTextField(
                        controller: _namaCtrl,
                        hint: 'Nama sesuai KTP',
                        validator: (v) => (v == null || v.isEmpty) ? 'Nama harus diisi' : null,
                        onChanged: (v) => setState(() {}),
                      ),
                      const SizedBox(height: 14),
                      _buildLabel('NIK'),
                      _buildTextField(
                        controller: _nikCtrl,
                        hint: '16 digit NIK',
                        keyboardType: TextInputType.number,
                        validator: (v) => (v == null || v.isEmpty) ? 'NIK harus diisi' : null,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Data Kartu Card
                  _buildSectionCard(
                    title: 'Data Kartu',
                    icon: Icons.credit_card_outlined,
                    children: [
                      _buildLabel('Nomor Indosat'),
                      _buildTextField(
                        controller: _nomorCtrl,
                        hint: '0857xxxxxxxx',
                        keyboardType: TextInputType.phone,
                        validator: (v) => (v == null || v.isEmpty) ? 'Nomor harus diisi' : null,
                        onChanged: (v) => setState(() {}),
                      ),
                      const SizedBox(height: 14),
                      _buildLabel('ICCID Kartu Baru'),
                      _buildTextField(
                        controller: _iccidCtrl,
                        hint: '89621xxxxxxxxxxxxxxxx',
                        keyboardType: TextInputType.number,
                        validator: (v) => (v == null || v.isEmpty) ? 'ICCID harus diisi' : null,
                        onChanged: (v) => setState(() {}),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Upload Foto Kartu Card
                  _buildSectionCard(
                    title: 'Upload Bukti Foto',
                    icon: Icons.camera_alt_outlined,
                    children: [
                      const Text(
                        'Foto fisik kartu / ICCID sebagai bukti verifikasi.',
                        style: TextStyle(fontSize: 12, color: AppColors.foreground400),
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          height: 120,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.background100,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.background300),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: _fotoKartuPath != null
                              ? Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    _isDemoFoto
                                        ? Image.network(_fotoKartuPath!, fit: BoxFit.cover)
                                        : (kIsWeb
                                            ? Image.network(_fotoKartuPath!, fit: BoxFit.cover)
                                            : Image.file(File(_fotoKartuPath!), fit: BoxFit.cover)),
                                    Container(
                                      color: Colors.black26,
                                      alignment: Alignment.center,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: AppColors.background50,
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: const Text(
                                          'Ganti foto kartu',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.foreground900,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : const Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.camera_alt_outlined, size: 28, color: AppColors.foreground400),
                                      SizedBox(height: 6),
                                      Text(
                                        'Tap untuk upload foto kartu',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.foreground800,
                                        ),
                                      ),
                                      Text(
                                        'Foto fisik kartu / ICCID',
                                        style: TextStyle(fontSize: 11, color: AppColors.foreground400),
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Alasan Ganti Kartu Card
                  _buildSectionCard(
                    title: 'Alasan Ganti Kartu',
                    icon: Icons.list_alt_rounded,
                    children: [
                      const Text(
                        'Opsional — pilih kalau kamu tahu alasannya.',
                        style: TextStyle(fontSize: 12, color: AppColors.foreground400),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color: AppColors.background50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.background300),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: _selectedAlasan,
                            hint: const Text(
                              'Pilih alasan (opsional)',
                              style: TextStyle(fontSize: 14, color: AppColors.foreground400),
                            ),
                            icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.foreground400),
                            items: alasanGantiKartu.map((a) {
                              return DropdownMenuItem<String>(
                                value: a,
                                child: Text(a, style: const TextStyle(fontSize: 14, color: AppColors.foreground950)),
                              );
                            }).toList(),
                            onChanged: (val) => setState(() => _selectedAlasan = val),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Ringkasan Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.background50,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.background200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Ringkasan',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.foreground950,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildSummaryRow('Layanan', widget.layanan.title),
                        _buildSummaryRow('Pelanggan', _namaCtrl.text.isNotEmpty ? _namaCtrl.text : '—'),
                        _buildSummaryRow('Nomor', _nomorCtrl.text.isNotEmpty ? _nomorCtrl.text : '—'),
                        _buildSummaryRow('ICCID', _iccidCtrl.text.isNotEmpty ? _iccidCtrl.text : '—'),
                        if (_selectedAlasan != null) _buildSummaryRow('Alasan', _selectedAlasan!),
                        _buildSummaryRow('Estimasi', widget.layanan.estimasi),
                        const Divider(color: AppColors.background200, height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Biaya', style: TextStyle(fontSize: 13, color: AppColors.foreground500)),
                            Text(
                              rupiahFormat.format(widget.layanan.biaya),
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: AppColors.foreground950,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Info Banner
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.accent100,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.info_outline, size: 20, color: AppColors.accent900),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Pastikan data pelanggan sesuai dengan KTP. Proses verifikasi NIK akan dilakukan otomatis oleh sistem.',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.accent900,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Submit Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: AppColors.background50,
              border: Border(top: BorderSide(color: AppColors.background200)),
            ),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      _showSuccessDialog();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary600,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Proses Layanan',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.background200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: AppColors.primary500),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.foreground950,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: AppColors.foreground800,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    ValueChanged<String>? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      onChanged: onChanged,
      style: const TextStyle(fontSize: 14, color: AppColors.foreground950),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 14, color: AppColors.foreground400),
        filled: true,
        fillColor: AppColors.background50,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.background300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.background300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary300, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 13, color: AppColors.foreground500)),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.foreground950,
            ),
          ),
        ],
      ),
    );
  }
}
