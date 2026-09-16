import 'package:shared_preferences/shared_preferences.dart';

/// Class SessionManager
/// Mengelola sesi login pengguna secara persisten menggunakan SharedPreferences
class SessionManager {
  static const String _keyIsLogin = "is_logged_in";
  static const String _keyUsername = "session_username";
  static const String _keyNama = "session_nama";
  static const String _keyRole = "session_role";

  /// Menyimpan sesi saat login berhasil
  static Future<void> simpanSesi({
    required String username,
    required String nama,
    required String role,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLogin, true);
    await prefs.setString(_keyUsername, username);
    await prefs.setString(_keyNama, nama);
    await prefs.setString(_keyRole, role);
  }

  /// Memeriksa status sesi pengguna (Auto-Login)
  static Future<bool> cekSudahLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLogin) ?? false;
  }

  /// Mengambil username pengguna aktif
  static Future<String> ambilUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUsername) ?? "User";
  }

  /// Mengambil nama lengkap pengguna aktif
  static Future<String> ambilNama() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyNama) ?? "Pengguna Gudang";
  }

  /// Mengambil peran/role pengguna aktif
  static Future<String> ambilRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyRole) ?? "Staff Gudang";
  }

  /// Menghapus seluruh sesi pengguna (Logout)
  static Future<void> hapusSesi() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyIsLogin);
    await prefs.remove(_keyUsername);
    await prefs.remove(_keyNama);
    await prefs.remove(_keyRole);
  }
}
