import 'package:flutter/material.dart';
import 'beranda.dart';
import 'stopwatch_challenge.dart';
import 'bantuan.dart';
import 'session_manager.dart';
import 'main.dart';

/// Wrapper Layar Utama dengan Bottom Navigation Bar
/// 1. Beranda (Menu Fitur)
/// 2. Stopwatch (Racking Challenge)
/// 3. Pusat Bantuan (Help Center)
/// 4. Logout Sesi (dengan dialog konfirmasi)
class MainNavigationScreen extends StatefulWidget {
  final String username;
  final String namaLengkap;

  const MainNavigationScreen({
    super.key,
    required this.username,
    required this.namaLengkap,
  });

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      HalamanBeranda(
        username: widget.username,
        namaLengkap: widget.namaLengkap,
      ),
      const HalamanStopwatchChallenge(),
      const HalamanBantuan(),
      const SizedBox(), // Placeholder untuk tab logout
    ];
  }

  /// Menampilkan dialog konfirmasi saat pengguna memilih tab Logout
  void _konfirmasiLogout() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.logout, color: Colors.red),
            SizedBox(width: 8),
            Text("Konfirmasi Logout"),
          ],
        ),
        content: const Text(
          "Apakah Anda yakin ingin mengakhiri sesi dan keluar dari aplikasi WarehouseSmart?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              Navigator.pop(ctx); // Tutup dialog
              await SessionManager.hapusSesi(); // Hapus SharedPreferences

              if (mounted) {
                // Kembali ke halaman Login & hapus seluruh tumpukan halaman
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const HalamanLogin()),
                  (route) => false,
                );
              }
            },
            child: const Text("Ya, Logout"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.blue.shade800,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          if (index == 3) {
            // Tab Logout dipilih -> Tampilkan dialog konfirmasi
            _konfirmasiLogout();
          } else {
            setState(() {
              _currentIndex = index;
            });
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: "Beranda",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timer_outlined),
            activeIcon: Icon(Icons.timer),
            label: "Stopwatch",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.help_outline),
            activeIcon: Icon(Icons.help),
            label: "Bantuan",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout),
            label: "Logout",
          ),
        ],
      ),
    );
  }
}
