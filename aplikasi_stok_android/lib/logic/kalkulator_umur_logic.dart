/// Class KalkulatorUmurLogic
/// Memisahkan seluruh logika komputasi kalkulator umur & waktu detil dari antarmuka UI.
/// Menerapkan aturan: input tanggal di-anchor ke jam 00:00:00, dihitung presisi ke detik realtime.
class KalkulatorUmurLogic {
  /// Mengatur waktu awal tepat pada pukul 00:00:00 di tanggal yang dipilih
  static DateTime anchorKePukul00(DateTime tanggal) {
    return DateTime(
      tanggal.year,
      tanggal.month,
      tanggal.day,
      0,
      0,
      0,
    );
  }

  /// Menghitung perbedaan durasi lengkap (Tahun, Bulan, Hari, Jam, Menit, Detik)
  static Map<String, int> hitungDurasiRinci(DateTime tglAwal00, DateTime now) {
    int years = now.year - tglAwal00.year;
    int months = now.month - tglAwal00.month;
    int days = now.day - tglAwal00.day;
    int hours = now.hour - tglAwal00.hour;
    int minutes = now.minute - tglAwal00.minute;
    int seconds = now.second - tglAwal00.second;

    if (seconds < 0) {
      seconds += 60;
      minutes -= 1;
    }
    if (minutes < 0) {
      minutes += 60;
      hours -= 1;
    }
    if (hours < 0) {
      hours += 24;
      days -= 1;
    }
    if (days < 0) {
      final prevMonthLastDay = DateTime(now.year, now.month, 0).day;
      days += prevMonthLastDay;
      months -= 1;
    }
    if (months < 0) {
      months += 12;
      years -= 1;
    }

    return {
      "years": years,
      "months": months,
      "days": days,
      "hours": hours,
      "minutes": minutes,
      "seconds": seconds,
    };
  }

  /// Menghitung hitung mundur (countdown) menuju ulang tahun berikutnya
  static Map<String, int> hitungCountdownUltah(DateTime tglLahir, DateTime now) {
    DateTime nextBirthday = DateTime(now.year, tglLahir.month, tglLahir.day);

    if (nextBirthday.isBefore(now)) {
      nextBirthday = DateTime(now.year + 1, tglLahir.month, tglLahir.day);
    }

    final diff = nextBirthday.difference(now);
    return {
      "days": diff.inDays,
      "hours": diff.inHours % 24,
      "minutes": diff.inMinutes % 60,
      "seconds": diff.inSeconds % 60,
    };
  }

  /// Evaluasi kontrol mutu masa simpan batch barang gudang (FIFO)
  static Map<String, dynamic> evaluasiShelfLife(int totalHari) {
    if (totalHari <= 30) {
      return {
        "status": "🟢 Produk Masih Baru (Usia < 30 Hari)",
        "rekomendasi": "Kondisi sangat segar dan aman disimpan.",
        "isWarning": false,
      };
    } else if (totalHari <= 90) {
      return {
        "status": "🟡 Usia Simpan Menengah (31-90 Hari)",
        "rekomendasi": "Prioritaskan untuk pengiriman toko menggunakan metode FIFO.",
        "isWarning": false,
      };
    } else {
      return {
        "status": "🔴 Usia Simpan Tua (> 90 Hari)",
        "rekomendasi": "Segera distribusikan atau keluarkan ke display display terdepan!",
        "isWarning": true,
      };
    }
  }
}
