import 'package:flutter_test/flutter_test.dart';
import 'package:aplikasi_stok_android/logic/penanggalan_logic.dart';

void main() {
  group('Pengujian Logika Penanggalan & Budaya Helper', () {
    test('Konversi Tanggal Bersejarah 17 Agustus 1945', () {
      final tglKemerdekaan = DateTime(1945, 8, 17);

      // 1. Hijriah: Tepat 9 Ramadhan 1364 H
      final hijri = PenanggalanLogic.konversiKeHijriah(tglKemerdekaan);
      expect(hijri['tanggal'], 9);
      expect(hijri['bulan'], 'Ramadhan');
      expect(hijri['tahun'], 1364);
      expect(hijri['formatLengkap'], '9 Ramadhan 1364 H');

      // 2. Weton Jawa: Jumat Legi, Nilai Neptu 6 + 5 = 11
      final weton = PenanggalanLogic.konversiKeWeton(tglKemerdekaan);
      expect(weton['hari'], 'Jumat');
      expect(weton['pasaran'], 'Legi');
      expect(weton['neptuHari'], 6);
      expect(weton['neptuPasaran'], 5);
      expect(weton['totalNeptu'], 11);
      expect(weton['wetonLengkap'], 'Jumat Legi');

      // 3. Saka Bali: Tahun 1867 Saka, Wuku Wayang
      final saka = PenanggalanLogic.konversiKeSakaBali(tglKemerdekaan);
      expect(saka['tahunSaka'], '1867 Saka');
      expect(saka['wuku'], 'Wayang');
    });

    test('Pengujian Siklus Pasaran Jawa 5 Hari Berurutan', () {
      expect(PenanggalanLogic.konversiKeWeton(DateTime(1945, 8, 17))['pasaran'], 'Legi');
      expect(PenanggalanLogic.konversiKeWeton(DateTime(1945, 8, 18))['pasaran'], 'Pahing');
      expect(PenanggalanLogic.konversiKeWeton(DateTime(1945, 8, 19))['pasaran'], 'Pon');
      expect(PenanggalanLogic.konversiKeWeton(DateTime(1945, 8, 20))['pasaran'], 'Wage');
      expect(PenanggalanLogic.konversiKeWeton(DateTime(1945, 8, 21))['pasaran'], 'Kliwon');
    });
  });
}
