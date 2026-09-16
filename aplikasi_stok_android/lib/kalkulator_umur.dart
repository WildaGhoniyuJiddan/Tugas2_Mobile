import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Halaman Kalkulator Umur & Durasi Waktu Presisi Detik (Menu 9)
/// Sesuai Kriteria Penugasan & Revisi PRD v2.2.0:
/// - Input praktis: HANYA TANGGAL (tanpa perlu input jam & menit).
/// - Waktu otomatis dimulai dari pukul 00:00:00 pada tanggal yang dipilih.
/// - Menghasilkan konversi detail: Tahun, Bulan, Hari, Jam, Menit, Detik.
/// - Live Realtime Ticker berdetak setiap 1 detik.
/// - Mendukung Dual-Mode: (1) Profil Staf Gudang & (2) Usia Batch Barang.
class HalamanKalkulatorUmur extends StatefulWidget {
  const HalamanKalkulatorUmur({super.key});

  @override
  State<HalamanKalkulatorUmur> createState() => _HalamanKalkulatorUmurState();
}

class _HalamanKalkulatorUmurState extends State<HalamanKalkulatorUmur> {
  // Mode: 0 = Staf Gudang (Tanggal Lahir), 1 = Batch Barang (Tanggal Produksi)
  int _modeIndex = 0;

  // Tanggal default: Contoh tanggal lahir 15 Mei 2003
  DateTime _tanggalDipilih = DateTime(2003, 5, 15);

  final TextEditingController _namaCtrl =
      TextEditingController(text: "Wilda Ghoniyu");

  // Timer realtime 1 detik
  Timer? _tickerTimer;
  DateTime _waktuSekarang = DateTime.now();

