import 'package:flutter_test/flutter_test.dart';
import 'package:aplikasi_stok_android/penanggalan_helper.dart';

void main() {
  group('Pengujian Logika Penanggalan & Budaya Helper', () {
    test('Konversi Tanggal Bersejarah 17 Agustus 1945', () {
      final tglKemerdekaan = DateTime(1945, 8, 17);

      // 1. Hijriah: Tepat 9 Ramadhan 1364 H
      final hijri = PenanggalanHelper.konversiKeHijriah(tglKemerdekaan);
      expect(hijri['tanggal'], 9);
      expect(hijri['bulan'], 'Ramadhan');
      expect(hijri['tahun'], 1364);
      expect(hijri['formatLengkap'], '9 Ramadhan 1364 H');

      // 2. Weton Jawa: Jumat Legi, Nilai Neptu 6 + 5 = 11
      final weton = PenanggalanHelper.konversiKeWeton(tglKemerdekaan);
      expect(weton['hari'], 'Jumat');
      expect(weton['pasaran'], 'Legi');
      expect(weton['neptuHari'], 6);
      expect(weton['neptuPasaran'], 5);
      expect(weton['totalNeptu'], 11);
      expect(weton['wetonLengkap'], 'Jumat Legi');

      // 3. Saka Bali: Tahun 1867 Saka, Wuku Wayang
      final saka = PenanggalanHelper.konversiKeSakaBali(tglKemerdekaan);
      expect(saka['tahunSaka'], '1867 Saka');
      expect(saka['wuku'], 'Wayang');
    });

    test('Pengujian Siklus Pasaran Jawa 5 Hari Berurutan', () {
      // 17 Agustus 1945 = Legi
      // 18 Agustus 1945 = Pahing
      // 19 Agustus 1945 = Pon
      // 20 Agustus 1945 = Wage
      // 21 Agustus 1945 = Kliwon
      expect(PenanggalanHelper.konversiKeWeton(DateTime(1945, 8, 17))['pasaran'], 'Legi');
      expect(PenanggalanHelper.konversiKeWeton(DateTime(1945, 8, 18))['pasaran'], 'Pahing');
      expect(PenanggalanHelper.konversiKeWeton(DateTime(1945, 8, 19))['pasaran'], 'Pon');
      expect(PenanggalanHelper.konversiKeWeton(DateTime(1945, 8, 20))['pasaran'], 'Wage');
      expect(PenanggalanHelper.konversiKeWeton(DateTime(1945, 8, 21))['pasaran'], 'Kliwon');
    });
  });
}
