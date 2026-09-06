/// File data_gudang.dart
/// Menyimpan data stok barang dan anggota kelompok yang digunakan oleh semua halaman aplikasi.
class DataGudang {
  // Daftar Barang Gudang (dapat ditambah atau dikurangi stoknya)
  static List<Map<String, dynamic>> daftarBarang = [
    {"id": 1, "nama": "Beras Premium 5kg", "stok": 25, "satuan": "karung"},
    {"id": 2, "nama": "Minyak Goreng 2L", "stok": 14, "satuan": "pouch"},
    {"id": 3, "nama": "Gula Pasir Kristal 1kg", "stok": 30, "satuan": "kg"},
    {"id": 4, "nama": "Kopi Bubuk Robusta 250g", "stok": 17, "satuan": "pack"},
    {"id": 5, "nama": "Tepung Terigu 1kg", "stok": 8, "satuan": "kg"},
  ];

  // Daftar Anggota Kelompok Pengembang
  static final List<Map<String, String>> daftarAnggota = [
    {"nama": "Wilda Ghoniyu Jiddan", "nim": "124240085"},
    {"nama": "Rafid Ihsan Naufal", "nim": "124240095"},
    {"nama": "Bagus Fajjar Pambudi", "nim": "124240108"},
    {"nama": "Achmad Maulana", "nim": "124240112"},
  ];
}
