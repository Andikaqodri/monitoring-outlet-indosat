enum Kategori { pemain, reaktif, pasif }

extension KategoriExtension on Kategori {
  String get label {
    switch (this) {
      case Kategori.pemain:
        return 'Pemain';
      case Kategori.reaktif:
        return 'Reaktif';
      case Kategori.pasif:
        return 'Pasif';
    }
  }
}

class Outlet {
  final String id;
  final String nama;
  final String bsm;
  final String kota;
  final Kategori kategori;
  final int stokAwal;
  final int stokIccid;
  final int transaksi;
  final int loginCount;
  final int rewardClaimed;
  final String lastActivity;
  final double x;
  final double y;

  const Outlet({
    required this.id,
    required this.nama,
    required this.bsm,
    required this.kota,
    required this.kategori,
    required this.stokAwal,
    required this.stokIccid,
    required this.transaksi,
    required this.loginCount,
    required this.rewardClaimed,
    required this.lastActivity,
    required this.x,
    required this.y,
  });
}
