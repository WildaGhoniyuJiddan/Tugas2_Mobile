/// Class PenanggalanHelper
/// Berisi logika konversi penanggalan:
/// 1. Kalender Hijriah (Islam)
/// 2. Kalender Weton Jawa & Perhitungan Nilai Neptu
/// 3. Kalender Saka Bali (Tahun Saka, 30 Wuku, dan Sasih)
class PenanggalanHelper {
  // ==========================================================
  // 1. KONVERSI KALENDER HIJRIAH (ISLAM)
  // ==========================================================

  static const List<String> namaBulanHijriah = [
    "Muharram",
    "Safar",
    "Rabi'ul Awwal",
    "Rabi'ul Akhir",
    "Jumadil Awwal",
    "Jumadil Akhir",
    "Rajab",
    "Sya'ban",
    "Ramadhan",
    "Syawwal",
    "Dzulqa'dah",
    "Dzulhijjah"
  ];

  static const List<String> namaHariArab = [
    "Al-Ahad (Minggu)",
    "Al-Itsnayn (Senin)",
    "Ats-Tsulatsa' (Selasa)",
    "Al-Arba'a' (Rabu)",
    "Al-Khamis (Kamis)",
    "Al-Jum'ah (Jumat)",
    "As-Sabt (Sabtu)"
  ];

  /// Menghitung tanggal Hijriah dari tanggal Masehi menggunakan algoritma astronomis
  static Map<String, dynamic> konversiKeHijriah(DateTime tanggal) {
    int day = tanggal.day;
    int month = tanggal.month;
    int year = tanggal.year;

    // Menghitung Julian Day Number (JDN)
    int a = (14 - month) ~/ 12;
    int y = year + 4800 - a;
    int m = month + 12 * a - 3;
    int jdn = day + ((153 * m + 2) ~/ 5) + 365 * y + (y ~/ 4) - (y ~/ 100) + (y ~/ 400) - 32045;

    // Konversi JDN ke Kalender Hijriah (Standar Hisab Sipil Indonesia / Kemenag)
    int l = jdn - 1948440 + 10633;
    int n = ((l - 1) ~/ 10631);
    int l2 = l - 10631 * n + 354;
    int j = ((10985 - l2) ~/ 5316) * ((50 * l2) ~/ 17719) + (l2 ~/ 5670) * ((43 * l2) ~/ 15238);
    int l3 = l2 - ((30 - j) ~/ 15) * ((17719 * j) ~/ 50) - (j ~/ 16) * ((15238 * j) ~/ 43) + 29;
    int mHijri = (24 * l3) ~/ 709;
    int dHijri = l3 - (709 * mHijri) ~/ 24;
    int yHijri = 30 * n + j - 30;

    int indexBulan = (mHijri - 1).clamp(0, 11);
    String namaBulan = namaBulanHijriah[indexBulan];
    String namaHari = namaHariArab[tanggal.weekday % 7];

    // Info momentum keagamaan
    String infoMomentum = "Periode operasional normal.";
    if (mHijri == 9) {
      infoMomentum = "🌙 Bulan Suci Ramadhan (Peningkatan permintaan sembako & kurma).";
    } else if (mHijri == 10 && dHijri <= 3) {
      infoMomentum = "🎉 Hari Raya Idul Fitri 1-3 Syawwal (Puncak distribusi makanan ringan).";
    } else if (mHijri == 12 && dHijri == 10) {
      infoMomentum = "🐑 Hari Raya Idul Adha (Kebutuhan bumbu kurban & pengemasan daging).";
    } else if (dHijri >= 13 && dHijri <= 15) {
      infoMomentum = "✨ Jadwal Puasa Sunnah Ayyamul Bidh ($dHijri-$namaBulan).";
    }

    return {
      "tanggal": dHijri,
      "bulan": namaBulan,
      "tahun": yHijri,
      "formatLengkap": "$dHijri $namaBulan $yHijri H",
      "hariArab": namaHari,
      "momentum": infoMomentum,
    };
  }

  // ==========================================================
  // 2. KONVERSI KALENDER WETON JAWA & NEPTU
  // ==========================================================

  static const List<String> daftarPasaran = ["Legi", "Pahing", "Pon", "Wage", "Kliwon"];
  static const Map<String, int> neptuPasaran = {
    "Legi": 5,
    "Pahing": 9,
    "Pon": 7,
    "Wage": 4,
    "Kliwon": 8,
  };

  static const List<String> daftarHariJawa = [
    "Senin",
    "Selasa",
    "Rabu",
    "Kamis",
    "Jumat",
    "Sabtu",
    "Minggu"
  ];

  static const Map<String, int> neptuHari = {
    "Minggu": 5,
    "Senin": 4,
    "Selasa": 3,
    "Rabu": 7,
    "Kamis": 8,
    "Jumat": 6,
    "Sabtu": 9,
  };

