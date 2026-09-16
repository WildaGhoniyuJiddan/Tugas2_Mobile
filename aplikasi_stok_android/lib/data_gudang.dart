/// File data_gudang.dart
/// Menyimpan data awal stok barang dan informasi anggota kelompok yang digunakan di aplikasi.
class DataGudang {
  // Daftar Barang Gudang Default (diselaraskan dengan database lokal aplikasi_stok)
  static List<Map<String, dynamic>> daftarBarang = [
    {"id": 1, "nama": "Beras Premium 5kg", "stok": 25, "satuan": "karung"},
    {"id": 2, "nama": "Minyak Goreng 2L", "stok": 14, "satuan": "pouch"},
    {"id": 3, "nama": "Gula Pasir Kristal 1kg", "stok": 30, "satuan": "kg"},
    {"id": 4, "nama": "Kopi Bubuk Robusta 250g", "stok": 17, "satuan": "pack"},
    {"id": 5, "nama": "Tepung Terigu Serbaguna 1kg", "stok": 8, "satuan": "kg"},
    {"id": 6, "nama": "Indomie", "stok": 90, "satuan": "pcs"},
  ];

  // Daftar Akun Pengguna Bawaan (diselaraskan dengan aplikasi_stok)
  static final List<Map<String, String>> daftarPengguna = [
    {"username": "admin", "password": "admin123", "nama": "Administrator Gudang", "role": "Super Admin"},
    {"username": "user", "password": "user123", "nama": "Staff Operator Gudang", "role": "Staff Gudang"},
    {"username": "wilda", "password": "password123", "nama": "Wilda Ghoniyu Jiddan", "role": "Lead Warehouse Officer"},
  ];

  // Daftar Anggota Kelompok Pengembang (Sesuai Kriteria Tugas 2)
  static final List<Map<String, String>> daftarAnggota = [
    {"nama": "Wilda Ghoniyu Jiddan", "nim": "124240085", "peran": "Lead Developer & Database Architect"},
    {"nama": "Rafid Ihsan Naufal", "nim": "124240095", "peran": "UI/UX & Cultural Date Specialist"},
    {"nama": "Bagus Fajjar Pambudi", "nim": "124240108", "peran": "Theme & Dual-Mode Age Specialist"},
    {"nama": "Achmad Maulana", "nim": "124240112", "peran": "Session, Stopwatch & Documentation Lead"},
  ];
}
