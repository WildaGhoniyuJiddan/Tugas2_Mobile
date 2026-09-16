import 'dart:async';
import 'package:flutter/material.dart';

/// Halaman Fun Racking Challenge: Stopwatch Split-Screen Duel (Menu 10 & Tab Stopwatch)
/// Konseptualisasi: Lomba kecepatan menata rak gudang antar 2 pekerja berhadiah bonus
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

  /// Format stopwatch ke format Jam:Menit:Detik.Milidetik (00:00:00.00)
  String _formatWaktu(int milliseconds) {
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
        final lapTime = _formatWaktu(_stopwatch1.elapsedMilliseconds);
        _laps1.insert(0, "Rak #${_laps1.length + 1}: $lapTime");
      });
    }
  }

  /// Catat Putaran / Rak (Lap) Pekerja 2
  void _catatRak2() {
    if (_stopwatch2.isRunning) {
      setState(() {
        final lapTime = _formatWaktu(_stopwatch2.elapsedMilliseconds);
        _laps2.insert(0, "Rak #${_laps2.length + 1}: $lapTime");
      });
    }
  }

  /// Memeriksa pemenang saat kedua pekerja selesai
  void _cekPemenang() {
    if (!_stopwatch1.isRunning &&
        !_stopwatch2.isRunning &&
        _stopwatch1.elapsedMilliseconds > 0 &&
        _stopwatch2.elapsedMilliseconds > 0) {
      final t1 = _stopwatch1.elapsedMilliseconds;
      final t2 = _stopwatch2.elapsedMilliseconds;
      final selisihDtk = ((t1 - t2).abs() / 1000).toStringAsFixed(2);

      if (t1 < t2) {
        _pesanPemenang =
            "🏆 SELAMAT! ${_namaCtrl1.text} MENANG!\n"
            "Lebih cepat $selisihDtk detik dibanding lawannya.\n"
            "🎁 Berhak Mendapatkan Bonus Penataan Rak Gudang!";
      } else if (t2 < t1) {
        _pesanPemenang =
            "🏆 SELAMAT! ${_namaCtrl2.text} MENANG!\n"
            "Lebih cepat $selisihDtk detik dibanding lawannya.\n"
            "🎁 Berhak Mendapatkan Bonus Penataan Rak Gudang!";
      } else {
        _pesanPemenang = "🤝 HASIL SERI! Kedua pekerja selesai tepat bersamaan!";
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fun Racking Challenge"),
        backgroundColor: Colors.indigo.shade800,
        foregroundColor: Colors.white,
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
                        color: Colors.amber,
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
            color: Colors.amber.shade50,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: _buildPanelPekerja(
              nomor: 1,
              warnaTema: Colors.amber.shade800,
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
          color: Colors.indigo.shade900,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "⚡ DUEL MODE",
                style: TextStyle(
                  color: Colors.amber,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                ),
                onPressed: _mulaiDuelBersama,
                icon: const Icon(Icons.flash_on, size: 18),
                label: const Text(
                  "MULAI DUEL BERSAMA",
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
            color: Colors.green.shade700,
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
            color: Colors.blue.shade50,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: _buildPanelPekerja(
              nomor: 2,
              warnaTema: Colors.blue.shade800,
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
    final waktuTeks = _formatWaktu(stopwatch.elapsedMilliseconds);

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
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: warnaTema, width: 2),
          ),
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
                backgroundColor: stopwatch.isRunning ? Colors.red : Colors.green,
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
                backgroundColor: Colors.indigo,
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
          const SizedBox(height: 4),
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
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Center(
                  child: Text(
                    laps[idx],
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
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
    final waktuTeks = _formatWaktu(_stopwatch1.elapsedMilliseconds);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Pencatat Waktu Operasional Gudang (Single Mode)",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            "Gunakan untuk mengukur efisiensi penataan rak atau pemindahan palet secara mandiri.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
          ),
          const SizedBox(height: 24),

          // Display Digital Besar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.blue, width: 3),
            ),
            child: Text(
              waktuTeks,
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'monospace',
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Tombol Kontrol
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _stopwatch1.isRunning ? Colors.red : Colors.green,
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
                  backgroundColor: Colors.indigo,
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
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: _laps1.length,
                itemBuilder: (context, idx) => Card(
                  child: ListTile(
                    dense: true,
                    leading: const Icon(Icons.timer_outlined, color: Colors.indigo),
                    title: Text(_laps1[idx]),
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
