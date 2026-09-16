import 'package:flutter/material.dart';
import '../logic/operasional_stok_logic.dart';
import '../styles/app_colors.dart';
import '../styles/app_styles.dart';
import '../styles/app_text_styles.dart';

/// Halaman Perkalian dan Pembagian Angka (Kriteria 4)
/// Studi Kasus: Hitung Total Box (Perkalian) & Distribusi Rak (Pembagian & Modulo)
/// Menggunakan OperasionalStokLogic untuk komputasi, dan AppStyles/AppColors untuk desain visual.
class HalamanPerkalianPembagian extends StatefulWidget {
  const HalamanPerkalianPembagian({super.key});

  @override
  State<HalamanPerkalianPembagian> createState() =>
      _HalamanPerkalianPembagianState();
}

class _HalamanPerkalianPembagianState extends State<HalamanPerkalianPembagian> {
  // Controller untuk Perkalian
  final TextEditingController _boxController = TextEditingController();
  final TextEditingController _isiController = TextEditingController();
  String _hasilPerkalian = "";

  // Controller untuk Pembagian
  final TextEditingController _stokController = TextEditingController();
  final TextEditingController _rakController = TextEditingController();
  String _hasilPembagian = "";

  // Fungsi Menghitung Perkalian (Jumlah Box * Isi)
  void _hitungPerkalian() {
    final box = int.tryParse(_boxController.text.trim());
    final isi = int.tryParse(_isiController.text.trim());

    if (box == null || isi == null || box < 0 || isi < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Masukkan angka yang valid dan tidak negatif!"),
          backgroundColor: AppColors.danger,
        ),
      );
      return;
    }

    final total = OperasionalStokLogic.hitungPerkalianBox(box, isi);
    setState(() {
      _hasilPerkalian =
          "Rumus : $box box × $isi unit/box\nTotal : $total unit barang siap disimpan di gudang.";
    });
  }

  // Fungsi Menghitung Pembagian dan Modulo (Total Stok / Jumlah Rak)
  void _hitungPembagian() {
    final stok = int.tryParse(_stokController.text.trim());
    final rak = int.tryParse(_rakController.text.trim());

    if (stok == null || rak == null || stok < 0 || rak <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Jumlah rak harus lebih dari 0 dan stok tidak boleh negatif!"),
          backgroundColor: AppColors.danger,
        ),
      );
      return;
    }

    final hasil = OperasionalStokLogic.hitungPembagianRak(stok, rak);
    setState(() {
      _hasilPembagian = hasil["teksHasil"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Perkalian & Pembagian", style: AppTextStyles.appBarTitle),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textDark,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Bagian 1: Perkalian (Box)
            Container(
              decoration: AppStyles.cardBoxDecoration(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.calculate_outlined, color: AppColors.secondary),
                      SizedBox(width: 8),
                      Text(
                        "1. Hitung Total Kardus / Box (Perkalian ×)",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primaryDark),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _boxController,
                    keyboardType: TextInputType.number,
                    decoration: AppStyles.inputDecoration(
                      labelText: "Jumlah Box / Dus",
                      hintText: "Contoh: 10",
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _isiController,
                    keyboardType: TextInputType.number,
                    decoration: AppStyles.inputDecoration(
                      labelText: "Isi Barang per Box",
                      hintText: "Contoh: 24",
                    ),
                  ),
                  const SizedBox(height: 14),
                  ElevatedButton.icon(
                    style: AppStyles.primaryButton,
                    onPressed: _hitungPerkalian,
                    icon: const Icon(Icons.close),
                    label: const Text("Hitung Perkalian"),
                  ),
                  if (_hasilPerkalian.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.lavenderAccent),
                      ),
                      child: Text(
                        _hasilPerkalian,
                        style: const TextStyle(fontWeight: FontWeight.w600, height: 1.4, color: AppColors.primaryDark),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Bagian 2: Pembagian (Rak Gudang & Modulo)
            Container(
              decoration: AppStyles.cardBoxDecoration(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.safety_divider, color: AppColors.accent),
                      SizedBox(width: 8),
                      Text(
                        "2. Distribusi ke Rak (Pembagian ÷ & Modulo %)",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primaryDark),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _stokController,
                    keyboardType: TextInputType.number,
                    decoration: AppStyles.inputDecoration(
                      labelText: "Total Jumlah Stok Barang",
                      hintText: "Contoh: 100",
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _rakController,
                    keyboardType: TextInputType.number,
                    decoration: AppStyles.inputDecoration(
                      labelText: "Jumlah Rak Penyimpanan",
                      hintText: "Contoh: 6",
                    ),
                  ),
                  const SizedBox(height: 14),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: _hitungPembagian,
                    icon: const Icon(Icons.safety_divider),
                    label: const Text("Hitung Pembagian & Modulo", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  if (_hasilPembagian.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.accentLight,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.accent),
                      ),
                      child: Text(
                        _hasilPembagian,
                        style: const TextStyle(fontWeight: FontWeight.w600, height: 1.4, color: AppColors.textDark),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
