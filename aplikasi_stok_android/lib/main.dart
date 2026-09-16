import 'package:flutter/material.dart';
import 'main_navigation_screen.dart';
import 'session_manager.dart';
import 'database_helper.dart';
import 'data_gudang.dart';

void main() async {
  // Memastikan binding Flutter diinisialisasi sebelum mengakses SharedPreferences / SQLite
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AplikasiStokApp());
}

/// Widget Utama Aplikasi Flutter
class AplikasiStokApp extends StatelessWidget {
  const AplikasiStokApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WarehouseSmart',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
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
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

/// Halaman Login (Kriteria 1 & Manajemen Sesi)
class HalamanLogin extends StatefulWidget {
  const HalamanLogin({super.key});

  @override
  State<HalamanLogin> createState() => _HalamanLoginState();
}

class _HalamanLoginState extends State<HalamanLogin> {
  // Controller untuk membaca teks input pengguna
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;

  /// Memproses otentikasi login
  Future<void> _prosesLogin() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Username dan password tidak boleh kosong!")),
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
      // Abaikan jika SQLite sedang inisialisasi awal
    }

    // 2. Cek terhadap daftar bawaan di DataGudang jika belum valid
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
      // Simpan status sesi ke SharedPreferences
      await SessionManager.simpanSesi(
        username: username,
        nama: namaLengkap,
        role: role,
      );

      if (!mounted) return;

      // Navigasi ke Wrapper Halaman Utama
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
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Icon Header
                  Icon(
                    Icons.warehouse_rounded,
                    size: 64,
                    color: Colors.blue.shade800,
                  ),
                  const SizedBox(height: 12),

                  // Judul Aplikasi
                  const Text(
                    "WarehouseSmart",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Sistem Manajemen Gudang & Utilitas - Tugas 2",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),

                  const SizedBox(height: 24),

                  // Input Username
                  TextField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Username",
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Input Password dengan Toggle Lihat Sandi
                  TextField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: "Password",
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Petunjuk Akun Demo (Diselaraskan dengan aplikasi_stok)
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: const Text(
                      "Petunjuk Login Demo:\n"
                      "• admin / admin123 (Super Admin)\n"
                      "• user / user123 (Staff Gudang)\n"
                      "• wilda / password123 (Lead Dev)",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: Colors.blue, height: 1.4),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Tombol Login
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade800,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
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
      ),
    );
  }
}
