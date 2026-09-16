import 'dart:async';
import 'package:flutter/material.dart';
import '../logic/stopwatch_logic.dart';
import '../styles/app_colors.dart';
import '../styles/app_styles.dart';
import '../styles/app_text_styles.dart';

/// Halaman Fun Racking Challenge: Stopwatch Split-Screen Duel (Menu 10 & Tab Stopwatch)
/// Konsep: Lomba kecepatan menata rak gudang antar 2 pekerja berhadiah bonus
/// Menggunakan StopwatchLogic untuk pemisahan logika, dan AppStyles/AppColors untuk desain visual.
class HalamanStopwatchChallenge extends StatefulWidget {
  const HalamanStopwatchChallenge({super.key});

  @override
  State<HalamanStopwatchChallenge> createState() =>
      _HalamanStopwatchChallengeState();
}

class _HalamanStopwatchChallengeState extends State<HalamanStopwatchChallenge> {
  // Mode: true = Split-Screen 2 Pekerja (Duel), false = Single Mode
  bool _isSplitScreen = true;

  // State Stopwatch Pekerja 1
  final Stopwatch _stopwatch1 = Stopwatch();
  final List<String> _laps1 = [];
  final TextEditingController _namaCtrl1 =
      TextEditingController(text: "Pekerja 1 (Slamet)");

  // State Stopwatch Pekerja 2
  final Stopwatch _stopwatch2 = Stopwatch();
  final List<String> _laps2 = [];
  final TextEditingController _namaCtrl2 =
      TextEditingController(text: "Pekerja 2 (Budi)");

