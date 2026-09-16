import 'package:flutter/material.dart';
import '../data_gudang.dart';
import '../styles/app_colors.dart';
import '../styles/app_styles.dart';
import '../styles/app_text_styles.dart';

/// Halaman untuk menampilkan data kelompok mahasiswa (Kriteria 2)
/// Menggunakan styling terpusat AppStyles & AppColors (Tema Lavender).
class HalamanDataKelompok extends StatelessWidget {
  const HalamanDataKelompok({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Data Kelompok Mahasiswa", style: AppTextStyles.appBarTitle),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: DataGudang.daftarAnggota.length,
        itemBuilder: (context, index) {
          final anggota = DataGudang.daftarAnggota[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: AppStyles.cardBoxDecoration(),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: CircleAvatar(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                child: Text(
                  "${index + 1}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              title: Text(
                anggota["nama"] ?? "",
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textDark),
              ),
              subtitle: Text(
                "NIM: ${anggota["nim"]}",
                style: const TextStyle(color: AppColors.textMuted, fontSize: 14),
              ),
            ),
          );
        },
      ),
    );
  }
}
