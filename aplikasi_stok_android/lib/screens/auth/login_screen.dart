import 'package:flutter/material.dart';
import '../../database/database_helper.dart';
import '../../database/session_manager.dart';
import '../../data_gudang.dart';
import '../../styles/app_colors.dart';
import '../../styles/app_styles.dart';
import '../main_navigation_screen.dart';

/// Halaman Login Pengguna
/// Menggunakan tema warna Lavender (AppColors.primary) dan styling terpusat (AppStyles)
class HalamanLogin extends StatefulWidget {
  const HalamanLogin({super.key});

  @override
  State<HalamanLogin> createState() => _HalamanLoginState();
}

class _HalamanLoginState extends State<HalamanLogin> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;

  /// Memproses otentikasi login pengguna
  Future<void> _prosesLogin() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Username dan password tidak boleh kosong!"),
          backgroundColor: AppColors.danger,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    String namaLengkap = "";
    String role = "Staff Gudang";
    bool loginValid = false;

    // 1. Cek terhadap database SQLite
    try {
      final userDB = await DatabaseHelper.instance.login(username, password);
      if (userDB != null) {
        loginValid = true;
        namaLengkap = userDB['nama_lengkap'] ?? username;
        role = userDB['role'] ?? "Staff Gudang";
      }
    } catch (_) {
      // Fallback jika SQLite baru pertama kali dibuka
    }

    // 2. Cek terhadap daftar akun statis di DataGudang jika belum valid
    if (!loginValid) {
      for (var u in DataGudang.daftarPengguna) {
        if (u['username']!.toLowerCase() == username.toLowerCase() &&
            u['password'] == password) {
          loginValid = true;
          namaLengkap = u['nama']!;
          role = u['role']!;
          break;
        }
      }
    }

    setState(() => _isLoading = false);

    if (loginValid) {
      // Simpan status sesi aktif ke SharedPreferences
      await SessionManager.simpanSesi(
        username: username,
        nama: namaLengkap,
        role: role,
      );

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MainNavigationScreen(
            username: username,
            namaLengkap: namaLengkap,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Username atau password salah!"),
          backgroundColor: AppColors.danger,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            decoration: AppStyles.cardBoxDecoration(),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Icon Header Bernuansa Lavender
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: AppColors.primaryLight,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.warehouse_rounded,
                    size: 56,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 16),

                // Judul Aplikasi
                const Text(
                  "WarehouseSmart",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryDark,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Sistem Manajemen Gudang & Utilitas - Tugas 2",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 24),

                // Input Username
                TextField(
                  controller: _usernameController,
                  decoration: AppStyles.inputDecoration(
                    labelText: "Username",
                    hintText: "Masukkan username Anda",
                    prefixIcon: Icons.person_outline,
                  ),
                ),
                const SizedBox(height: 16),

                // Input Password dengan Toggle Obscure
                TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: AppStyles.inputDecoration(
                    labelText: "Password",
                    hintText: "Masukkan password Anda",
                    prefixIcon: Icons.lock_outline,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off : Icons.visibility,
                        color: AppColors.textMuted,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Petunjuk Akun Demo
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.lavenderAccent.withAlpha(120)),
                  ),
                  child: const Text(
                    "Petunjuk Login Demo:\n"
                    "• admin / admin123 (Super Admin)\n"
                    "• user / user123 (Staff Gudang)\n"
                    "• wilda / password123 (Lead Dev)",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.primaryDark,
                      height: 1.4,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Tombol Login
                ElevatedButton(
                  style: AppStyles.primaryButton,
                  onPressed: _isLoading ? null : _prosesLogin,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          "LOGIN MASUK",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