  Timer? _timerTick;
  String? _pesanPemenang;
  int _countdownDuel = 0;
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
    // Timer pembaruan display setiap 30 milidetik
    _timerTick = Timer.periodic(const Duration(milliseconds: 30), (timer) {
      if (mounted) {
        if (_stopwatch1.isRunning || _stopwatch2.isRunning) {
          setState(() {});
        }
      }
    });
  }

  @override
  void dispose() {
    _timerTick?.cancel();
    _countdownTimer?.cancel();
    _namaCtrl1.dispose();
    _namaCtrl2.dispose();
    super.dispose();
  }

  /// Tombol Mulai Duel Bersama (3.. 2.. 1.. GO!)
  void _mulaiDuelBersama() {
    setState(() {
      _countdownDuel = 3;
      _pesanPemenang = null;
      _stopwatch1.reset();
      _stopwatch2.reset();
      _laps1.clear();
      _laps2.clear();
    });

    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _countdownDuel--;
          if (_countdownDuel <= 0) {
            timer.cancel();
            _stopwatch1.start();
            _stopwatch2.start();
          }
        });
      }
    });
  }

  /// Catat Putaran / Rak (Lap) Pekerja 1
  void _catatRak1() {
    if (_stopwatch1.isRunning) {
      setState(() {
        final lapTime = StopwatchLogic.formatWaktu(_stopwatch1.elapsedMilliseconds);
        _laps1.insert(0, "Rak #${_laps1.length + 1}: $lapTime");
      });
    }
  }

  /// Catat Putaran / Rak (Lap) Pekerja 2
  void _catatRak2() {
    if (_stopwatch2.isRunning) {
      setState(() {
        final lapTime = StopwatchLogic.formatWaktu(_stopwatch2.elapsedMilliseconds);
        _laps2.insert(0, "Rak #${_laps2.length + 1}: $lapTime");
      });
    }
  }

  /// Memeriksa pemenang saat kedua pekerja selesai menggunakan StopwatchLogic
  void _cekPemenang() {
    if (!_stopwatch1.isRunning &&
        !_stopwatch2.isRunning &&
        _stopwatch1.elapsedMilliseconds > 0 &&
        _stopwatch2.elapsedMilliseconds > 0) {
      final hasil = StopwatchLogic.hitungPemenang(
        waktu1: _stopwatch1.elapsedMilliseconds,
        waktu2: _stopwatch2.elapsedMilliseconds,
        namaPekerja1: _namaCtrl1.text,
        namaPekerja2: _namaCtrl2.text,
      );
      _pesanPemenang = hasil['pesan'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Fun Racking Challenge", style: AppTextStyles.appBarTitle),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textDark,
        actions: [
          // Toggle Split-Screen / Single Mode
          IconButton(
            tooltip: _isSplitScreen ? "Ubah ke Single Mode" : "Ubah ke Split Screen 2 Pekerja",
            icon: Icon(_isSplitScreen ? Icons.splitscreen : Icons.crop_portrait),
            onPressed: () {
              setState(() {
                _isSplitScreen = !_isSplitScreen;
              });
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          _isSplitScreen ? _buildSplitScreenView() : _buildSingleScreenView(),

          // Overlay Countdown (3.. 2.. 1.. GO!)
          if (_countdownDuel > 0)
            Container(
              color: Colors.black87,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "PERSIAPAN DUEL MENATA RAK!",
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "$_countdownDuel",
                      style: const TextStyle(
                        fontSize: 90,
                        fontWeight: FontWeight.bold,
                        color: AppColors.secondary,
                      ),
                    ),
                    const Text(
                      "SIAP...!",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ==========================================================
  // TAMPILAN SPLIT-SCREEN DUEL 2 PEKERJA
  // ==========================================================
  Widget _buildSplitScreenView() {
    return Column(
      children: [
        // Panel Atas: Pekerja 1
        Expanded(
          child: Container(
            color: AppColors.secondaryLight,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: _buildPanelPekerja(
              nomor: 1,
              warnaTema: AppColors.secondary,
              namaCtrl: _namaCtrl1,
              stopwatch: _stopwatch1,
              laps: _laps1,
              onLap: _catatRak1,
              onStopTapped: () {
                setState(() {
                  _stopwatch1.stop();
                  _cekPemenang();
                });
              },
            ),
          ),
        ),

        // Divider Sentral: Tombol Mulai Duel Bersama & Banner Pemenang
        Container(
          color: AppColors.primaryDark,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.bolt, color: AppColors.secondary, size: 18),
                  SizedBox(width: 4),
                  Text(
                    "DUEL RAK",
                    style: TextStyle(
                      color: AppColors.secondary,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                ),
                onPressed: _mulaiDuelBersama,
                icon: const Icon(Icons.flash_on, size: 18),
                label: const Text(
                  "MULAI BERSAMA",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ),
              IconButton(
                tooltip: "Reset Keduanya",
                icon: const Icon(Icons.refresh, color: Colors.white70),
                onPressed: () {
                  setState(() {
                    _stopwatch1.reset();
                    _stopwatch2.reset();
                    _laps1.clear();
                    _laps2.clear();
                    _pesanPemenang = null;
                  });
                },
              ),
            ],
          ),
        ),

        // Pengumuman Pemenang (Jika Ada)
        if (_pesanPemenang != null)
          Container(
            width: double.infinity,
            color: AppColors.success,
            padding: const EdgeInsets.all(10),
            child: Text(
              _pesanPemenang!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),

        // Panel Bawah: Pekerja 2
        Expanded(
          child: Container(
            color: AppColors.primaryLight,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: _buildPanelPekerja(
              nomor: 2,
              warnaTema: AppColors.primary,
              namaCtrl: _namaCtrl2,
              stopwatch: _stopwatch2,
              laps: _laps2,
              onLap: _catatRak2,
              onStopTapped: () {
                setState(() {
                  _stopwatch2.stop();
                  _cekPemenang();
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPanelPekerja({
    required int nomor,
    required Color warnaTema,
    required TextEditingController namaCtrl,
    required Stopwatch stopwatch,
    required List<String> laps,
    required VoidCallback onLap,
    required VoidCallback onStopTapped,
  }) {
    final waktuTeks = StopwatchLogic.formatWaktu(stopwatch.elapsedMilliseconds);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Baris Header: Nama Pekerja
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 12,
              backgroundColor: warnaTema,
              child: Text(
                "$nomor",
                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 8),
            IntrinsicWidth(
              child: TextField(
                controller: namaCtrl,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: warnaTema,
                  fontSize: 14,
                ),
                decoration: const InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  border: UnderlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),

        // Display Digital Waktu
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: AppStyles.digitalBoxDecoration(borderColor: warnaTema),
          child: Text(
            waktuTeks,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'monospace',
            ),
          ),
        ),
        const SizedBox(height: 8),

        // Tombol Kontrol
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Start / Stop
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: stopwatch.isRunning ? AppColors.danger : AppColors.success,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              ),
              onPressed: () {
                setState(() {
                  if (stopwatch.isRunning) {
                    onStopTapped();
                  } else {
                    stopwatch.start();
                  }
                });
              },
              icon: Icon(stopwatch.isRunning ? Icons.stop : Icons.play_arrow, size: 16),
              label: Text(stopwatch.isRunning ? "Stop" : "Mulai"),
            ),
            const SizedBox(width: 8),

            // Catat Rak (Lap)
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryDark,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              ),
              onPressed: stopwatch.isRunning ? onLap : null,
              icon: const Icon(Icons.flag, size: 16),
              label: const Text("Catat Rak"),
            ),
            const SizedBox(width: 8),

            // Reset
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              ),
              onPressed: () {
                setState(() {
                  stopwatch.reset();
                  laps.clear();
                });
              },
              child: const Text("Reset"),
            ),
          ],
        ),

        // Riwayat Lap Ringkas
        if (laps.isNotEmpty) ...[
          const SizedBox(height: 6),
          SizedBox(
            height: 38,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: laps.length,
              itemBuilder: (context, idx) => Container(
                margin: const EdgeInsets.only(right: 6),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppColors.border),
                ),
                child: Center(
                  child: Text(
                    laps[idx],
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textDark),
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  // ==========================================================
  // TAMPILAN SINGLE MODE (1 STOPWATCH)
  // ==========================================================
  Widget _buildSingleScreenView() {
    final waktuTeks = StopwatchLogic.formatWaktu(_stopwatch1.elapsedMilliseconds);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Pencatat Waktu Operasional Gudang (Single Mode)",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textDark),
          ),
          const SizedBox(height: 8),
          const Text(
            "Gunakan untuk mengukur efisiensi penataan rak atau pemindahan palet secara mandiri.",
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textMuted, fontSize: 13),
          ),
          const SizedBox(height: 24),

          // Display Digital Besar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: AppStyles.digitalBoxDecoration(borderColor: AppColors.primary),
            child: Text(
              waktuTeks,
              style: AppTextStyles.digitalClockLarge,
            ),
          ),
          const SizedBox(height: 24),

          // Tombol Kontrol
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _stopwatch1.isRunning ? AppColors.danger : AppColors.success,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                onPressed: () {
                  setState(() {
                    if (_stopwatch1.isRunning) {
                      _stopwatch1.stop();
                    } else {
                      _stopwatch1.start();
                    }
                  });
                },
                icon: Icon(_stopwatch1.isRunning ? Icons.pause : Icons.play_arrow),
                label: Text(_stopwatch1.isRunning ? "Jeda" : "Mulai"),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                onPressed: _stopwatch1.isRunning ? _catatRak1 : null,
                icon: const Icon(Icons.flag),
                label: const Text("Catat Rak (Lap)"),
              ),
              const SizedBox(width: 12),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                onPressed: () {
                  setState(() {
                    _stopwatch1.reset();
                    _laps1.clear();
                  });
                },
                child: const Text("Reset"),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Daftar Catatan Putaran Lap
          if (_laps1.isNotEmpty) ...[
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Catatan Waktu per Rak:",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textDark),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: _laps1.length,
                itemBuilder: (context, idx) => Container(
                  margin: const EdgeInsets.only(bottom: 6),
                  decoration: AppStyles.cardBoxDecoration(),
                  child: ListTile(
                    dense: true,
                    leading: const Icon(Icons.timer_outlined, color: AppColors.primary),
                    title: Text(_laps1[idx], style: const TextStyle(fontWeight: FontWeight.w600)),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
