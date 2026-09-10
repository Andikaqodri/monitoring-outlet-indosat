import 'package:custodiaa/models/transaction_model.dart';

const List<StatistikItem> statistikDashboard = [
  StatistikItem(label: 'Transaksi Hari Ini', nilai: 128, icon: 'bar_chart', delta: '+12%'),
  StatistikItem(label: 'Berhasil Diproses', nilai: 121, icon: 'verified', delta: '+8%'),
  StatistikItem(label: 'Menunggu Verifikasi', nilai: 5, icon: 'file_list', delta: '-3%'),
  StatistikItem(label: 'Gagal / Ditolak', nilai: 2, icon: 'close_circle', delta: '-1%'),
];

const List<StatistikMingguan> statistikMingguan = [
  StatistikMingguan(hari: 'Sen', transaksi: 42),
  StatistikMingguan(hari: 'Sel', transaksi: 55),
  StatistikMingguan(hari: 'Rab', transaksi: 38),
  StatistikMingguan(hari: 'Kam', transaksi: 61),
  StatistikMingguan(hari: 'Jum', transaksi: 49),
  StatistikMingguan(hari: 'Sab', transaksi: 70),
  StatistikMingguan(hari: 'Min', transaksi: 45),
];

const List<Transaksi> daftarTransaksi = [
  Transaksi(id: 'TRX-260819-001', nama: 'Budi Santoso', nomor: '0857-1234-5678', layanan: 'Pergantian Kartu', status: 'Sukses', waktu: '09:24', tanggal: '19 Agu 2026', outlet: 'Indosat Mall Kelapa Gading'),
  Transaksi(id: 'TRX-260819-002', nama: 'Siti Rahayu', nomor: '0813-9876-5432', layanan: 'Upgrade Kartu', status: 'Sukses', waktu: '09:51', tanggal: '19 Agu 2026', outlet: 'Indosat Mall Kelapa Gading'),
  Transaksi(id: 'TRX-260819-003', nama: 'Andi Wijaya', nomor: '0821-5555-7777', layanan: 'Ganti Kartu', status: 'Pending', waktu: '10:12', tanggal: '19 Agu 2026', outlet: 'Indosat Mall Kelapa Gading'),
  Transaksi(id: 'TRX-260819-004', nama: 'Dewi Lestari', nomor: '0856-2345-6789', layanan: 'Pergantian Kartu', status: 'Sukses', waktu: '10:38', tanggal: '19 Agu 2026', outlet: 'Indosat Mall Kelapa Gading'),
  Transaksi(id: 'TRX-260819-005', nama: 'Rizky Pratama', nomor: '0819-1111-2222', layanan: 'Upgrade Kartu', status: 'Gagal', waktu: '11:05', tanggal: '19 Agu 2026', outlet: 'Indosat Mall Kelapa Gading'),
  Transaksi(id: 'TRX-260818-014', nama: 'Maya Anggraini', nomor: '0852-3333-4444', layanan: 'Ganti Kartu', status: 'Sukses', waktu: '16:42', tanggal: '18 Agu 2026', outlet: 'Indosat Grand Indonesia'),
  Transaksi(id: 'TRX-260818-013', nama: 'Hendra Gunawan', nomor: '0812-8888-9999', layanan: 'Pergantian Kartu', status: 'Sukses', waktu: '15:18', tanggal: '18 Agu 2026', outlet: 'Indosat Grand Indonesia'),
  Transaksi(id: 'TRX-260818-012', nama: 'Fitri Handayani', nomor: '0838-6666-7777', layanan: 'Upgrade Kartu', status: 'Pending', waktu: '14:03', tanggal: '18 Agu 2026', outlet: 'Indosat Grand Indonesia'),
];