  @override
  void initState() {
    super.initState();
    // Memulai timer berdetak setiap 1000 milidetik (1 detik)
    _tickerTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _waktuSekarang = DateTime.now();
        });
      }
    });
  }

  @override
  void dispose() {
    _tickerTimer?.cancel();
    _namaCtrl.dispose();
    super.dispose();
  }

  /// Membuka DatePicker untuk memilih tanggal saja
  Future<void> _pilihTanggal(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _tanggalDipilih,
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _tanggalDipilih = picked;
      });
    }
  }

  /// Menghitung perbedaan waktu presisi dari jam 00:00:00 ke waktu sekarang
  Map<String, int> _hitungDurasiRinci(DateTime tglAwal00) {
    DateTime now = _waktuSekarang;

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
  Map<String, int> _hitungCountdownUltah(DateTime tglLahir) {
    final now = _waktuSekarang;
    DateTime nextBirthday = DateTime(now.year, tglLahir.month, tglLahir.day);

    if (nextBirthday.isBefore(now)) {
      nextBirthday = DateTime(now.year + 1, tglLahir.month, tglLahir.day);
    }

    final diff = nextBirthday.difference(now);
    final days = diff.inDays;
    final hours = diff.inHours % 24;
    final minutes = diff.inMinutes % 60;
    final seconds = diff.inSeconds % 60;

    return {
      "days": days,
      "hours": hours,
      "minutes": minutes,
      "seconds": seconds,
    };
  }

  @override
  Widget build(BuildContext context) {
    // Tanggal acuan di-anchor ke jam 00:00:00 pada tanggal yang dipilih
    final tglAwal00 = DateTime(
      _tanggalDipilih.year,
      _tanggalDipilih.month,
      _tanggalDipilih.day,
      0,
      0,
      0,
    );

    final durasi = _hitungDurasiRinci(tglAwal00);
    final totalDiff = _waktuSekarang.difference(tglAwal00);
    final ultah = _hitungCountdownUltah(_tanggalDipilih);

    final formatTglDipilih =
        DateFormat('d MMMM yyyy', 'id_ID').format(_tanggalDipilih);
    final fNum = NumberFormat('#,###', 'id_ID');

    final isModeStaf = _modeIndex == 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Kalkulator Umur & Waktu Detil"),
        backgroundColor: Colors.purple.shade700,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Pilihan Mode (Segmented Button)
            SegmentedButton<int>(
              segments: const [
                ButtonSegment(
                  value: 0,
                  icon: Icon(Icons.person),
                  label: Text("Profil Staf Gudang"),
                ),
                ButtonSegment(
                  value: 1,
                  icon: Icon(Icons.inventory_2),
                  label: Text("Batch Usia Barang"),
                ),
              ],
              selected: {_modeIndex},
              onSelectionChanged: (val) {
                setState(() {
                  _modeIndex = val.first;
                  if (_modeIndex == 1) {
                    _namaCtrl.text = "Batch Minyak Goreng 2L";
                    _tanggalDipilih = DateTime.now().subtract(const Duration(days: 45));
                  } else {
                    _namaCtrl.text = "Wilda Ghoniyu";
                    _tanggalDipilih = DateTime(2003, 5, 15);
                  }
                });
              },
            ),

            const SizedBox(height: 16),

            // Card Form Input Tanggal Saja
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _namaCtrl,
                      decoration: InputDecoration(
                        labelText: isModeStaf ? "Nama Staf Gudang" : "Nama Produk / Batch Barang",
                        prefixIcon: Icon(isModeStaf ? Icons.badge : Icons.label),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 14),

                    Text(
                      isModeStaf
                          ? "Tanggal Lahir Staf (Dihitung mulai pk. 00:00:00):"
                          : "Tanggal Pembuatan/Masuk Batch (Mulai pk. 00:00:00):",
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 6),

                    InkWell(
                      onTap: () => _pilihTanggal(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.purple.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.purple.shade200),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.calendar_today, color: Colors.purple),
                                const SizedBox(width: 10),
                                Text(
                                  formatTglDipilih,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            const Text(
                              "Ganti Tanggal",
                              style: TextStyle(
                                color: Colors.purple,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "*Acuan waktu otomatis dimulai tepat pada pukul 00:00:00 di tanggal ini.",
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Banner Ticker Realtime Live Counter
            Card(
              color: Colors.purple.shade900,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.timer, color: Colors.amber, size: 20),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            isModeStaf
                                ? "LIVE COUNTER UMUR STAF (REALTIME)"
                                : "LIVE MASA SIMPAN BATCH (REALTIME)",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.amber,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.8,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Kotak Angka Tahun, Bulan, Hari (Otomatis menyesuaikan lebar)
                    Row(
                      children: [
                        Expanded(child: _buildBoxWaktu("${durasi['years']}", "Tahun")),
                        const SizedBox(width: 8),
                        Expanded(child: _buildBoxWaktu("${durasi['months']}", "Bulan")),
                        const SizedBox(width: 8),
                        Expanded(child: _buildBoxWaktu("${durasi['days']}", "Hari")),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Kotak Angka Jam, Menit, Detik (Detik Berjalan Live)
                    Row(
                      children: [
                        Expanded(child: _buildBoxWaktu("${durasi['hours']}".padLeft(2, '0'), "Jam")),
                        const SizedBox(width: 8),
                        Expanded(child: _buildBoxWaktu("${durasi['minutes']}".padLeft(2, '0'), "Menit")),
                        const SizedBox(width: 8),
                        Expanded(child: _buildBoxWaktu("${durasi['seconds']}".padLeft(2, '0'), "Detik (Live)", isLive: true)),
                      ],
                    ),

                    const SizedBox(height: 14),
                    Text(
                      "${_namaCtrl.text.isEmpty ? 'Subjek' : _namaCtrl.text} telah ${isModeStaf ? 'hidup' : 'disimpan'} selama:\n"
                      "${durasi['years']} Tahun, ${durasi['months']} Bulan, ${durasi['days']} Hari, "
                      "${durasi['hours']} Jam, ${durasi['minutes']} Menit, ${durasi['seconds']} Detik",
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.4),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Card Statistik Akumulasi
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Statistik Akumulasi Waktu Keseluruhan:",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    const Divider(height: 18),
                    _itemStatistik("Total Hari", "${fNum.format(totalDiff.inDays)} Hari"),
                    _itemStatistik("Total Jam", "${fNum.format(totalDiff.inHours)} Jam"),
                    _itemStatistik("Total Menit", "${fNum.format(totalDiff.inMinutes)} Menit"),
                    _itemStatistik("Total Detik", "${fNum.format(totalDiff.inSeconds)} Detik", isHighlight: true),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Bagian Khusus Mode
            if (isModeStaf)
              Card(
                color: Colors.pink.shade50,
                elevation: 1,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      const Icon(Icons.cake, color: Colors.pink, size: 36),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Countdown Ulang Tahun Berikutnya:",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.pink,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              "${ultah['days']} Hari, ${ultah['hours']} Jam, ${ultah['minutes']} Menit, ${ultah['seconds']} Detik lagi!",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.pink.shade800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              Card(
                color: Colors.teal.shade50,
                elevation: 1,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      Icon(
                        totalDiff.inDays > 90
                            ? Icons.warning_amber_rounded
                            : Icons.check_circle_outline,
                        color: totalDiff.inDays > 90 ? Colors.red : Colors.teal,
                        size: 36,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Status Kontrol Mutu FIFO Gudang:",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: totalDiff.inDays > 90 ? Colors.red : Colors.teal,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              totalDiff.inDays <= 30
                                  ? "🟢 Produk Masih Baru (Usia < 30 Hari). Aman disimpan."
                                  : totalDiff.inDays <= 90
                                      ? "🟡 Usia Simpan Menengah (Prioritaskan pengiriman FIFO)."
                                      : "🔴 Usia Simpan Tua (> 90 Hari). Segera keluarkan ke display toko!",
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBoxWaktu(String nilai, String label, {bool isLive = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      decoration: BoxDecoration(
        color: isLive ? Colors.amber : Colors.white.withAlpha(25),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isLive ? Colors.amber : Colors.white30,
          width: isLive ? 1.5 : 1.0,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              nilai,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: isLive ? Colors.black : Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 2),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: isLive ? Colors.black87 : Colors.white70,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _itemStatistik(String label, String nilai, {bool isHighlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            nilai,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isHighlight ? Colors.purple.shade700 : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
