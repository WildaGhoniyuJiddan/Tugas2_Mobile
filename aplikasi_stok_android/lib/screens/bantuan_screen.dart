import 'package:flutter/material.dart';
import '../styles/app_colors.dart';
import '../styles/app_styles.dart';
import '../styles/app_text_styles.dart';

/// Halaman Pusat Bantuan & Dokumentasi (Tab 3 Bottom Navigation Bar)
/// Memuat petunjuk lengkap pengoperasian seluruh modul dan FAQ aplikasi.
/// Menggunakan styling terpusat AppStyles & AppColors (Tema Lavender).
class HalamanBantuan extends StatelessWidget {
  const HalamanBantuan({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Pusat Bantuan & Panduan", style: AppTextStyles.appBarTitle),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textDark,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Banner Panduan Lavender
          Container(
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.lavenderAccent),
            ),
            padding: const EdgeInsets.all(16),
            child: const Row(
              children: [
                Icon(Icons.help_outline, color: AppColors.primary, size: 40),
                SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Panduan Penggunaan Stok Hebat",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppColors.primaryDark,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Pelajari seluruh fitur sistem stok, operasi matematika, dan utilitas penanggalan.",
                        style: TextStyle(fontSize: 12, color: AppColors.textDark),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),
          const Text(
            "Daftar Topik Bantuan:",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primaryDark),
          ),
          const SizedBox(height: 8),

          // 1. Akun Login & Sesi
          _buildItemBantuan(
            ikon: Icons.lock_outline,
            warna: AppColors.primary,
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
            warna: AppColors.success,
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
            warna: AppColors.primaryDark,
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
            warna: AppColors.accent,
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
            warna: AppColors.primary,
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
            warna: AppColors.secondary,
            judul: "6. Fun Racking Challenge / Stopwatch Duel (Menu 10)",
            isi: "• Fitur gamifikasi lomba kecepatan menata rak gudang antar 2 pekerja berhadiah bonus.\n"
                "• Tampilan Split-Screen: Layar atas (Pekerja 1) dan layar bawah (Pekerja 2).\n"
                "• Tombol 'MULAI DUEL BERSAMA': Menghitung mundur (3.. 2.. 1.. GO!) untuk memulai stopwatch serentak secara adil.\n"
                "• Tombol 'Catat Rak': Mencatat waktu per baris rak.\n"
                "• Pemenang & bonus dihitung otomatis berdasarkan selisih waktu penyelesaian.\n"
                "• Toggle tombol di pojok kanan atas untuk beralih ke Single Mode.",
          ),

          const SizedBox(height: 18),
          const Text(
            "FAQ (Pertanyaan Umum):",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primaryDark),
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
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: AppStyles.cardBoxDecoration(),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: warna.withAlpha(25),
          child: Icon(ikon, color: warna),
        ),
        title: Text(
          judul,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textDark),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                isi,
                style: const TextStyle(fontSize: 13, height: 1.4, color: AppColors.textDark),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQItem({required String tanya, required String jawab}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: AppStyles.cardBoxDecoration(),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Q: $tanya",
              style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
            ),
            const SizedBox(height: 4),
            Text(
              "A: $jawab",
              style: const TextStyle(color: AppColors.textDark, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
