class NotifikasiModel {
  final String id;
  final String judul;
  final String deskripsi;
  final String waktu;
  final String tanggal;
  final String icon;
  final String warna; // "primary" | "accent" | "secondary" | "cyan"
  bool dibaca;

  NotifikasiModel({
    required this.id,
    required this.judul,
    required this.deskripsi,
    required this.waktu,
    required this.tanggal,
    required this.icon,
    required this.warna,
    required this.dibaca,
  });

  NotifikasiModel copyWith({bool? dibaca}) {
    return NotifikasiModel(
      id: id,
      judul: judul,
      deskripsi: deskripsi,
      waktu: waktu,
      tanggal: tanggal,
      icon: icon,
      warna: warna,
      dibaca: dibaca ?? this.dibaca,
    );
  }
}
