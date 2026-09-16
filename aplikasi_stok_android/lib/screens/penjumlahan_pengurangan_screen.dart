import 'package:flutter/material.dart';
import '../data_gudang.dart';
import '../logic/operasional_stok_logic.dart';
import '../styles/app_colors.dart';
import '../styles/app_styles.dart';
import '../styles/app_text_styles.dart';

/// Halaman Penjumlahan dan Pengurangan Angka (Kriteria 3)
/// Menggunakan OperasionalStokLogic untuk komputasi, serta AppStyles/AppColors untuk desain visual.
class HalamanPenjumlahanPengurangan extends StatefulWidget {
  const HalamanPenjumlahanPengurangan({super.key});

  @override
  State<HalamanPenjumlahanPengurangan> createState() =>
      _HalamanPenjumlahanPenguranganState();
}

class _HalamanPenjumlahanPenguranganState
    extends State<HalamanPenjumlahanPengurangan> {
  final TextEditingController _jumlahController = TextEditingController();

  int? _idDipilih;
  String? _catatanPerhitungan;

  void _tambahStok() {
    final jumlah = int.tryParse(_jumlahController.text.trim());

    if (_idDipilih == null) {
      _tampilkanPesan("Silakan pilih barang terlebih dahulu!");
      return;
    }
    if (jumlah == null || jumlah <= 0) {
      _tampilkanPesan("Masukkan angka jumlah yang valid (lebih dari 0)!");
      return;
    }

    final barang = DataGudang.daftarBarang
        .firstWhere((item) => item["id"] == _idDipilih);
    final stokLama = barang["stok"] as int;

    // Menghitung penjumlahan melalui OperasionalStokLogic
    final hasil = OperasionalStokLogic.hitungTambahStok(
      stokLama: stokLama,
      jumlah: jumlah,
      namaBarang: barang["nama"],
      satuan: barang["satuan"],
    );

    setState(() {
      barang["stok"] = hasil["stokBaru"];
      _catatanPerhitungan = hasil["rincian"];
      _tampilkanPesan(hasil["pesan"]);
      _jumlahController.clear();
    });
  }

  void _kurangStok() {
    final jumlah = int.tryParse(_jumlahController.text.trim());

    if (_idDipilih == null) {
      _tampilkanPesan("Silakan pilih barang terlebih dahulu!");
      return;
    }
    if (jumlah == null || jumlah <= 0) {
      _tampilkanPesan("Masukkan angka jumlah yang valid (lebih dari 0)!");
      return;
    }

    final barang = DataGudang.daftarBarang
        .firstWhere((item) => item["id"] == _idDipilih);
    final stokLama = barang["stok"] as int;

    // Menghitung pengurangan melalui OperasionalStokLogic
    final hasil = OperasionalStokLogic.hitungKurangStok(
      stokLama: stokLama,
      jumlah: jumlah,
      namaBarang: barang["nama"],
      satuan: barang["satuan"],
    );

    if (!hasil["sukses"]) {
      _tampilkanPesan(hasil["pesan"]);
      return;
    }

    setState(() {
      barang["stok"] = hasil["stokBaru"];
      _catatanPerhitungan = hasil["rincian"];
      _tampilkanPesan(hasil["pesan"]);
      _jumlahController.clear();
    });
  }

  void _tampilkanPesan(String pesan) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(pesan), duration: const Duration(seconds: 3)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Penjumlahan & Pengurangan Stok", style: AppTextStyles.appBarTitle),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "1. Pilih Barang Gudang:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primaryDark),
            ),
            const SizedBox(height: 8),

            // Daftar Barang
            ...DataGudang.daftarBarang.map((barang) {
              final isDipilih = _idDipilih == barang["id"];
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: isDipilih ? AppColors.primaryLight : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isDipilih ? AppColors.primary : AppColors.border,
                    width: isDipilih ? 2 : 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(5),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ListTile(
                  title: Text(barang["nama"],
                      style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textDark)),
                  trailing: Text(
                    "Stok: ${barang["stok"]} ${barang["satuan"]}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isDipilih ? AppColors.primaryDark : AppColors.textDark,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      _idDipilih = barang["id"];
                    });
                  },
                ),
              );
            }),

            const SizedBox(height: 18),
            const Text(
              "2. Masukkan Jumlah Angka Operasi:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primaryDark),
            ),
            const SizedBox(height: 8),

            // Input Angka
            TextField(
              controller: _jumlahController,
              keyboardType: TextInputType.number,
              decoration: AppStyles.inputDecoration(
                labelText: "Jumlah (Angka)",
                hintText: "Contoh: 5",
                prefixIcon: Icons.calculate_outlined,
              ),
            ),

            const SizedBox(height: 16),

            // Tombol Operasi Penjumlahan dan Pengurangan
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: AppStyles.successButton,
                    onPressed: _tambahStok,
                    icon: const Icon(Icons.add),
                    label: const Text("Tambah (+)"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    style: AppStyles.warningButton,
                    onPressed: _kurangStok,
                    icon: const Icon(Icons.remove),
                    label: const Text("Kurang (-)"),
                  ),
                ),
              ],
            ),

            if (_catatanPerhitungan != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.lavenderAccent),
                ),
                child: Text(
                  _catatanPerhitungan!,
                  style: const TextStyle(fontWeight: FontWeight.w600, height: 1.4, color: AppColors.primaryDark),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