  /// Menghitung weton Jawa (Saptawara + Pancawara) dan total nilai neptu
  static Map<String, dynamic> konversiKeWeton(DateTime tanggal) {
    // Acuan epoch: 17 Agustus 1945 adalah hari Jumat Legi (Pasaran index 0 = Legi)
    final refDate = DateTime(1945, 8, 17);
    final selisihHari = tanggal.difference(refDate).inDays;

    int indexPasaran = (selisihHari % 5 + 5) % 5;
    String pasaran = daftarPasaran[indexPasaran];

    String hari = daftarHariJawa[tanggal.weekday - 1];
    int nHari = neptuHari[hari] ?? 0;
    int nPasaran = neptuPasaran[pasaran] ?? 0;
    int totalNeptu = nHari + nPasaran;

    // Konteks pasar tradisional & distribusi gudang
    String peranDistribusi = "";
    switch (pasaran) {
      case "Legi":
        peranDistribusi = "Hari Pasaran Manis: Waktu optimal pengiriman sayur, buah & sembako segar.";
        break;
      case "Pahing":
        peranDistribusi = "Hari Pasaran Merah: Puncak transaksi hasil bumi primer & komoditas pangan pokok.";
        break;
      case "Pon":
        peranDistribusi = "Hari Pasaran Kuning: Hari perputaran barang kebutuhan rumah tangga & grosir kering.";
        break;
      case "Wage":
        peranDistribusi = "Hari Pasaran Hitam: Cocok untuk audit fisik stok & restock barang antar gudang.";
        break;
      case "Kliwon":
        peranDistribusi = "Hari Pasaran Asih: Aktivitas pasar induk regional maksimal, pengiriman skala besar.";
        break;
    }

    return {
      "hari": hari,
      "pasaran": pasaran,
      "wetonLengkap": "$hari $pasaran",
      "neptuHari": nHari,
      "neptuPasaran": nPasaran,
      "totalNeptu": totalNeptu,
      "analisisDistribusi": peranDistribusi,
    };
  }

  // ==========================================================
  // 3. KONVERSI KALENDER SAKA BALI
  // ==========================================================

  static const List<String> daftarWukuBali = [
    "Sinta", "Landep", "Ukir", "Kulantir", "Tolu", "Gumbreg", "Wariga",
    "Warigadean", "Julungwangi", "Sungsang", "Dungulan", "Kuningan",
    "Langkir", "Medangsia", "Pujut", "Pahang", "Krulut", "Merrakih",
    "Tambir", "Medangkungan", "Matal", "Uye", "Menail", "Prangbakat",
    "Bala", "Ugu", "Wayang", "Kelawu", "Dukut", "Watugunung"
  ];

  static const List<String> daftarSasihBali = [
    "Kasa (Bulan 1 - Juli)",
    "Karo (Bulan 2 - Agustus)",
    "Katiga (Bulan 3 - September)",
    "Kapat (Bulan 4 - Oktober)",
    "Kalima (Bulan 5 - November)",
    "Kanem (Bulan 6 - Desember)",
    "Kapitu (Bulan 7 - Januari)",
    "Kawalu (Bulan 8 - Februari)",
    "Kasanga (Bulan 9 - Maret)",
    "Kadasa (Bulan 10 - April)",
    "Jyestha (Bulan 11 - Mei)",
    "Sadha (Bulan 12 - Juni)"
  ];

  /// Menghitung Kalender Saka Bali, 30 Wuku, dan Sasih
  static Map<String, dynamic> konversiKeSakaBali(DateTime tanggal) {
    // Tahun Saka = Tahun Masehi - 78 (dengan penyesuaian Nyepi)
    int tahunSaka = tanggal.year - 78;
    if (tanggal.month < 3) {
      tahunSaka -= 1; // Sebelum Maret umumnya masih tahun Saka sebelumnya
    }

    // Acuan Wuku: 17 Agustus 1945 adalah Wuku Wayang (index 26)
    final refDate = DateTime(1945, 8, 17);
    final selisihHari = tanggal.difference(refDate).inDays;
    int indexRefWuku = 26; // Wayang

    int wukuOffset = (selisihHari ~/ 7);
    int indexWuku = (indexRefWuku + wukuOffset) % 30;
    if (indexWuku < 0) indexWuku += 30;
    String namaWuku = daftarWukuBali[indexWuku];

    // Sasih berdasarkan bulan Masehi (aproksimasi astronomis Saka Bali)
    int indexSasih = (tanggal.month - 7 + 12) % 12;
    String namaSasih = daftarSasihBali[indexSasih];

    // Info hari raya & logistik
    String infoHariRaya = "Kondisi operasional pelabuhan & logistik Bali normal.";
    if (namaWuku == "Dungulan") {
      infoHariRaya = "🌺 Wuku Dungulan: Mendekati Hari Raya Galungan (Permintaan buah & dupa tinggi).";
    } else if (namaWuku == "Kuningan") {
      infoHariRaya = "🎋 Wuku Kuningan: Rangkaian perayaan Hari Raya Kuningan.";
    } else if (tanggal.month == 3 && tanggal.day >= 10 && tanggal.day <= 25) {
      infoHariRaya = "🛑 Perhatian: Antisipasi Hari Raya Nyepi (Pelabuhan & logistik Bali tutup total 24 jam).";
    }

    return {
      "tahunSaka": "$tahunSaka Saka",
      "wuku": namaWuku,
      "sasih": namaSasih,
      "formatLengkap": "Tahun $tahunSaka Saka, Wuku $namaWuku",
      "infoLogistik": infoHariRaya,
    };
  }
}
