import 'package:flutter/material.dart';
import '../logic/operasional_stok_logic.dart';
import '../styles/app_colors.dart';
import '../styles/app_styles.dart';
import '../styles/app_text_styles.dart';

/// Halaman Jumlah Total Angka dalam Suatu Field Input Data (Kriteria 6)
/// Menggunakan OperasionalStokLogic untuk ekstraksi deret dan kalkulasi statistik,
/// serta AppStyles/AppColors untuk desain visual (Lavender).
class HalamanTotalAngka extends StatefulWidget {
  const HalamanTotalAngka({super.key});

  @override
  State<HalamanTotalAngka> createState() => _HalamanTotalAngkaState();
}

class _HalamanTotalAngkaState extends State<HalamanTotalAngka> {
  final TextEditingController _inputController = TextEditingController();

  Map<String, dynamic>? _hasilStatistik;

  void _hitung() {
    final teks = _inputController.text.trim();

    if (teks.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Field input angka tidak boleh kosong!"),
          backgroundColor: AppColors.danger,
        ),
      );
      return;
    }

    final hasil = OperasionalStokLogic.hitungTotalDanStatistik(teks);

    if (hasil == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Tidak ada angka yang valid ditemukan!"),
          backgroundColor: AppColors.danger,
        ),
      );
      return;
    }

    setState(() {
      _hasilStatistik = hasil;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Total Angka dalam Field Input", style: AppTextStyles.appBarTitle),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Masukkan deretan angka dalam SATU field:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primaryDark),
            ),
            const SizedBox(height: 4),
            const Text(
              "Pemisah dapat berupa koma (,) atau spasi. Contoh: 15, 30, 45, 20, 10",
              style: TextStyle(color: AppColors.textMuted, fontSize: 13),
            ),
            const SizedBox(height: 12),

            // Field Input Tunggal
            TextField(
              controller: _inputController,
              keyboardType: TextInputType.text,
              decoration: AppStyles.inputDecoration(
                labelText: "Field Input Data Angka",
                hintText: "Contoh: 15, 30, 45, 20, 10",
                prefixIcon: Icons.format_list_numbered,
              ),
            ),

            const SizedBox(height: 14),

            // Tombol Hitung
            ElevatedButton.icon(
              style: AppStyles.primaryButton,
              onPressed: _hitung,
              icon: const Icon(Icons.calculate),
              label: const Text("Hitung Jumlah Total Angka"),
            ),

            const SizedBox(height: 20),

            // Hasil Perhitungan Lengkap
            if (_hasilStatistik != null)
              Container(
                decoration: AppStyles.cardBoxDecoration(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Hasil Perhitungan Field Input:",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryDark,
                      ),
                    ),
                    const Divider(height: 20),
                    _itemHasil("Jumlah Total Angka", "${_hasilStatistik!['total']}", AppColors.primary),
                    _itemHasil("Banyaknya Angka (n)", "${_hasilStatistik!['jumlahData']} angka", null),
                    _itemHasil("Nilai Rata-rata", (_hasilStatistik!['rataRata'] as double).toStringAsFixed(2), null),
                    _itemHasil("Nilai Tertinggi (Maks)", "${_hasilStatistik!['maks']}", AppColors.success),
                    _itemHasil("Nilai Terendah (Min)", "${_hasilStatistik!['min']}", AppColors.danger),
                    const Divider(height: 16),
                    _itemHasil("Total Akumulasi Digit", "${_hasilStatistik!['totalDigit']}", AppColors.secondary),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _itemHasil(String label, String nilai, Color? warnaNilai) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500, color: AppColors.textDark)),
          Text(
            nilai,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: warnaNilai ?? AppColors.textDark,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
