import 'package:flutter/material.dart';
import 'package:custodiaa/core/theme/app_colors.dart';

class HubungiPage extends StatefulWidget {
  const HubungiPage({super.key});

  @override
  State<HubungiPage> createState() => _HubungiPageState();
}

class _HubungiPageState extends State<HubungiPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _teleponCtrl = TextEditingController();
  final TextEditingController _pesanCtrl = TextEditingController();
  String? _selectedKategori;

  final List<String> _kategoriList = [
    'Kendala Transaksi',
    'Masalah Stok Kartu',
    'Pertanyaan Produk / Program',
    'Akun & Login',
    'Lainnya',
  ];

  @override
  void dispose() {
    _namaCtrl.dispose();
    _emailCtrl.dispose();
    _teleponCtrl.dispose();
    _pesanCtrl.dispose();
    super.dispose();
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
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
                child: const Icon(Icons.check, size: 36, color: AppColors.primary600),
              ),
              const SizedBox(height: 16),
              const Text(
                'Pesan Terkirim',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.foreground950,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Terima kasih! Tim kami akan segera menghubungi Anda.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: AppColors.foreground500),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary600,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: const Text('Kembali ke Akun', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
              'Hubungi Kami',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.foreground950,
              ),
            ),
            Text(
              'Bantuan & Dukungan',
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Quick Contact Cards
                Row(
                  children: [
                    _buildContactCard(
                      icon: Icons.chat_bubble_outline_rounded,
                      title: 'WhatsApp',
                      subtitle: '+62 855-1000-185',
                      color: const Color(0xFF22C55E),
                    ),
                    const SizedBox(width: 10),
                    _buildContactCard(
                      icon: Icons.phone_in_talk_outlined,
                      title: 'Call Center',
                      subtitle: '185 (Bebas Pulsa)',
                      color: AppColors.primary600,
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Form Kirim Pesan
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.background50,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.background200),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.mail_outline, size: 18, color: AppColors.primary600),
                            SizedBox(width: 8),
                            Text(
                              'Kirim Pesan',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.foreground950,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Isi form di bawah, tim kami akan segera menghubungi Anda.',
                          style: TextStyle(fontSize: 12, color: AppColors.foreground400),
                        ),
                        const SizedBox(height: 16),

                        _buildLabel('Nama Lengkap'),
                        _buildTextField(
                          controller: _namaCtrl,
                          hint: 'Nama Anda',
                          validator: (v) => (v == null || v.isEmpty) ? 'Nama wajib diisi' : null,
                        ),
                        const SizedBox(height: 14),

                        _buildLabel('Email'),
                        _buildTextField(
                          controller: _emailCtrl,
                          hint: 'email@contoh.com',
                          keyboardType: TextInputType.emailAddress,
                          validator: (v) => (v == null || v.isEmpty) ? 'Email wajib diisi' : null,
                        ),
                        const SizedBox(height: 14),

                        _buildLabel('No. HP'),
                        _buildTextField(
                          controller: _teleponCtrl,
                          hint: '08xx-xxxx-xxxx',
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 14),

                        _buildLabel('Kategori'),
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
                              value: _selectedKategori,
                              hint: const Text(
                                'Pilih kategori',
                                style: TextStyle(fontSize: 14, color: AppColors.foreground400),
                              ),
                              icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.foreground400),
                              items: _kategoriList.map((k) {
                                return DropdownMenuItem<String>(
                                  value: k,
                                  child: Text(k, style: const TextStyle(fontSize: 14, color: AppColors.foreground950)),
                                );
                              }).toList(),
                              onChanged: (val) => setState(() => _selectedKategori = val),
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),

                        _buildLabel('Pesan'),
                        TextFormField(
                          controller: _pesanCtrl,
                          maxLines: 4,
                          maxLength: 500,
                          onChanged: (_) => setState(() {}),
                          validator: (v) => (v == null || v.isEmpty) ? 'Pesan tidak boleh kosong' : null,
                          style: const TextStyle(fontSize: 14, color: AppColors.foreground950),
                          decoration: InputDecoration(
                            hintText: 'Tuliskan pertanyaan atau kendala Anda...',
                            hintStyle: const TextStyle(fontSize: 14, color: AppColors.foreground400),
                            filled: true,
                            fillColor: AppColors.background50,
                            contentPadding: const EdgeInsets.all(14),
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
                        ),
                        const SizedBox(height: 16),

                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              if (_formKey.currentState?.validate() ?? false) {
                                _showSuccessDialog();
                              }
                            },
                            icon: const Icon(Icons.send_rounded, size: 18),
                            label: const Text('Kirim Pesan', style: TextStyle(fontWeight: FontWeight.bold)),
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContactCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.background50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.background200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 20, color: color),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.foreground950),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 11, color: AppColors.foreground500),
            ),
          ],
        ),
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
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
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
}
