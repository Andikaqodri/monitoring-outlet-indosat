import 'package:flutter/material.dart';
import 'package:custodiaa/core/theme/app_colors.dart';

class EditAkunPage extends StatefulWidget {
  const EditAkunPage({super.key});

  @override
  State<EditAkunPage> createState() => _EditAkunPageState();
}

class _EditAkunPageState extends State<EditAkunPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaCtrl = TextEditingController(text: 'Agus Saputra');
  final TextEditingController _emailCtrl = TextEditingController(text: 'agus.saputra@indosat.co.id');
  final TextEditingController _teleponCtrl = TextEditingController(text: '+62 858-5171-5758');
  final TextEditingController _outletCtrl = TextEditingController(text: 'Indosat Mall Kelapa Gading');

  @override
  void dispose() {
    _namaCtrl.dispose();
    _emailCtrl.dispose();
    _teleponCtrl.dispose();
    _outletCtrl.dispose();
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
                'Data Berhasil Diperbarui',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.foreground950,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Perubahan data pengguna ${_namaCtrl.text} telah disimpan.',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13, color: AppColors.foreground500),
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
        title: const Text(
          'Edit Pengaturan Pengguna',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.foreground950,
          ),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: AppColors.background200),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Section Profil
                        _buildSection(
                          title: 'Profil',
                          icon: Icons.person_outline,
                          children: [
                            _buildLabel('Nama Lengkap'),
                            _buildTextField(
                              controller: _namaCtrl,
                              hint: 'Nama lengkap',
                              icon: Icons.person_outline,
                              validator: (v) => (v == null || v.isEmpty) ? 'Nama wajib diisi' : null,
                            ),
                            const SizedBox(height: 14),
                            _buildLabel('Email'),
                            _buildTextField(
                              controller: _emailCtrl,
                              hint: 'email@indosat.co.id',
                              icon: Icons.mail_outline,
                              keyboardType: TextInputType.emailAddress,
                              validator: (v) => (v == null || v.isEmpty) ? 'Email wajib diisi' : null,
                            ),
                            const SizedBox(height: 14),
                            _buildLabel('No. HP'),
                            _buildTextField(
                              controller: _teleponCtrl,
                              hint: '08xx-xxxx-xxxx',
                              icon: Icons.phone_android_outlined,
                              keyboardType: TextInputType.phone,
                              validator: (v) => (v == null || v.isEmpty) ? 'No. HP wajib diisi' : null,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Section Outlet
                        _buildSection(
                          title: 'Outlet',
                          icon: Icons.store_outlined,
                          children: [
                            _buildLabel('Nama Outlet'),
                            _buildTextField(
                              controller: _outletCtrl,
                              hint: 'Nama outlet',
                              icon: Icons.storefront_outlined,
                              validator: (v) => (v == null || v.isEmpty) ? 'Outlet wajib diisi' : null,
                            ),
                            const SizedBox(height: 14),
                            _buildLabel('ID Staff'),
                            TextField(
                              readOnly: true,
                              controller: TextEditingController(text: 'SH042484'),
                              style: const TextStyle(fontSize: 14, color: AppColors.foreground500),
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.fingerprint, size: 20, color: AppColors.foreground400),
                                filled: true,
                                fillColor: AppColors.background100,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(color: AppColors.background200),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(color: AppColors.background200),
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'ID Staff tidak dapat diubah.',
                              style: TextStyle(fontSize: 12, color: AppColors.foreground400),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Info Section
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
                                  'Perubahan data akan langsung diterapkan ke akun Anda. Pastikan email dan nomor HP aktif untuk menerima notifikasi.',
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

                // Bottom Button
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
                          'Simpan Perubahan',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
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

  Widget _buildSection({
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
              Icon(icon, size: 18, color: AppColors.primary600),
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
    required IconData icon,
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
        prefixIcon: Icon(icon, size: 20, color: AppColors.foreground400),
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
