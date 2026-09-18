/// Class OperasionalStokLogic
/// Memisahkan seluruh logika operasi matematika stok gudang:
/// - Penjumlahan & Pengurangan Stok (Mendukung Angka Bulat & Desimal / Koma)
/// - Perkalian Box & Pembagian Rak Gudang (Mendukung Desimal & Modulo)
/// - Analisis Sifat Ganjil / Genap
/// - Perhitungan Field Input Total Angka & Akumulasi Digit
class OperasionalStokLogic {
  /// Helper untuk memformat angka: jika bilangan bulat, tampilkan tanpa desimal (.0)
  static String formatAngka(num val) {
    if (val % 1 == 0) {
      return val.toInt().toString();
    }
    String s = val.toString();
    if (s.contains('.')) {
      s = s.replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');
    }
    return s;
  }

  /// Helper internal agar tipe data tetap konsisten (int jika bulat, double jika desimal)
  static num rapikanAngka(num val) {
    if (val % 1 == 0) {
      return val.toInt();
    }
    return val;
  }

  // ==========================================================
  // 1. PENJUMLAHAN & PENGURANGAN STOK
  // ==========================================================

  static Map<String, dynamic> hitungTambahStok({
    required num stokLama,
    required num jumlah,
    required String namaBarang,
    required String satuan,
  }) {
    final stokBaru = rapikanAngka(stokLama + jumlah);
    final sLama = formatAngka(stokLama);
    final sJml = formatAngka(jumlah);
    final sBaru = formatAngka(stokBaru);

    return {
      "sukses": true,
      "stokBaru": stokBaru,
      "pesan": "Penjumlahan Berhasil: $sLama + $sJml = $sBaru $satuan",
      "rincian": "[✓] PENJUMLAHAN STOK BERHASIL!\n"
          "Perhitungan Matematika : $sLama + $sJml = $sBaru\n"
          "Stok akhir '$namaBarang' sekarang: $sBaru $satuan",
    };
  }

  static Map<String, dynamic> hitungKurangStok({
    required num stokLama,
    required num jumlah,
    required String namaBarang,
    required String satuan,
  }) {
    if (stokLama - jumlah < 0) {
      return {
        "sukses": false,
        "stokBaru": rapikanAngka(stokLama),
        "pesan": "Gagal: Stok tidak cukup untuk dikurangi!",
        "rincian": null,
      };
    }
    final stokBaru = rapikanAngka(stokLama - jumlah);
    final sLama = formatAngka(stokLama);
    final sJml = formatAngka(jumlah);
    final sBaru = formatAngka(stokBaru);

    return {
      "sukses": true,
      "stokBaru": stokBaru,
      "pesan": "Pengurangan Berhasil: $sLama - $sJml = $sBaru $satuan",
      "rincian": "[✓] PENGURANGAN STOK BERHASIL!\n"
          "Perhitungan Matematika : $sLama - $sJml = $sBaru\n"
          "Stok akhir '$namaBarang' sekarang: $sBaru $satuan",
    };
  }

  // ==========================================================
  // 2. PERKALIAN & PEMBAGIAN ANGKA
  // ==========================================================

  static num hitungPerkalianBox(num box, num isi) {
    return rapikanAngka(box * isi);
  }

  static Map<String, dynamic> hitungPembagianRak(num stok, num rak) {
    final kapasitas = stok ~/ rak;
    final sisa = rapikanAngka(stok % rak);
    final presisi = stok / rak;

    final sStok = formatAngka(stok);
    final sRak = formatAngka(rak);
    final sSisa = formatAngka(sisa);

    return {
      "kapasitas": kapasitas,
      "sisa": sisa,
      "presisi": presisi,
      "teksHasil": "Total Stok Barang : $sStok unit\n"
          "Dibagi ke         : $sRak rak penyimpanan\n"
          "Kapasitas per Rak : $kapasitas unit per rak (merata)\n"
          "Sisa Stok (Modulo): $sSisa unit (belum tertampung di rak)\n"
          "Nilai Rata-rata   : ${presisi.toStringAsFixed(2)} unit/rak",
    };
  }

  // ==========================================================
  // 3. ANALISIS GANJIL / GENAP
  // ==========================================================

  static Map<String, dynamic> analisisGanjilGenap(num stok, String satuan) {
    final bool isDesimal = (stok % 1 != 0);
    final int stokBulat = stok.toInt();
    final isGenap = (stokBulat % 2 == 0);
    final sStok = formatAngka(stok);

    String analisisTeks = "";
    if (isDesimal) {
      analisisTeks = "• Stok barang memiliki pecahan desimal ($sStok $satuan).\n"
          "• Bagian bilangan bulatnya adalah $stokBulat (${isGenap ? 'GENAP' : 'GANJIL'}).\n"
          "• Sisa pecahan desimal ${formatAngka(stok - stokBulat)} $satuan disarankan dipaketkan khusus atau ditimbang ulang.";
    } else {
      analisisTeks = isGenap
          ? "• Stok barang berjumlah GENAP ($sStok).\n"
              "• Barang ini siap ditata secara simetris berpasangan di rak display.\n"
              "• Dapat langsung dibuat bundling 2-in-1 tanpa menyisakan item tercecer."
          : "• Stok barang berjumlah GANJIL ($sStok).\n"
              "• Jika dikemas dalam paket bundle berpasangan, akan ada 1 $satuan sisa.\n"
              "• Rekomendasi: Disarankan menambah restock 1 $satuan agar genap (${stokBulat + 1}), atau pisahkan 1 $satuan sebagai barang display.";
    }

    return {
      "isGenap": isGenap,
      "label": isGenap ? "GENAP" : "GANJIL",
      "rumus": isDesimal
          ? "Bagian bulat: $stokBulat % 2 = ${stokBulat % 2} (Sisa desimal: ${formatAngka(stok - stokBulat)})"
          : "$stokBulat % 2 = ${stokBulat % 2}",
      "analisis": analisisTeks,
    };
  }

  // ==========================================================
  // 4. TOTAL ANGKA & AKUMULASI DIGIT
  // ==========================================================

  static Map<String, dynamic>? hitungTotalDanStatistik(String teks) {
    // Normalisasi: jika ada titik koma atau koma dengan spasi, pisahkan
    String diproses = teks.replaceAll(';', ' ');
    // Jika ada koma yang diikuti spasi (misal "15, 30.5, 45"), ganti dengan spasi
    diproses = diproses.replaceAll(RegExp(r',\s+'), ' ');
    // Jika ada koma tunggal sebagai pemisah antar angka tanpa spasi (misal "15,30,45"), tapi bukan desimal
    // Cek apakah ada koma desimal seperti "12,5" yang dipisahkan spasi "12,5 30,5"
    final bagianAwal = diproses.split(RegExp(r'\s+'));
    final List<double> angkaList = [];

    for (var p in bagianAwal) {
      final trimmed = p.trim();
      if (trimmed.isNotEmpty) {
        // Coba parsing langsung (support dot dan comma desimal)
        final val = double.tryParse(trimmed.replaceAll(',', '.'));
        if (val != null) {
          angkaList.add(val);
        } else if (trimmed.contains(',')) {
          // Jika mengandung koma sebagai pemisah (misal "15,30,45")
          final subBagian = trimmed.split(',');
          for (var sp in subBagian) {
            final sVal = double.tryParse(sp.trim());
            if (sVal != null) angkaList.add(sVal);
          }
        }
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
