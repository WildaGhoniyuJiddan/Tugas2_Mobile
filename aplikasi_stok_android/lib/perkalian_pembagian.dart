import 'package:flutter/material.dart';

/// Halaman Perkalian dan Pembagian Angka (Kriteria 4)
/// Studi Kasus: Hitung Total Box (Perkalian) & Distribusi Rak (Pembagian & Modulo)
/// Diselaraskan 100% dengan modul CLI aplikasi_stok
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
        const SnackBar(content: Text("Masukkan angka yang valid dan tidak negatif!")),
      );
      return;
    }

    final total = box * isi; // Operasi Perkalian (*)
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
        const SnackBar(content: Text("Jumlah rak harus lebih dari 0 dan stok tidak boleh negatif!")),
      );
      return;
    }

    final kapasitas = stok ~/ rak; // Pembagian bulat (~/)
    final sisa = stok % rak; // Modulo / Sisa Bagi (%)
    final presisi = stok / rak; // Nilai Rata-rata Pembagian Desimal

    setState(() {
      _hasilPembagian =
          "Total Stok Barang : $stok unit\n"
          "Dibagi ke         : $rak rak penyimpanan\n"
          "Kapasitas per Rak : $kapasitas unit per rak (merata)\n"
          "Sisa Stok (Modulo): $sisa unit (belum tertampung di rak)\n"
          "Nilai Rata-rata   : ${presisi.toStringAsFixed(2)} unit/rak";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Perkalian & Pembagian"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Bagian 1: Perkalian (Box)
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      "1. Hitung Total Kardus / Box (Perkalian ×)",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _boxController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Jumlah Box / Dus",
                        hintText: "Contoh: 10",
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _isiController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Isi Barang per Box",
                        hintText: "Contoh: 24",
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: _hitungPerkalian,
                      icon: const Icon(Icons.close),
                      label: const Text("Hitung Perkalian"),
                    ),
                    if (_hasilPerkalian.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.blue.shade200),
                        ),
                        child: Text(
                          _hasilPerkalian,
                          style: const TextStyle(fontWeight: FontWeight.w600, height: 1.4),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Bagian 2: Pembagian (Rak Gudang & Modulo)
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      "2. Distribusi Stok ke Rak Gudang (Pembagian ÷ & Modulo %)",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _stokController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Total Jumlah Stok Barang",
                        hintText: "Contoh: 100",
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _rakController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Jumlah Rak Penyimpanan",
                        hintText: "Contoh: 6",
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: _hitungPembagian,
                      icon: const Icon(Icons.safety_divider),
                      label: const Text("Hitung Pembagian & Modulo"),
                    ),
                    if (_hasilPembagian.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.teal.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.teal.shade200),
                        ),
                        child: Text(
                          _hasilPembagian,
                          style: const TextStyle(fontWeight: FontWeight.w600, height: 1.4),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
