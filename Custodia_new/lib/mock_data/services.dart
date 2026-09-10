import 'package:custodiaa/models/service_model.dart';

const List<Layanan> daftarLayanan = [
  Layanan(
    id: 'ganti-kartu',
    title: 'Ganti Kartu',
    deskripsi: 'Ganti kartu hilang, rusak, pindah eSIM, atau upgrade 5G tanpa kehilangan nomor.',
    tagline: 'Satu form untuk semua kebutuhan ganti kartu.',
    icon: 'sim_card',
    biaya: 25000,
    estimasi: '± 10 menit',
    warna: 'primary',
  ),
];

const List<String> alasanGantiKartu = [
  'Kartu Hilang',
  'Kartu Rusak',
  'Kartu Tidak Terbaca',
  'Fisik ke eSIM',
  'Upgrade ke 5G',
];

const List<String> outletList = [
  'Indosat Mall Kelapa Gading',
  'Indosat Grand Indonesia',
  'Indosat Tunjungan Plaza',
  'Indosat Paris Van Java',
];
