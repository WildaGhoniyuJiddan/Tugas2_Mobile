import 'package:flutter/material.dart';

/// Class AppColors
/// Definisi terpusat seluruh palet warna aplikasi
/// Palet warna utama aplikasi.
///
/// Palet dibuat netral dengan satu aksen biru agar tampilan terasa lebih
/// tenang, rapi, dan mudah dibaca.
class AppColors {
  // Warna utama
  static const Color primary = Color(0xFF2563EB);        // Blue 600
  static const Color primaryDark = Color(0xFF1D4ED8);    // Blue 700
  static const Color primaryLight = Color(0xFFEFF6FF);   // Blue 50
  static const Color lavenderAccent = Color(0xFFBFDBFE); // Blue 200

  // Warna Aksen Tambahan & Logistik
  static const Color secondary = Color(0xFFFFA000);      // Industrial Amber (Kontras hangat)
  static const Color secondaryLight = Color(0xFFFFF8E1);
  static const Color accent = Color(0xFF0F766E);         // Teal Logistik
  static const Color accentLight = Color(0xFFE0F2F1);

  // Warna Status Operasional
  static const Color success = Color(0xFF2E7D32);        // Hijau Stok Aman / Sukses
  static const Color successLight = Color(0xFFE8F5E9);
  static const Color warning = Color(0xFFEF6C00);        // Oranye Stok Menipis
  static const Color warningLight = Color(0xFFFFF3E0);
  static const Color danger = Color(0xFFC62828);         // Merah Stok Kritis / Batal
  static const Color dangerLight = Color(0xFFFFEBEE);

  // Warna Netral & Latar Belakang
  static const Color background = Color(0xFFF8FAFC);     // Slate 50
  static const Color surface = Colors.white;             // Warna Card / Container
  static const Color textDark = Color(0xFF0F172A);       // Slate 900
  static const Color textMuted = Color(0xFF64748B);      // Slate 500
  static const Color border = Color(0xFFE2E8F0);         // Slate 200

  // Warna Khusus Ticker & Jam Digital
  static const Color digitalBg = Color(0xFF0F172A);      // Slate 900
  static const Color digitalText = Color(0xFF86EFAC);    // Green 300
}
