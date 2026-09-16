import 'package:flutter/material.dart';

/// Class AppColors
/// Definisi terpusat seluruh palet warna aplikasi
/// Warna Utama (Primary): Lavender yang elegan, lembut, dan modern
class AppColors {
  // Palet Lavender (Warna Utama Aplikasi)
  static const Color primary = Color(0xFF7E57C2);        // Deep Lavender
  static const Color primaryDark = Color(0xFF512DA8);    // Darker Lavender
  static const Color primaryLight = Color(0xFFEDE7F6);   // Soft Lavender Background
  static const Color lavenderAccent = Color(0xFFB39DDB); // Accent Lavender

  // Warna Aksen Tambahan & Logistik
  static const Color secondary = Color(0xFFFFA000);      // Industrial Amber (Kontras hangat)
  static const Color secondaryLight = Color(0xFFFFF8E1);
  static const Color accent = Color(0xFF00897B);         // Teal Logistik
  static const Color accentLight = Color(0xFFE0F2F1);

  // Warna Status Operasional
  static const Color success = Color(0xFF2E7D32);        // Hijau Stok Aman / Sukses
  static const Color successLight = Color(0xFFE8F5E9);
  static const Color warning = Color(0xFFEF6C00);        // Oranye Stok Menipis
  static const Color warningLight = Color(0xFFFFF3E0);
  static const Color danger = Color(0xFFC62828);         // Merah Stok Kritis / Batal
  static const Color dangerLight = Color(0xFFFFEBEE);

  // Warna Netral & Latar Belakang
  static const Color background = Color(0xFFF8F9FD);     // Latar Bersih Lembut
  static const Color surface = Colors.white;             // Warna Card / Container
  static const Color textDark = Color(0xFF1E1E2C);       // Teks Utama (Hitam Lembut)
  static const Color textMuted = Color(0xFF6B6E7B);      // Teks Sekunder / Subtitle
  static const Color border = Color(0xFFE2E4EC);         // Garis Batas / Divider

  // Warna Khusus Ticker & Jam Digital
  static const Color digitalBg = Color(0xFF1A1A2E);      // Latar Display Stopwatch/Ticker
  static const Color digitalText = Color(0xFF00E676);    // Font Hijau Neon Presisi
}
