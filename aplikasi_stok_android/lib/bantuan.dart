import 'package:flutter/material.dart';

/// Halaman Pusat Bantuan & Dokumentasi (Tab 2 Bottom Navigation Bar)
/// Memuat petunjuk lengkap pengoperasian seluruh menu dan FAQ aplikasi
class HalamanBantuan extends StatelessWidget {
  const HalamanBantuan({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pusat Bantuan & Panduan"),
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Banner Panduan
          Card(
            color: Colors.blue.shade50,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.blue.shade200),
            ),
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.help_outline, color: Colors.blue, size: 40),
                  SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Panduan Penggunaan WarehouseSmart",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.blue,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Pelajari seluruh fitur sistem stok, operasi matematika, dan utilitas penanggalan.",
                          style: TextStyle(fontSize: 12, color: Colors.black87),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),
          const Text(
            "Daftar Topik Bantuan:",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),

          // 1. Akun Login & Sesi
          _buildItemBantuan(
            ikon: Icons.lock_outline,
            warna: Colors.indigo,
            judul: "1. Autentikasi Akun & Manajemen Sesi",
            isi: "• Akun demo bawaan:\n"
                "  - Username: 'admin' | Password: 'admin123'\n"
                "  - Username: 'user'  | Password: 'user123'\n"
                "  - Username: 'wilda' | Password: 'password123'\n"
                "• Sesi disimpan otomatis di SharedPreferences (Auto-Login aktif).\n"
                "• Tombol Logout di tab navigasi bawah akan membersihkan sesi dan kembali ke halaman login.",
          ),

          // 2. Modul Eksisting (Menu 1-6)
          _buildItemBantuan(
            ikon: Icons.calculate_outlined,
            warna: Colors.green,
            judul: "2. Operasi Dasar & Modul Eksisting (Menu 1-6)",
            isi: "• Menu 1 (Data Kelompok): Menampilkan profil 4 mahasiswa pembuat aplikasi.\n"
                "• Menu 2 (Penjumlahan & Pengurangan): Memilih barang dan mengubah stok masuk (+) atau keluar (-).\n"
                "• Menu 3 (Perkalian & Pembagian): Menghitung total boks (×) dan pembagian ke rak gudang beserta sisa modulo (%).\n"
                "• Menu 4 (Ganjil / Genap): Mendeteksi sifat angka stok untuk penataan display simetris.\n"
                "• Menu 5 (Total Angka): Memasukkan banyak angka dalam satu field (dipisah koma/spasi), menghitung total, rata-rata, min, maks, dan total akumulasi digit.\n"
                "• Menu 6 (Input Barang Cepat): Mendaftarkan jenis barang baru ke memori.",
          ),

          // 3. Modul SQLite (Menu 7)
          _buildItemBantuan(
            ikon: Icons.storage_outlined,
            warna: Colors.blue,
            judul: "3. Manajemen Stok SQLite Lengkap (Menu 7)",
            isi: "• Data tersimpan permanen di file SQLite lokal ('warehouse_smart.db').\n"
                "• Tambah barang baru lewat tombol floating '+ Tambah Barang'.\n"
                "• Tombol (+) Hijau: Tambah stok masuk & catat keterangan.\n"
                "• Tombol (-) Oranye: Kurang stok keluar & catat keterangan.\n"
                "• Tombol Edit & Hapus tersedia pada masing-masing kartu barang.\n"
                "• Tab 'Riwayat Log' menampilkan seluruh audit mutasi stok secara kronologis.",
          ),

          // 4. Penanggalan Penerimaan Barang (Menu 8)
          _buildItemBantuan(
            ikon: Icons.calendar_month_outlined,
            warna: Colors.teal,
            judul: "4. Penanggalan Terima Barang (Menu 8)",
            isi: "• Konsep: Saat barang masuk tiba di gudang, petugas mencatat tanggal kedatangan.\n"
                "• Konversi Kalender Hijriah: Mengetahui hari Islam & momentum komoditas halal.\n"
                "• Konversi Kalender Weton Jawa: Menghitung Pasaran (Legi, Pahing, Pon, Wage, Kliwon) dan nilai Neptu untuk jadwal pasar tradisional.\n"
                "• Konversi Kalender Saka Bali: Mengetahui Tahun Saka, Wuku (siklus 30 wuku), dan Sasih untuk persiapan libur adat/Nyepi di Bali.\n"
                "• Bukti penerimaan dapat disimpan permanen ke database SQLite.",
          ),

          // 5. Kalkulator Umur & Shelf-Life (Menu 9)
          _buildItemBantuan(
            ikon: Icons.hourglass_top_outlined,
            warna: Colors.purple,
            judul: "5. Kalkulator Umur & Waktu Detil (Menu 9)",
            isi: "• Pengguna hanya perlu memilih TANGGAL (tanpa perlu input jam & menit).\n"
                "• Perhitungan otomatis dimulai tepat pada pukul 00:00:00 di tanggal yang dipilih.\n"
                "• Live Ticker Detik: Angka detik berdetak setiap 1 detik secara realtime.\n"
                "• Mode Profil Staf: Menghitung umur lengkap (Tahun, Bulan, Hari, Jam, Menit, Detik) + Countdown Ulang Tahun.\n"
                "• Mode Batch Barang: Menghitung durasi penyimpanan produk di gudang untuk kontrol FIFO dan audit mutu.",
          ),

          // 6. Fun Racking Challenge (Menu 10 / Tab Stopwatch)
          _buildItemBantuan(
            ikon: Icons.timer_outlined,
            warna: Colors.amber.shade800,
            judul: "6. Fun Racking Challenge / Stopwatch Duel",
            isi: "• Fitur gamifikasi lomba kecepatan menata rak gudang antar 2 pekerja berhadiah bonus.\n"
                "• Tampilan Split-Screen: Layar atas (Pekerja 1) dan layar bawah (Pekerja 2).\n"
                "• Tombol 'MULAI DUEL BERSAMA': Menghitung mundur (3.. 2.. 1.. GO!) untuk memulai stopwatch serentak secara adil.\n"
                "• Tombol 'Catat Rak': Mencatat waktu per baris rak.\n"
                "• Pemenang & bonus dihitung otomatis berdasarkan selisih waktu penyelesaian.\n"
                "• Toggle tombol di pojok kanan atas untuk beralih ke Single Mode.",
          ),

          const SizedBox(height: 16),
          const Text(
            "FAQ (Pertanyaan Umum):",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),

          _buildFAQItem(
            tanya: "Apakah data stok SQLite hilang jika aplikasi ditutup?",
            jawab: "Tidak. Data disimpan secara persisten di penyimpanan lokal perangkat menggunakan SQLite (sqflite).",
          ),
          _buildFAQItem(
            tanya: "Bagaimana cara kerja auto-login?",
            jawab: "Saat Anda berhasil login, status dan username disimpan ke SharedPreferences. Saat aplikasi dibuka kembali, sistem otomatis mengarahkan ke Menu Utama tanpa meminta login ulang.",
          ),
          _buildFAQItem(
            tanya: "Apakah aplikasi membutuhkan koneksi internet?",
            jawab: "Tidak. Seluruh fungsionalitas (CRUD SQLite, kalender Hijriah, Weton, Saka Bali, stopwatch, kalkulator umur) 100% offline.",
          ),
        ],
      ),
    );
  }

  Widget _buildItemBantuan({
    required IconData ikon,
    required Color warna,
    required String judul,
    required String isi,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: warna.withAlpha(30),
          child: Icon(ikon, color: warna),
        ),
        title: Text(
          judul,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                isi,
                style: TextStyle(fontSize: 13, height: 1.4, color: Colors.grey.shade800),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQItem({required String tanya, required String jawab}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Q: $tanya",
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            const SizedBox(height: 4),
            Text(
              "A: $jawab",
              style: TextStyle(color: Colors.grey.shade800, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
