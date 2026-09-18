import 'package:flutter_test/flutter_test.dart';
import 'package:aplikasi_stok_android/logic/kalkulator_umur_logic.dart';
import 'package:aplikasi_stok_android/logic/stopwatch_logic.dart';
import 'package:aplikasi_stok_android/logic/operasional_stok_logic.dart';

void main() {
  group('Pengujian OperasionalStokLogic', () {
    test('Penjumlahan dan Pengurangan Stok', () {
      final tambah = OperasionalStokLogic.hitungTambahStok(
        stokLama: 10,
        jumlah: 5,
        namaBarang: 'Beras',
        satuan: 'karung',
      );
      expect(tambah['sukses'], true);
      expect(tambah['stokBaru'], 15);

      final kurangValid = OperasionalStokLogic.hitungKurangStok(
        stokLama: 10,
        jumlah: 4,
        namaBarang: 'Beras',
        satuan: 'karung',
      );
      expect(kurangValid['sukses'], true);
      expect(kurangValid['stokBaru'], 6);

      final kurangInvalid = OperasionalStokLogic.hitungKurangStok(
        stokLama: 5,
        jumlah: 10,
        namaBarang: 'Beras',
        satuan: 'karung',
      );
      expect(kurangInvalid['sukses'], false);
    });

    test('Perkalian Box & Pembagian Rak (Bilangan Bulat & Desimal)', () {
      expect(OperasionalStokLogic.hitungPerkalianBox(10, 24), 240);
      expect(OperasionalStokLogic.hitungPerkalianBox(12.5, 4), 50);

      final bagi = OperasionalStokLogic.hitungPembagianRak(100, 6);
      expect(bagi['kapasitas'], 16);
      expect(bagi['sisa'], 4);

      final bagiDesimal = OperasionalStokLogic.hitungPembagianRak(10.5, 2);
      expect(bagiDesimal['kapasitas'], 5);
      expect(bagiDesimal['sisa'], 0.5);
    });

    test('Analisis Ganjil Genap', () {
      final genap = OperasionalStokLogic.analisisGanjilGenap(20, 'pcs');
      expect(genap['isGenap'], true);
      expect(genap['label'], 'GENAP');

      final ganjil = OperasionalStokLogic.analisisGanjilGenap(17, 'pcs');
      expect(ganjil['isGenap'], false);
      expect(ganjil['label'], 'GANJIL');
    });

    test('Total Angka dan Akumulasi Digit', () {
      final res = OperasionalStokLogic.hitungTotalDanStatistik('15, 30, 45, 20, 10');
      expect(res, isNotNull);
      expect(res!['jumlahData'], 5);
      expect(res['total'], 120.0);
      expect(res['rataRata'], 24.0);
      expect(res['maks'], 45.0);
      expect(res['min'], 10.0);
    });
  });

  group('Pengujian KalkulatorUmurLogic', () {
    test('Anchor ke Jam 00:00:00', () {
      final tgl = DateTime(2023, 8, 17, 14, 30, 45);
      final tgl00 = KalkulatorUmurLogic.anchorKePukul00(tgl);
      expect(tgl00.hour, 0);
      expect(tgl00.minute, 0);
      expect(tgl00.second, 0);
      expect(tgl00.day, 17);
      expect(tgl00.month, 8);
      expect(tgl00.year, 2023);
    });

    test('Evaluasi FIFO Shelf-Life', () {
      final baru = KalkulatorUmurLogic.evaluasiShelfLife(25);
      expect(baru['isWarning'], false);

      final menengah = KalkulatorUmurLogic.evaluasiShelfLife(60);
      expect(menengah['isWarning'], false);

      final tua = KalkulatorUmurLogic.evaluasiShelfLife(100);
      expect(tua['isWarning'], true);
    });
  });

  group('Pengujian StopwatchLogic', () {
    test('Format Digital 00:00:00.00', () {
      // 1 jam + 2 menit + 3 detik + 450 milidetik = 3723450 ms
      const ms = (1 * 3600 + 2 * 60 + 3) * 1000 + 450;
      expect(StopwatchLogic.formatWaktu(ms), '01:02:03.45');
    });

    test('Penentuan Pemenang Duel', () {
      final duel = StopwatchLogic.hitungPemenang(
        waktu1: 15000,
        waktu2: 17500,
        namaPekerja1: 'Slamet',
        namaPekerja2: 'Budi',
      );
      expect(duel['adaPemenang'], true);
      expect(duel['namaPemenang'], 'Slamet');
      expect(duel['selisihDetik'], '2.50');
    });
  });
}
