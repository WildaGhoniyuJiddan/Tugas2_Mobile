/// Class StopwatchLogic
/// Memisahkan seluruh logika format waktu stopwatch, lap time, dan penentuan pemenang duel
class StopwatchLogic {
  /// Mengonversi milidetik ke format digital Jam:Menit:Detik.Milidetik (00:00:00.00)
  static String formatWaktu(int milliseconds) {
    int ratusan = (milliseconds / 10).truncate() % 100;
    int detik = (milliseconds / 1000).truncate() % 60;
    int menit = (milliseconds / (1000 * 60)).truncate() % 60;
    int jam = (milliseconds / (1000 * 60 * 60)).truncate();

    String sJam = jam.toString().padLeft(2, '0');
    String sMenit = menit.toString().padLeft(2, '0');
    String sDetik = detik.toString().padLeft(2, '0');
    String sRatusan = ratusan.toString().padLeft(2, '0');

    return "$sJam:$sMenit:$sDetik.$sRatusan";
  }

  /// Menghitung selisih waktu dan menentukan pemenang bonus duel penataan rak
  static Map<String, dynamic> hitungPemenang({
    required int waktu1,
    required int waktu2,
    required String namaPekerja1,
    required String namaPekerja2,
  }) {
    final selisihDtk = ((waktu1 - waktu2).abs() / 1000).toStringAsFixed(2);

    if (waktu1 < waktu2) {
      return {
        "adaPemenang": true,
        "namaPemenang": namaPekerja1,
        "selisihDetik": selisihDtk,
        "pesan": "🏆 SELAMAT! $namaPekerja1 MENANG!\n"
            "Lebih cepat $selisihDtk detik dibanding lawannya.\n"
            "🎁 Berhak Mendapatkan Bonus Penataan Rak Gudang!",
      };
    } else if (waktu2 < waktu1) {
      return {
        "adaPemenang": true,
        "namaPemenang": namaPekerja2,
        "selisihDetik": selisihDtk,
        "pesan": "🏆 SELAMAT! $namaPekerja2 MENANG!\n"
            "Lebih cepat $selisihDtk detik dibanding lawannya.\n"
            "🎁 Berhak Mendapatkan Bonus Penataan Rak Gudang!",
      };
    } else {
      return {
        "adaPemenang": false,
        "namaPemenang": "Seri",
        "selisihDetik": "0.00",
        "pesan": "🤝 HASIL SERI! Kedua pekerja menyelesaikan penataan rak bersamaan!",
      };
    }
  }
}
