import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:custodiaa/core/theme/app_colors.dart';
import 'package:custodiaa/models/outlet_data_model.dart';

class StepOutlet extends StatefulWidget {
  final OutletData data;
  final Function(String key, String value) onChange;
  final VoidCallback onNext;

  const StepOutlet({
    super.key,
    required this.data,
    required this.onChange,
    required this.onNext,
  });

  @override
  State<StepOutlet> createState() => _StepOutletState();
}

class _StepOutletState extends State<StepOutlet> {
  late TextEditingController _idOutletCtrl;
  late TextEditingController _namaOutletCtrl;
  late TextEditingController _alamatCtrl;
  late TextEditingController _namaPemilikCtrl;
  late TextEditingController _noHpCtrl;
  String? _selectedWilayah;

  @override
  void initState() {
    super.initState();
    _idOutletCtrl = TextEditingController(
        text: widget.data.idOutlet != null ? widget.data.idOutlet.toString() : '');
    _namaOutletCtrl = TextEditingController(text: widget.data.namaOutlet);
    _alamatCtrl = TextEditingController(text: widget.data.alamat);
    _namaPemilikCtrl = TextEditingController(text: widget.data.namaPemilik);
    _noHpCtrl = TextEditingController(text: widget.data.noHp);
    _selectedWilayah = widget.data.wilayah.isNotEmpty ? widget.data.wilayah : null;
  }

  @override
  void dispose() {
    _idOutletCtrl.dispose();
    _namaOutletCtrl.dispose();
    _alamatCtrl.dispose();
    _namaPemilikCtrl.dispose();
    _noHpCtrl.dispose();
    super.dispose();
  }

  bool get _isComplete =>
      widget.data.idOutlet != null &&
      widget.data.idOutlet! > 0 &&
      widget.data.namaOutlet.trim().isNotEmpty &&
      widget.data.wilayah.trim().isNotEmpty &&
      widget.data.alamat.trim().isNotEmpty &&
      widget.data.namaPemilik.trim().isNotEmpty &&
      widget.data.noHp.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Data Outlet',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.foreground950,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Isi informasi outlet yang akan didaftarkan.',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.foreground500,
          ),
        ),
        const SizedBox(height: 20),

        // ID Outlet
        _buildLabel('ID Outlet'),
        _buildTextField(
          controller: _idOutletCtrl,
          hint: 'Contoh: 10293',
          prefixIcon: Icons.badge_outlined,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: (v) {
            widget.onChange('idOutlet', v);
            setState(() {});
          },
        ),
        const SizedBox(height: 16),

        // Nama Outlet
        _buildLabel('Nama Outlet'),
        _buildTextField(
          controller: _namaOutletCtrl,
          hint: 'Custodia Konter Maju Jaya',
          prefixIcon: Icons.store_outlined,
          onChanged: (v) {
            widget.onChange('namaOutlet', v);
            setState(() {});
          },
        ),
        const SizedBox(height: 16),

        // Wilayah (Dropdown)
        _buildLabel('Wilayah'),
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
              value: _selectedWilayah,
              hint: const Row(
                children: [
                  Icon(Icons.location_city_outlined, size: 20, color: AppColors.foreground400),
                  SizedBox(width: 10),
                  Text(
                    'Pilih wilayah',
                    style: TextStyle(fontSize: 14, color: AppColors.foreground400),
                  ),
                ],
              ),
              icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.foreground400),
              items: daftarWilayah.map((wilayah) {
                return DropdownMenuItem<String>(
                  value: wilayah,
                  child: Row(
                    children: [
                      const Icon(Icons.location_city_outlined, size: 20, color: AppColors.foreground400),
                      const SizedBox(width: 10),
                      Text(
                        wilayah,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.foreground950,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() => _selectedWilayah = val);
                  widget.onChange('wilayah', val);
                }
              },
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Alamat Outlet
        _buildLabel('Alamat Outlet'),
        _buildTextField(
          controller: _alamatCtrl,
          hint: 'Jl. Raya Kelapa Gading No. 12, Jakarta Utara',
          prefixIcon: Icons.location_on_outlined,
          maxLines: 2,
          onChanged: (v) {
            widget.onChange('alamat', v);
            setState(() {});
          },
        ),
        const SizedBox(height: 16),

        // Nama Pemilik
        _buildLabel('Nama Pemilik (Owner)'),
        _buildTextField(
          controller: _namaPemilikCtrl,
          hint: 'Budi Santoso',
          prefixIcon: Icons.person_outline,
          onChanged: (v) {
            widget.onChange('namaPemilik', v);
            setState(() {});
          },
        ),
        const SizedBox(height: 16),

        // No. HP Outlet
        _buildLabel('No. HP Outlet'),
        _buildTextField(
          controller: _noHpCtrl,
          hint: '08xx-xxxx-xxxx',
          prefixIcon: Icons.phone_android_outlined,
          keyboardType: TextInputType.phone,
          onChanged: (v) {
            widget.onChange('noHp', v);
            setState(() {});
          },
        ),
        const SizedBox(height: 4),
        const Text(
          'Nomor ini akan dipakai untuk kirim kode OTP verifikasi.',
          style: TextStyle(fontSize: 12, color: AppColors.foreground400),
        ),
        const SizedBox(height: 24),

        // Submit Button
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: _isComplete ? widget.onNext : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary600,
              disabledBackgroundColor: AppColors.primary600.withValues(alpha: 0.4),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Lanjut ke Surat Agreement',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.foreground800,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData prefixIcon,
    int maxLines = 1,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    required ValueChanged<String> onChanged,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      onChanged: onChanged,
      style: const TextStyle(fontSize: 14, color: AppColors.foreground950),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 14, color: AppColors.foreground400),
        prefixIcon: Icon(prefixIcon, size: 20, color: AppColors.foreground400),
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
