import 'package:flutter/material.dart';
import '../data_gudang.dart';
import '../logic/operasional_stok_logic.dart';
import '../styles/app_colors.dart';
import '../styles/app_styles.dart';
import '../styles/app_text_styles.dart';

/// Halaman Input Barang Baru Cepat (Menu 6)
/// Menambahkan barang ke memori runtime dengan validasi dan styling terpusat (Lavender).
class HalamanInputBarang extends StatefulWidget {
  const HalamanInputBarang({super.key});

  @override
  State<HalamanInputBarang> createState() => _HalamanInputBarangState();
}

class _HalamanInputBarangState extends State<HalamanInputBarang> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _satuanController = TextEditingController();
  final TextEditingController _stokController = TextEditingController();

  void _prosesTambahBarang() {
    final nama = _namaController.text.trim();
    final satuan = _satuanController.text.trim();
    final stokTeks = _stokController.text.trim();

    if (nama.isEmpty) {
      _tampilkanPesan("Nama barang tidak boleh kosong!");
      return;
    }

    if (satuan.isEmpty) {
      _tampilkanPesan("Satuan barang tidak boleh kosong!");
      return;
    }

    final stokAwal = double.tryParse(stokTeks.replaceAll(',', '.'));
    if (stokAwal == null || stokAwal < 0) {
      _tampilkanPesan("Stok awal harus berupa angka valid positif (>= 0)!");
      return;
    }

    // Cek duplikasi nama barang
    final isDuplikat = DataGudang.daftarBarang.any(
      (item) => (item["nama"] as String).toLowerCase() == nama.toLowerCase(),
    );

    if (isDuplikat) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Peringatan Duplikasi", style: TextStyle(color: AppColors.warning, fontWeight: FontWeight.bold)),
          content: Text(
            "Barang dengan nama '$nama' sudah terdaftar di database gudang. Apakah Anda tetap ingin memproses pendaftaran?",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal"),
            ),
            ElevatedButton(
              style: AppStyles.primaryButton,
              onPressed: () {
                Navigator.pop(context);
                _simpanBarang(nama, satuan, OperasionalStokLogic.rapikanAngka(stokAwal));
              },
              child: const Text("Tetap Simpan"),
            ),
          ],
        ),
      );
    } else {
      _simpanBarang(nama, satuan, OperasionalStokLogic.rapikanAngka(stokAwal));
    }
  }

  void _simpanBarang(String nama, String satuan, num stokAwal) {
    setState(() {
      int maxId = 0;
      for (var item in DataGudang.daftarBarang) {
        if ((item["id"] as int) > maxId) {
          maxId = item["id"] as int;
        }
      }

      final newId = maxId + 1;
      DataGudang.daftarBarang.add({
        "id": newId,
        "nama": nama,
        "stok": stokAwal,
        "satuan": satuan,
      });

      _namaController.clear();
      _satuanController.clear();
      _stokController.clear();
    });

    _tampilkanPesan("Berhasil! Barang '$nama' telah didaftarkan ke Database Gudang.");
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
        title: const Text("Input Barang Baru (Memori)", style: AppTextStyles.appBarTitle),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textDark,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Card Form Input
            Container(
              decoration: AppStyles.cardBoxDecoration(),
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Formulir Input Barang Baru",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryDark,
                    ),
                  ),
                  const Text(
                    "Daftarkan item barang baru ke dalam daftar cepat inventaris",
                    style: TextStyle(color: AppColors.textMuted, fontSize: 13),
                  ),
                  const Divider(height: 24),

                  // Input 1: Nama Barang
                  TextField(
                    controller: _namaController,
                    decoration: AppStyles.inputDecoration(
                      labelText: "Nama Barang Baru",
                      hintText: "Contoh: Gula Pasir Premium 1kg",
                      prefixIcon: Icons.inventory_2_outlined,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Input 2: Satuan Barang
                  TextField(
                    controller: _satuanController,
                    decoration: AppStyles.inputDecoration(
                      labelText: "Satuan Barang",
                      hintText: "Contoh: pcs, kg, pouch, box, karung",
                      prefixIcon: Icons.category_outlined,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Input 3: Stok Awal
                  TextField(
                    controller: _stokController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: AppStyles.inputDecoration(
                      labelText: "Stok Awal Barang",
                      hintText: "Contoh: 20 atau 15.5",
                      prefixIcon: Icons.numbers_outlined,
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Tombol Submit
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: AppStyles.primaryButton,
                      onPressed: _prosesTambahBarang,
                      icon: const Icon(Icons.add_box),
                      label: const Text(
                        "Daftarkan Barang Baru",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Header List Barang Saat Ini
            Text(
              "Daftar Barang Gudang Saat Ini (${DataGudang.daftarBarang.length} item):",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primaryDark),
            ),
            const SizedBox(height: 8),

            // ListView List Barang Gudang
            if (DataGudang.daftarBarang.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Text("Belum ada barang di database gudang.", style: TextStyle(color: AppColors.textMuted)),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: DataGudang.daftarBarang.length,
                itemBuilder: (context, index) {
                  final barang = DataGudang.daftarBarang[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: AppStyles.cardBoxDecoration(),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppColors.primaryLight,
                        child: Text(
                          "#${barang["id"]}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      title: Text(
                        barang["nama"],
                        style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textDark),
                      ),
                      subtitle: Text("Satuan: ${barang["satuan"]}", style: const TextStyle(color: AppColors.textMuted)),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.successLight,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.success),
                        ),
                        child: Text(
                          "Stok: ${OperasionalStokLogic.formatAngka(barang["stok"] as num)} ${barang["satuan"]}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.success,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
