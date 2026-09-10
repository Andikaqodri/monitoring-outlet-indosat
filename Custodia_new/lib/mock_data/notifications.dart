import 'package:custodiaa/models/notification_model.dart';

final List<NotifikasiModel> daftarNotifikasi = [
  NotifikasiModel(id: 'ntf-001', judul: '5 transaksi menunggu verifikasi', deskripsi: 'Ada 5 pengajuan pergantian kartu yang perlu kamu verifikasi hari ini.', waktu: '2 menit lalu', tanggal: '19 Agu 2026', icon: 'time', warna: 'secondary', dibaca: false),
  NotifikasiModel(id: 'ntf-002', judul: 'Target harian tercapai 94%', deskripsi: 'Tinggal 7 transaksi lagi untuk mencapai target 128 hari ini.', waktu: '1 jam lalu', tanggal: '19 Agu 2026', icon: 'trophy', warna: 'primary', dibaca: false),
  NotifikasiModel(id: 'ntf-003', judul: 'Transaksi TRX-260819-002 berhasil', deskripsi: 'Pergantian kartu untuk Siti Rahayu telah selesai diproses.', waktu: '1 jam lalu', tanggal: '19 Agu 2026', icon: 'verified', warna: 'cyan', dibaca: false),
  NotifikasiModel(id: 'ntf-004', judul: 'Transaksi TRX-260819-005 ditolak', deskripsi: 'Upgrade kartu untuk Rizky Pratama gagal — dokumen tidak valid.', waktu: '2 jam lalu', tanggal: '19 Agu 2026', icon: 'close_circle', warna: 'accent', dibaca: false),
  NotifikasiModel(id: 'ntf-005', judul: 'Stok kartu fisik menipis', deskripsi: 'Sisa stok kartu 4G di outlet Kelapa Gading tinggal 12 unit.', waktu: '3 jam lalu', tanggal: '19 Agu 2026', icon: 'stack', warna: 'secondary', dibaca: false),
  NotifikasiModel(id: 'ntf-006', judul: 'Pembaruan sistem selesai', deskripsi: 'Aplikasi Kartu Service telah diperbarui ke versi 2.4.1.', waktu: 'Kemarin', tanggal: '18 Agu 2026', icon: 'check_double', warna: 'primary', dibaca: true),
  NotifikasiModel(id: 'ntf-007', judul: 'Laporan mingguan tersedia', deskripsi: 'Rekap transaksi minggu lalu sudah bisa diunduh.', waktu: 'Kemarin', tanggal: '18 Agu 2026', icon: 'file_chart', warna: 'cyan', dibaca: true),
  NotifikasiModel(id: 'ntf-008', judul: 'Transaksi TRX-260818-012 diverifikasi', deskripsi: 'Pengajuan Fitri Handayani telah lolos verifikasi.', waktu: 'Kemarin', tanggal: '18 Agu 2026', icon: 'shield_check', warna: 'cyan', dibaca: true),
  NotifikasiModel(id: 'ntf-009', judul: 'Pengingat pelatihan staff baru', deskripsi: 'Sesi pelatihan layanan 5G dijadwalkan besok pukul 10.00.', waktu: '2 hari lalu', tanggal: '17 Agu 2026', icon: 'calendar_event', warna: 'accent', dibaca: true),
];
