class OutletData {
  int? idOutlet;
  String namaOutlet;
  String wilayah;
  String cluster;
  String tipeOutlet;
  String alamat;
  String namaPemilik;
  String noHp;

  OutletData({
    this.idOutlet,
    this.namaOutlet = '',
    this.wilayah = '',
    this.cluster = '',
    this.tipeOutlet = '',
    this.alamat = '',
    this.namaPemilik = '',
    this.noHp = '',
  });

  String get clusterDisplay =>
      cluster.isNotEmpty ? cluster : (wilayah.isNotEmpty ? wilayah : '');

  OutletData copyWith({
    int? idOutlet,
    String? namaOutlet,
    String? wilayah,
    String? cluster,
    String? tipeOutlet,
    String? alamat,
    String? namaPemilik,
    String? noHp,
  }) {
    return OutletData(
      idOutlet: idOutlet ?? this.idOutlet,
      namaOutlet: namaOutlet ?? this.namaOutlet,
      wilayah: wilayah ?? this.wilayah,
      cluster: cluster ?? this.cluster,
      tipeOutlet: tipeOutlet ?? this.tipeOutlet,
      alamat: alamat ?? this.alamat,
      namaPemilik: namaPemilik ?? this.namaPemilik,
      noHp: noHp ?? this.noHp,
    );
  }

  bool get isComplete =>
      (idOutlet != null && idOutlet! > 0) &&
      namaOutlet.trim().isNotEmpty &&
      (wilayah.trim().isNotEmpty || cluster.trim().isNotEmpty) &&
      alamat.trim().isNotEmpty &&
      namaPemilik.trim().isNotEmpty &&
      noHp.trim().isNotEmpty;
}

const List<String> daftarWilayah = [
  'Jakarta Pusat',
  'Jakarta Utara',
  'Jakarta Barat',
  'Jakarta Selatan',
  'Jakarta Timur',
  'Bogor',
  'Depok',
  'Tangerang',
  'Tangerang Selatan',
  'Bekasi',
  'Bandung',
  'Surabaya',
  'Semarang',
  'Yogyakarta',
  'Medan',
];
