import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Class AppTextStyles
/// Mengelola seluruh gaya teks (Typography) aplikasi
class AppTextStyles {
  // AppBar & header utama
  static const TextStyle appBarTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
  );

  static const TextStyle bannerTitle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: Colors.white,
  );

  static const TextStyle bannerSubtitle = TextStyle(
    fontSize: 12,
    color: Colors.white70,
  );

  // Judul Bagian Menu (Section)
  static const TextStyle sectionTitle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: AppColors.primaryDark,
  );

  // Judul Kartu Menu (Cards)
  static const TextStyle cardTitle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
  );

  static const TextStyle cardSubtitle = TextStyle(
    fontSize: 12,
    color: AppColors.textMuted,
  );

  // Jam Digital & Ticker Presisi (Monospace)
  static const TextStyle digitalClockLarge = TextStyle(
    fontSize: 44,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    fontFamily: 'monospace',
    letterSpacing: 2,
  );

  static const TextStyle digitalClockMedium = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    fontFamily: 'monospace',
  );

  // Rumus & Hasil Perhitungan
  static const TextStyle resultFormula = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
    height: 1.4,
  );

  // Badge Status Stok
  static TextStyle badge(Color color) => TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.bold,
    color: color,
  );
}
