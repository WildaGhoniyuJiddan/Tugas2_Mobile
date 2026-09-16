import 'package:flutter/material.dart';
import '../styles/app_colors.dart';
import '../database/session_manager.dart';
import 'beranda_screen.dart';
import 'stopwatch_challenge_screen.dart';
import 'bantuan_screen.dart';
import 'auth/login_screen.dart';

/// Wrapper layar utama dengan navigasi bawah.
/// 1. Beranda (Dashboard Menu Fitur)
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
      const SizedBox(), // Placeholder tab logout
    ];
  }

  /// Menampilkan dialog konfirmasi saat pengguna memilih tab Logout
  void _konfirmasiLogout() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.logout, color: AppColors.danger),
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
              backgroundColor: AppColors.danger,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              Navigator.pop(ctx);
              await SessionManager.hapusSesi();

              if (mounted) {
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
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        backgroundColor: AppColors.surface,
        indicatorColor: AppColors.primaryLight,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        height: 72,
        onTap: (index) {
          if (index == 3) {
            _konfirmasiLogout();
          } else {
            setState(() {
              _currentIndex = index;
            });
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: "Beranda",
          ),
          NavigationDestination(
            icon: Icon(Icons.timer_outlined),
            selectedIcon: Icon(Icons.timer_rounded),
            label: "Stopwatch",
          ),
          NavigationDestination(
            icon: Icon(Icons.help_outline),
            selectedIcon: Icon(Icons.help_rounded),
            label: "Bantuan",
          ),
          NavigationDestination(
            icon: Icon(Icons.logout_outlined),
            selectedIcon: Icon(Icons.logout_rounded),
            label: "Logout",
          ),
        ],
      ),
    );
  }
}
