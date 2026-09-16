/// Class OperasionalStokLogic
/// Memisahkan seluruh logika operasi matematika stok gudang:
/// - Penjumlahan & Pengurangan Stok
/// - Perkalian Box & Pembagian Rak Gudang
/// - Analisis Sifat Ganjil / Genap
/// - Perhitungan Field Input Total Angka & Akumulasi Digit
class OperasionalStokLogic {
  // ==========================================================
  // 1. PENJUMLAHAN & PENGURANGAN STOK
  // ==========================================================

  static Map<String, dynamic> hitungTambahStok({
    required int stokLama,
    required int jumlah,
    required String namaBarang,
    required String satuan,
  }) {
    final stokBaru = stokLama + jumlah;
    return {
      "sukses": true,
      "stokBaru": stokBaru,
      "pesan": "Penjumlahan Berhasil: $stokLama + $jumlah = $stokBaru $satuan",
      "rincian": "[✓] PENJUMLAHAN STOK BERHASIL!\n"
          "Perhitungan Matematika : $stokLama + $jumlah = $stokBaru\n"
          "Stok akhir '$namaBarang' sekarang: $stokBaru $satuan",
    };
  }

  static Map<String, dynamic> hitungKurangStok({
    required int stokLama,
    required int jumlah,
    required String namaBarang,
    required String satuan,
  }) {
    if (stokLama - jumlah < 0) {
      return {
        "sukses": false,
        "stokBaru": stokLama,
        "pesan": "Gagal: Stok tidak cukup untuk dikurangi!",
        "rincian": null,
      };
    }
    final stokBaru = stokLama - jumlah;
    return {
      "sukses": true,
      "stokBaru": stokBaru,
      "pesan": "Pengurangan Berhasil: $stokLama - $jumlah = $stokBaru $satuan",
      "rincian": "[✓] PENGURANGAN STOK BERHASIL!\n"
          "Perhitungan Matematika : $stokLama - $jumlah = $stokBaru\n"
          "Stok akhir '$namaBarang' sekarang: $stokBaru $satuan",
    };
  }

  // ==========================================================
  // 2. PERKALIAN & PEMBAGIAN ANGKA
  // ==========================================================

  static int hitungPerkalianBox(int box, int isi) {
    return box * isi;
  }

  static Map<String, dynamic> hitungPembagianRak(int stok, int rak) {
    final kapasitas = stok ~/ rak;
    final sisa = stok % rak;
    final presisi = stok / rak;

    return {
      "kapasitas": kapasitas,
      "sisa": sisa,
      "presisi": presisi,
      "teksHasil": "Total Stok Barang : $stok unit\n"
          "Dibagi ke         : $rak rak penyimpanan\n"
          "Kapasitas per Rak : $kapasitas unit per rak (merata)\n"
          "Sisa Stok (Modulo): $sisa unit (belum tertampung di rak)\n"
          "Nilai Rata-rata   : ${presisi.toStringAsFixed(2)} unit/rak",
    };
  }

  // ==========================================================
  // 3. ANALISIS GANJIL / GENAP
  // ==========================================================

  static Map<String, dynamic> analisisGanjilGenap(int stok, String satuan) {
    final isGenap = (stok % 2 == 0);
    return {
      "isGenap": isGenap,
      "label": isGenap ? "GENAP" : "GANJIL",
      "rumus": "$stok % 2 = ${stok % 2}",
      "analisis": isGenap
          ? "• Stok barang berjumlah GENAP ($stok).\n"
              "• Barang ini siap ditata secara simetris berpasangan di rak display.\n"
              "• Dapat langsung dibuat bundling 2-in-1 tanpa menyisakan item tercecer."
          : "• Stok barang berjumlah GANJIL ($stok).\n"
              "• Jika dikemas dalam paket bundle berpasangan, akan ada 1 $satuan sisa.\n"
              "• Rekomendasi: Disarankan menambah restock 1 $satuan agar genap (${stok + 1}), atau pisahkan 1 $satuan sebagai barang display.",
    };
  }

  // ==========================================================
  // 4. TOTAL ANGKA & AKUMULASI DIGIT
  // ==========================================================

  static Map<String, dynamic>? hitungTotalDanStatistik(String teks) {
    final bersih = teks.replaceAll(',', ' ').replaceAll(';', ' ');
    final potongan = bersih.split(' ');
    final List<double> angkaList = [];

    for (var p in potongan) {
      final trimmed = p.trim();
      if (trimmed.isNotEmpty) {
        final val = double.tryParse(trimmed);
        if (val != null) angkaList.add(val);
      }
    }

    if (angkaList.isEmpty) return null;

    final total = angkaList.reduce((a, b) => a + b);
    final rataRata = total / angkaList.length;
    final maks = angkaList.reduce((a, b) => a > b ? a : b);
    final min = angkaList.reduce((a, b) => a < b ? a : b);

    int totalDigit = 0;
    for (var a in angkaList) {
      String str = a.toString().replaceAll('.', '').replaceAll('-', '');
      for (int i = 0; i < str.length; i++) {
        int? d = int.tryParse(str[i]);
        if (d != null) totalDigit += d;
      }
    }

    return {
      "angkaList": angkaList,
      "jumlahData": angkaList.length,
      "total": total,
      "rataRata": rataRata,
      "maks": maks,
      "min": min,
      "totalDigit": totalDigit,
    };
  }
}
