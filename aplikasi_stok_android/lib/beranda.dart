import 'package:flutter/material.dart';
import 'data_kelompok.dart';
import 'penjumlahan_pengurangan.dart';
import 'perkalian_pembagian.dart';
import 'ganjil_genap.dart';
import 'total_angka.dart';
import 'input_barang.dart';
import 'manajemen_stok_sqlite.dart';
import 'penanggalan_barang_masuk.dart';
import 'kalkulator_umur.dart';
import 'stopwatch_challenge.dart';
import 'session_manager.dart';
import 'main.dart';

/// Halaman Menu Utama / Dashboard Terpadu Aplikasi WarehouseSmart
/// Menampilkan seluruh menu eksisting (Menu 1-6) dan menu baru Tugas 2 (Menu 7-10)
/// Ditulis dengan struktur rapi dan ramah pemula.
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
            Icon(Icons.logout, color: Colors.red),
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
              backgroundColor: Colors.red,
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
      appBar: AppBar(
        title: const Text("Menu Utama Gudang"),
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
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
          // Banner Selamat Datang
          Card(
            color: Colors.blue.shade800,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "WarehouseSmart - Sistem Gudang & Utilitas Terintegrasi",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Halo, ${namaLengkap.isNotEmpty ? namaLengkap : username}!",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Pilih salah satu menu operasional di bawah:",
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // ==========================================================
          // BAGIAN 1: MODUL OPERASIONAL & MATEMATIKA EKSISTING (1-6)
          // ==========================================================
          _sectionHeader(
            judul: "Operasional & Matematika Dasar (Menu Eksisting)",
            warna: Colors.blue.shade900,
            ikon: Icons.warehouse,
          ),
          const SizedBox(height: 8),

          // Menu 1: Data Kelompok
          _menuItem(
            context: context,
            nomor: "1",
            judul: "Data Kelompok",
            deskripsi: "Daftar nama dan NIM anggota pengembang",
            ikon: Icons.group,
            warnaIkon: Colors.indigo,
            tujuan: const HalamanDataKelompok(),
          ),

          // Menu 2: Penjumlahan dan Pengurangan
          _menuItem(
            context: context,
            nomor: "2",
            judul: "Penjumlahan & Pengurangan Stok",
            deskripsi: "Update stok masuk (+) dan stok keluar (-)",
            ikon: Icons.add_circle_outline,
            warnaIkon: Colors.green,
            tujuan: const HalamanPenjumlahanPengurangan(),
          ),

          // Menu 3: Perkalian dan Pembagian
          _menuItem(
            context: context,
            nomor: "3",
            judul: "Perkalian & Pembagian Angka",
            deskripsi: "Hitung total box (×) & distribusi rak gudang (÷, %)",
            ikon: Icons.calculate_outlined,
            warnaIkon: Colors.orange,
            tujuan: const HalamanPerkalianPembagian(),
          ),

          // Menu 4: Ganjil / Genap
          _menuItem(
            context: context,
            nomor: "4",
            judul: "Analisis Ganjil / Genap Stok",
            deskripsi: "Cek sifat stok ganjil/genap untuk penataan display rak",
            ikon: Icons.balance,
            warnaIkon: Colors.purple,
            tujuan: const HalamanGanjilGenap(),
          ),

          // Menu 5: Total Angka dalam Field Input
          _menuItem(
            context: context,
            nomor: "5",
            judul: "Total Angka dalam Field Input",
            deskripsi: "Hitung total deret angka & total akumulasi digit",
            ikon: Icons.functions,
            warnaIkon: Colors.teal,
            tujuan: const HalamanTotalAngka(),
          ),

          // Menu 6: Input Barang Baru Cepat
          _menuItem(
            context: context,
            nomor: "6",
            judul: "Input Barang Baru (Memori)",
            deskripsi: "Daftarkan jenis barang baru ke daftar cepat",
            ikon: Icons.add_box_outlined,
            warnaIkon: Colors.red,
            tujuan: const HalamanInputBarang(),
          ),

          const SizedBox(height: 24),

          // ==========================================================
          // BAGIAN 2: MODUL BARU TUGAS 2 (MENU 7-10)
          // ==========================================================
          _sectionHeader(
            judul: "Fitur Lanjutan, Basis Data & Penanggalan (Tugas 2)",
            warna: Colors.deepPurple.shade800,
            ikon: Icons.stars,
          ),
          const SizedBox(height: 8),

          // Menu 7: Manajemen Stok Gudang SQLite (CRUD & Log)
          _menuItem(
            context: context,
            nomor: "7",
            judul: "Manajemen Stok SQLite (CRUD & Audit Log)",
            deskripsi: "Penyimpanan persisten SQLite, edit data & riwayat mutasi",
            ikon: Icons.storage,
            warnaIkon: Colors.blue.shade800,
            tujuan: const HalamanManajemenStokSQLite(),
          ),

          // Menu 8: Penanggalan Penerimaan Barang (Hijriah, Weton, Saka Bali)
          _menuItem(
            context: context,
            nomor: "8",
            judul: "Penanggalan Terima Barang Gudang",
            deskripsi: "Konversi tanggal terima ke Hijriah, Weton Jawa & Saka Bali",
            ikon: Icons.calendar_month,
            warnaIkon: Colors.teal.shade700,
            tujuan: const HalamanPenanggalanBarangMasuk(),
          ),

          // Menu 9: Kalkulator Umur & Usia Batch (Mulai Pukul 00:00:00)
          _menuItem(
            context: context,
            nomor: "9",
            judul: "Kalkulator Umur & Waktu Detil (Mulai 00:00:00)",
            deskripsi: "Input tanggal praktis, live ticker detik untuk staf & batch",
            ikon: Icons.hourglass_top,
            warnaIkon: Colors.purple.shade700,
            tujuan: const HalamanKalkulatorUmur(),
          ),

          // Menu 10: Fun Racking Challenge (Stopwatch Split-Screen Duel)
          _menuItem(
            context: context,
            nomor: "10",
            judul: "Fun Racking Challenge (Stopwatch Duel)",
            deskripsi: "Split-screen duel kecepatan menata rak 2 pekerja berbonus",
            ikon: Icons.timer,
            warnaIkon: Colors.amber.shade800,
            tujuan: const HalamanStopwatchChallenge(),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // Header Pemisah Bagian Menu
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
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: warna,
            ),
          ),
        ),
      ],
    );
  }

  // Widget bantuan untuk membuat tombol menu yang rapi, sama persis dengan kode awal
  Widget _menuItem({
    required BuildContext context,
    required String nomor,
    required String judul,
    required String deskripsi,
    required IconData ikon,
    required Color warnaIkon,
    required Widget tujuan,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: warnaIkon.withAlpha(35),
          child: Text(
            nomor,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: warnaIkon,
            ),
          ),
        ),
        title: Text(
          judul,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        subtitle: Text(
          deskripsi,
          style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
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
