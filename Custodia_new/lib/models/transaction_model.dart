class Transaksi {
  final String id;
  final String nama;
  final String nomor;
  final String layanan;
  final String status; // "Sukses" | "Pending" | "Gagal"
  final String waktu;
  final String tanggal;
  final String outlet;

  const Transaksi({
    required this.id,
    required this.nama,
    required this.nomor,
    required this.layanan,
    required this.status,
    required this.waktu,
    required this.tanggal,
    required this.outlet,
  });
}

class StatistikItem {
  final String label;
  final int nilai;
  final String icon;
  final String delta;

  const StatistikItem({
    required this.label,
    required this.nilai,
    required this.icon,
    required this.delta,
  });
}

class StatistikMingguan {
  final String hari;
  final int transaksi;

  const StatistikMingguan({
    required this.hari,
    required this.transaksi,
  });
}
