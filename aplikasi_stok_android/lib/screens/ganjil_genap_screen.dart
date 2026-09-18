import 'package:flutter/material.dart';
import '../data_gudang.dart';
import '../logic/operasional_stok_logic.dart';
import '../styles/app_colors.dart';
import '../styles/app_styles.dart';
import '../styles/app_text_styles.dart';

/// Halaman Cek Bilangan Ganjil / Genap (Kriteria 5)
/// Menggunakan OperasionalStokLogic untuk evaluasi modulo & logika bisnis,
/// serta AppStyles/AppColors untuk desain visual (Lavender).
class HalamanGanjilGenap extends StatefulWidget {
  const HalamanGanjilGenap({super.key});

  @override
  State<HalamanGanjilGenap> createState() => _HalamanGanjilGenapState();
}

class _HalamanGanjilGenapState extends State<HalamanGanjilGenap> {
  int? _idDipilih;

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic>? barangDipilih;
    if (_idDipilih != null) {
      barangDipilih = DataGudang.daftarBarang
          .firstWhere((item) => item["id"] == _idDipilih);
    }

    final stok = (barangDipilih != null) ? (barangDipilih["stok"] as num) : 0;
    final satuan = (barangDipilih != null) ? (barangDipilih["satuan"] as String) : "";

    // Analisis ganjil genap menggunakan OperasionalStokLogic
    final analisis = OperasionalStokLogic.analisisGanjilGenap(stok, satuan);
    final bool isGenap = analisis["isGenap"];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Analisis Ganjil / Genap Stok", style: AppTextStyles.appBarTitle),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textDark,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Pilih Barang Gudang untuk Dianalisis:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primaryDark),
            ),
            const SizedBox(height: 12),

            // Dropdown Pilihan Barang
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(10),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  isExpanded: true,
                  hint: const Text("Pilih salah satu barang..."),
                  value: _idDipilih,
                  items: DataGudang.daftarBarang.map((barang) {
                    return DropdownMenuItem<int>(
                      value: barang["id"],
                      child: Text(
                        "${barang["nama"]} (Stok: ${OperasionalStokLogic.formatAngka(barang["stok"] as num)} ${barang["satuan"]})",
                        style: const TextStyle(color: AppColors.textDark),
                      ),
                    );
                  }).toList(),
                  onChanged: (id) {
                    setState(() {
                      _idDipilih = id;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Hasil Analisis
            if (barangDipilih != null)
              Container(
                decoration: AppStyles.cardBoxDecoration(),
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      barangDipilih["nama"],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text("Jumlah Stok   : ${OperasionalStokLogic.formatAngka(stok)} ${barangDipilih["satuan"]}", style: const TextStyle(color: AppColors.textDark)),
                    Text("Logika Rumus  : ${analisis["rumus"]}", style: const TextStyle(color: AppColors.textMuted)),
                    const Divider(height: 24),

                    // Status Badge Ganjil / Genap
                    Row(
                      children: [
                        const Text("Sifat Bilangan: ",
                            style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textDark)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                          decoration: BoxDecoration(
                            color: isGenap ? AppColors.success : AppColors.secondary,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            analisis["label"],
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),
                    const Text(
                      "ANALISIS OPERASIONAL GUDANG:",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.primaryDark),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      analisis["analisis"],
                      style: const TextStyle(color: AppColors.textDark, height: 1.4),
                    ),
                  ],
                ),
              )
            else
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Text(
                    "Silakan pilih barang di atas untuk melihat analisis ganjil / genap.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.textMuted),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
