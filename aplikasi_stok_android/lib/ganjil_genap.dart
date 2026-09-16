import 'package:flutter/material.dart';
import 'data_gudang.dart';

/// Halaman Cek Bilangan Ganjil / Genap (Kriteria 5)
/// Studi Kasus: Analisis Sifat Stok Barang Gudang untuk Logistik Display & Bundling
/// Diselaraskan 100% dengan modul CLI aplikasi_stok
class HalamanGanjilGenap extends StatefulWidget {
  const HalamanGanjilGenap({super.key});

  @override
  State<HalamanGanjilGenap> createState() => _HalamanGanjilGenapState();
}

class _HalamanGanjilGenapState extends State<HalamanGanjilGenap> {
  // ID barang yang dipilih
  int? _idDipilih;

  @override
  Widget build(BuildContext context) {
    // Cari barang yang dipilih (jika ada)
    Map<String, dynamic>? barangDipilih;
    if (_idDipilih != null) {
      barangDipilih = DataGudang.daftarBarang
          .firstWhere((item) => item["id"] == _idDipilih);
    }

    final stok = (barangDipilih != null) ? (barangDipilih["stok"] as int) : 0;
    final isGenap = (stok % 2 == 0); // Logika Penentu Ganjil / Genap

    return Scaffold(
      appBar: AppBar(
        title: const Text("Analisis Ganjil / Genap Stok"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Pilih Barang Gudang untuk Dianalisis:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),

            // Dropdown Pilihan Barang
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(8),
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
                          "${barang["nama"]} (Stok: ${barang["stok"]} ${barang["satuan"]})"),
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
                      Text(
                        barangDipilih["nama"],
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text("Jumlah Stok   : $stok ${barangDipilih["satuan"]}"),
                      Text("Logika Rumus  : $stok % 2 = ${stok % 2}"),
                      const Divider(height: 24),

                      // Status Badge Ganjil / Genap
                      Row(
                        children: [
                          const Text("Sifat Bilangan: ",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: isGenap ? Colors.green : Colors.orange,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              isGenap ? "GENAP" : "GANJIL",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),
                      const Text(
                        "ANALISIS OPERASIONAL GUDANG:",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        isGenap
                            ? "• Stok barang berjumlah GENAP ($stok).\n"
                              "• Barang ini siap ditata secara simetris berpasangan di rak display.\n"
                              "• Dapat langsung dibuat bundling 2-in-1 tanpa menyisakan item tercecer."
                            : "• Stok barang berjumlah GANJIL ($stok).\n"
                              "• Jika dikemas dalam paket bundle berpasangan, akan ada 1 ${barangDipilih["satuan"]} sisa.\n"
                              "• Rekomendasi: Disarankan menambah restock 1 ${barangDipilih["satuan"]} agar genap (${stok + 1}), atau jual 1 ${barangDipilih["satuan"]} sebagai barang sample/display terpisah.",
                        style: TextStyle(color: Colors.grey.shade800, height: 1.4),
                      ),
                    ],
                  ),
                ),
              )
            else
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Text(
                    "Silakan pilih barang di atas untuk melihat analisis ganjil / genap.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
