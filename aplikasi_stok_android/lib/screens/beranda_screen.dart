import 'package:flutter/material.dart';
import '../database/session_manager.dart';
import '../styles/app_colors.dart';
import '../styles/app_styles.dart';
import '../styles/app_text_styles.dart';
import 'auth/login_screen.dart';

// Import layar modul operasional & matematika eksisting
import 'data_kelompok_screen.dart';
import 'penjumlahan_pengurangan_screen.dart';
import 'perkalian_pembagian_screen.dart';
import 'ganjil_genap_screen.dart';
import 'total_angka_screen.dart';
import 'input_barang_screen.dart';

// Import layar modul baru Tugas 2
import 'manajemen_stok_sqlite_screen.dart';
import 'penanggalan_barang_masuk_screen.dart';
import 'kalkulator_umur_screen.dart';
import 'stopwatch_challenge_screen.dart';

/// Halaman Menu Utama / Dashboard Terpadu Aplikasi WarehouseSmart
/// Menggunakan tema warna Lavender (AppColors.primary) dan styling terpisah (AppStyles).
class HalamanBeranda extends StatelessWidget {
  final String username;
  final String namaLengkap;

  const HalamanBeranda({
    super.key,
    required this.username,
    this.namaLengkap = "",
  });

  /// Dialog konfirmasi logout dari AppBar
  void _dialogLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.logout, color: AppColors.danger),
            SizedBox(width: 8),
            Text("Konfirmasi Logout"),
          ],
        ),
        content: const Text(
          "Apakah Anda yakin ingin mengakhiri sesi dan keluar dari aplikasi?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.danger,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              Navigator.pop(ctx);
              await SessionManager.hapusSesi();
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const HalamanLogin()),
                  (route) => false,
                );
              }
            },
            child: const Text("Ya, Logout"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Beranda", style: AppTextStyles.appBarTitle),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textDark,
        elevation: 0,
        actions: [
          IconButton(
            tooltip: "Logout",
            icon: const Icon(Icons.logout),
            onPressed: () => _dialogLogout(context),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Sambutan singkat sebagai identitas halaman utama.
          Container(
            decoration: AppStyles.bannerDecoration,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.warehouse_rounded, color: Colors.white, size: 20),
                    SizedBox(width: 6),
                    Text(
                      "WAREHOUSESMART",
                      style: AppTextStyles.bannerSubtitle,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  "Halo, ${namaLengkap.isNotEmpty ? namaLengkap : username}!",
                  style: AppTextStyles.bannerTitle,
                ),
                const SizedBox(height: 4),
                const Text(
                  "Pilih fitur yang ingin digunakan.",
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          _sectionHeader(
            judul: "Operasional",
            warna: AppColors.primaryDark,
            ikon: Icons.warehouse,
          ),
          const SizedBox(height: 10),

          _menuItem(
            context: context,
            judul: "Data Kelompok",
            deskripsi: "Daftar nama dan NIM anggota tim pengembang",
            ikon: Icons.group_outlined,
            warnaIkon: AppColors.primary,
            tujuan: const HalamanDataKelompok(),
          ),

          _menuItem(
            context: context,
            judul: "Penjumlahan & Pengurangan Stok",
            deskripsi: "Update stok masuk (+) dan stok keluar (-)",
            ikon: Icons.add_circle_outline,
            warnaIkon: AppColors.success,
            tujuan: const HalamanPenjumlahanPengurangan(),
          ),

          _menuItem(
            context: context,
            judul: "Perkalian & Pembagian Angka",
            deskripsi: "Hitung total box (×) & distribusi rak gudang (÷, %)",
            ikon: Icons.calculate_outlined,
            warnaIkon: AppColors.secondary,
            tujuan: const HalamanPerkalianPembagian(),
          ),

          _menuItem(
            context: context,
            judul: "Analisis Ganjil / Genap Stok",
            deskripsi: "Cek sifat stok ganjil/genap untuk penataan rak",
            ikon: Icons.balance,
            warnaIkon: AppColors.primaryDark,
            tujuan: const HalamanGanjilGenap(),
          ),

          _menuItem(
            context: context,
            judul: "Total Angka dalam Field Input",
            deskripsi: "Hitung total deret angka & akumulasi digit karakter",
            ikon: Icons.functions,
            warnaIkon: AppColors.accent,
            tujuan: const HalamanTotalAngka(),
          ),

          _menuItem(
            context: context,
            judul: "Input Barang Baru (Memori Cepat)",
            deskripsi: "Daftarkan jenis barang baru ke daftar cepat",
            ikon: Icons.add_box_outlined,
            warnaIkon: AppColors.danger,
            tujuan: const HalamanInputBarang(),
          ),

          const SizedBox(height: 24),

          _sectionHeader(
            judul: "Fitur lanjutan",
            warna: AppColors.primaryDark,
            ikon: Icons.stars,
          ),
          const SizedBox(height: 10),

          _menuItem(
            context: context,
            judul: "Manajemen Stok SQLite (CRUD & Audit Log)",
            deskripsi: "Penyimpanan persisten SQLite, edit data & riwayat mutasi",
            ikon: Icons.storage_rounded,
            warnaIkon: AppColors.primary,
            tujuan: const HalamanManajemenStokSQLite(),
          ),

          _menuItem(
            context: context,
            judul: "Penanggalan Terima Barang Gudang",
            deskripsi: "Konversi tanggal terima ke Hijriah, Weton Jawa & Saka Bali",
            ikon: Icons.calendar_month_outlined,
            warnaIkon: AppColors.accent,
            tujuan: const HalamanPenanggalanBarangMasuk(),
          ),

          _menuItem(
            context: context,
            judul: "Kalkulator Umur & Usia Batch (00:00:00)",
            deskripsi: "Input tanggal praktis, live ticker detik untuk staf & barang",
            ikon: Icons.hourglass_top_outlined,
            warnaIkon: AppColors.primaryDark,
            tujuan: const HalamanKalkulatorUmur(),
          ),

          _menuItem(
            context: context,
            judul: "Stopwatch Susun Rak (Split Challenge)",
            deskripsi: "2 stopwatch split layar untuk kompetisi kecepatan pekerja gudang",
            ikon: Icons.timer_outlined,
            warnaIkon: AppColors.secondary,
            tujuan: const HalamanStopwatchChallenge(),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  /// Header Pemisah Bagian Menu
  Widget _sectionHeader({
    required String judul,
    required Color warna,
    required IconData ikon,
  }) {
    return Row(
      children: [
        Icon(ikon, color: warna, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            judul,
            style: AppTextStyles.sectionTitle.copyWith(color: warna),
          ),
        ),
      ],
    );
  }

  /// Kartu menu ringkas dengan ikon sebagai penanda visual.
  Widget _menuItem({
    required BuildContext context,
    required String judul,
    required String deskripsi,
    required IconData ikon,
    required Color warnaIkon,
    required Widget tujuan,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: AppStyles.cardBoxDecoration(),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: CircleAvatar(
          backgroundColor: warnaIkon.withAlpha(30),
          child: Icon(ikon, color: warnaIkon, size: 21),
        ),
        title: Text(judul, style: AppTextStyles.cardTitle),
        subtitle: Text(deskripsi, style: AppTextStyles.cardSubtitle),
        trailing: const Icon(Icons.chevron_right, color: AppColors.textMuted),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => tujuan),
          );
        },
      ),
    );
  }
}
