import 'package:flutter/material.dart';

/// Halaman Jumlah Total Angka dalam Suatu Field Input Data (Kriteria 6)
/// Diselaraskan 100% dengan modul aplikasi_stok (termasuk Total Akumulasi Digit)
class HalamanTotalAngka extends StatefulWidget {
  const HalamanTotalAngka({super.key});

  @override
  State<HalamanTotalAngka> createState() => _HalamanTotalAngkaState();
}

class _HalamanTotalAngkaState extends State<HalamanTotalAngka> {
  // Controller untuk membaca deretan angka dari satu field input
  final TextEditingController _inputController = TextEditingController();

  double? _total;
  double? _rataRata;
  double? _maks;
  double? _min;
  int _jumlahData = 0;
  int? _totalDigit; // Akumulasi total digit angka (sesuai modul aplikasi_stok)

  // Fungsi untuk menghitung akumulasi total per digit angka
  int _hitungTotalDigit(List<double> deret) {
    int total = 0;
    for (var a in deret) {
      String str = a.toString().replaceAll('.', '').replaceAll('-', '');
      for (int i = 0; i < str.length; i++) {
        int? d = int.tryParse(str[i]);
        if (d != null) total += d;
      }
    }
    return total;
  }

  void _hitung() {
    final teks = _inputController.text.trim();

    if (teks.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Field input angka tidak boleh kosong!")),
      );
      return;
    }

    // Bersihkan pemisah (ubah koma dan titik koma menjadi spasi)
    final bersih = teks.replaceAll(',', ' ').replaceAll(';', ' ');
    final potongan = bersih.split(' ');
    final List<double> angkaList = [];

    for (var p in potongan) {
      final trimmed = p.trim();
      if (trimmed.isNotEmpty) {
        final val = double.tryParse(trimmed);
        if (val != null) {
          angkaList.add(val);
        }
      }
    }

    if (angkaList.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Tidak ada angka yang valid ditemukan!")),
      );
      return;
    }

    setState(() {
      _jumlahData = angkaList.length;
      _total = angkaList.reduce((a, b) => a + b); // Jumlah Total
      _rataRata = _total! / _jumlahData; // Rata-rata
      _maks = angkaList.reduce((a, b) => a > b ? a : b); // Maksimum
      _min = angkaList.reduce((a, b) => a < b ? a : b); // Minimum
      _totalDigit = _hitungTotalDigit(angkaList); // Akumulasi Digit Angka
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Total Angka dalam Field Input"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Masukkan deretan angka dalam SATU field:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text(
              "Pemisah dapat berupa koma (,) atau spasi. Contoh: 15, 30, 45, 20, 10",
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
            ),
            const SizedBox(height: 12),

            // Field Input Tunggal
            TextField(
              controller: _inputController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Field Input Data Angka",
                hintText: "Contoh: 15, 30, 45, 20, 10",
              ),
            ),

            const SizedBox(height: 12),

            // Tombol Hitung
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: _hitung,
              icon: const Icon(Icons.calculate),
              label: const Text("Hitung Jumlah Total Angka"),
            ),

            const SizedBox(height: 20),

            // Hasil Perhitungan Lengkap
            if (_total != null)
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Hasil Perhitungan Field Input:",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const Divider(height: 20),
                      _itemHasil("Jumlah Total Angka", "$_total", Colors.blue),
                      _itemHasil("Banyaknya Angka (n)", "$_jumlahData angka", null),
                      _itemHasil("Nilai Rata-rata", _rataRata!.toStringAsFixed(2), null),
                      _itemHasil("Nilai Tertinggi (Maks)", "$_maks", Colors.green),
                      _itemHasil("Nilai Terendah (Min)", "$_min", Colors.red),
                      const Divider(height: 16),
                      _itemHasil("Total Akumulasi Digit", "$_totalDigit", Colors.purple),
                    ],
                  ),
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
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(
            nilai,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: warnaNilai ?? Colors.black87,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
