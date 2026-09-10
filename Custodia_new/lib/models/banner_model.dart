class BannerModel {
  final String id;
  final String judul;
  final String deskripsi;
  final String tag;
  final String ikon;
  final String warna;
  final String teks; // "light" | "dark"

  const BannerModel({
    required this.id,
    required this.judul,
    required this.deskripsi,
    required this.tag,
    required this.ikon,
    required this.warna,
    required this.teks,
  });

  bool get isDark => teks == 'dark';
}
