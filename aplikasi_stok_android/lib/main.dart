import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'database/session_manager.dart';
import 'screens/auth/login_screen.dart';
import 'screens/main_navigation_screen.dart';
import 'styles/app_colors.dart';

// Re-export HalamanLogin agar kompatibel dengan tes widget
export 'screens/auth/login_screen.dart';

void main() async {
  // Memastikan binding Flutter diinisialisasi sebelum mengakses SharedPreferences / SQLite
  WidgetsFlutterBinding.ensureInitialized();
  // Inisialisasi locale data untuk formatting tanggal bahasa Indonesia (id_ID)
  await initializeDateFormatting('id_ID', null);
  runApp(const AplikasiStokApp());
}

/// Widget Utama Aplikasi Flutter
class AplikasiStokApp extends StatelessWidget {
  const AplikasiStokApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stok Hebat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.light,
        ),
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.surface,
          foregroundColor: AppColors.textDark,
          elevation: 0,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
          centerTitle: false,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          isDense: true,
        ),
        snackBarTheme: const SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
        ),
      ),
      // Cek sesi otomatis saat startup (Auto-Login)
      home: const PemeriksaSesiStartup(),
    );
  }
}

/// Widget untuk memeriksa sesi pengguna saat aplikasi pertama kali dibuka
class PemeriksaSesiStartup extends StatefulWidget {
  const PemeriksaSesiStartup({super.key});

  @override
  State<PemeriksaSesiStartup> createState() => _PemeriksaSesiStartupState();
}

class _PemeriksaSesiStartupState extends State<PemeriksaSesiStartup> {
  @override
  void initState() {
    super.initState();
    _cekSesi();
  }

  Future<void> _cekSesi() async {
    final sudahLogin = await SessionManager.cekSudahLogin();

    if (!mounted) return;

    if (sudahLogin) {
      final username = await SessionManager.ambilUsername();
      final nama = await SessionManager.ambilNama();

      // Langsung menuju Beranda jika sesi aktif
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MainNavigationScreen(
            username: username,
            namaLengkap: nama,
          ),
        ),
      );
    } else {
      // Ke Halaman Login jika belum login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HalamanLogin()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
    );
  }
}
