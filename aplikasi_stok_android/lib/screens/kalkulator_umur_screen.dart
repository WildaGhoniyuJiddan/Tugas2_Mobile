import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../logic/kalkulator_umur_logic.dart';
import '../styles/app_colors.dart';
import '../styles/app_styles.dart';
import '../styles/app_text_styles.dart';

/// Halaman Kalkulator Umur & Durasi Waktu Presisi Detik (Menu 9)
/// Logika komputasi dipisahkan ke KalkulatorUmurLogic.
/// Styling dan desain visual dipisahkan ke AppStyles & AppColors (Tema Lavender).
class HalamanKalkulatorUmur extends StatefulWidget {
  const HalamanKalkulatorUmur({super.key});

  @override
  State<HalamanKalkulatorUmur> createState() => _HalamanKalkulatorUmurState();
}

class _HalamanKalkulatorUmurState extends State<HalamanKalkulatorUmur> {
  // Mode: 0 = Staf Gudang (Tanggal Lahir), 1 = Batch Barang (Tanggal Masuk/Produksi)
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

  @override
  Widget build(BuildContext context) {
    // 1. Logika Anchor ke jam 00:00:00 menggunakan KalkulatorUmurLogic
    final tglAwal00 = KalkulatorUmurLogic.anchorKePukul00(_tanggalDipilih);

    // 2. Logika Perhitungan Durasi Detail & Countdown menggunakan KalkulatorUmurLogic
    final durasi = KalkulatorUmurLogic.hitungDurasiRinci(tglAwal00, _waktuSekarang);
    final totalDiff = _waktuSekarang.difference(tglAwal00);
    final ultah = KalkulatorUmurLogic.hitungCountdownUltah(_tanggalDipilih, _waktuSekarang);
    final evaluasiStok = KalkulatorUmurLogic.evaluasiShelfLife(totalDiff.inDays);

    final formatTglDipilih =
        DateFormat('d MMMM yyyy', 'id_ID').format(_tanggalDipilih);
    final fNum = NumberFormat('#,###', 'id_ID');

    final isModeStaf = _modeIndex == 0;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Kalkulator Umur & Waktu Detil", style: AppTextStyles.appBarTitle),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textDark,
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
            Container(
              decoration: AppStyles.cardBoxDecoration(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _namaCtrl,
                    decoration: AppStyles.inputDecoration(
                      labelText: isModeStaf ? "Nama Staf Gudang" : "Nama Produk / Batch Barang",
                      prefixIcon: isModeStaf ? Icons.badge : Icons.label,
                    ),
                  ),
                  const SizedBox(height: 14),

                  Text(
                    isModeStaf
                        ? "Tanggal Lahir Staf (Dihitung mulai pk. 00:00:00):"
                        : "Tanggal Pembuatan/Masuk Batch (Mulai pk. 00:00:00):",
                    style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textDark),
                  ),
                  const SizedBox(height: 8),

                  InkWell(
                    onTap: () => _pilihTanggal(context),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.lavenderAccent),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.calendar_today, color: AppColors.primary),
                              const SizedBox(width: 10),
                              Text(
                                formatTglDipilih,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: AppColors.primaryDark,
                                ),
                              ),
                            ],
                          ),
                          const Text(
                            "Ganti Tanggal",
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "*Acuan waktu otomatis dimulai tepat pada pukul 00:00:00 di tanggal ini.",
                    style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Banner Ticker Realtime Live Counter
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primaryDark, Color(0xFF311B92)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryDark.withAlpha(80),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.timer, color: AppColors.secondary, size: 20),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          isModeStaf
                              ? "LIVE COUNTER UMUR STAF (REALTIME)"
                              : "LIVE MASA SIMPAN BATCH (REALTIME)",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: AppColors.secondary,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.8,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Kotak Angka Tahun, Bulan, Hari
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

            const SizedBox(height: 16),

            // Card Statistik Akumulasi
            Container(
              decoration: AppStyles.cardBoxDecoration(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Statistik Akumulasi Waktu Keseluruhan:",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textDark),
                  ),
                  const Divider(height: 18),
                  _itemStatistik("Total Hari", "${fNum.format(totalDiff.inDays)} Hari"),
                  _itemStatistik("Total Jam", "${fNum.format(totalDiff.inHours)} Jam"),
                  _itemStatistik("Total Menit", "${fNum.format(totalDiff.inMinutes)} Menit"),
                  _itemStatistik("Total Detik", "${fNum.format(totalDiff.inSeconds)} Detik", isHighlight: true),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Bagian Khusus Mode Staf / Mode Batch
            if (isModeStaf)
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFFCE4EC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFF8BBD0)),
                ),
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
              )
            else
              Container(
                decoration: BoxDecoration(
                  color: evaluasiStok['isWarning'] ? AppColors.dangerLight : AppColors.accentLight,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: evaluasiStok['isWarning'] ? AppColors.danger : AppColors.accent,
                  ),
                ),
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    Icon(
                      evaluasiStok['isWarning']
                          ? Icons.warning_amber_rounded
                          : Icons.check_circle_outline,
                      color: evaluasiStok['isWarning'] ? AppColors.danger : AppColors.accent,
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
                              color: evaluasiStok['isWarning'] ? AppColors.danger : AppColors.accent,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "${evaluasiStok['status']}\n${evaluasiStok['rekomendasi']}",
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textDark,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
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
        color: isLive ? AppColors.secondary : Colors.white.withAlpha(25),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isLive ? AppColors.secondary : Colors.white30,
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
              style: const TextStyle(fontSize: 14, color: AppColors.textDark),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            nilai,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isHighlight ? AppColors.primary : AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }
}
