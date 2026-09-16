import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Class AppStyles
/// Kumpulan style UI reusable agar seluruh layar terlihat konsisten.
class AppStyles {
  // Kartu datar dengan border tipis agar tampilan terasa ringan.
  static BoxDecoration cardBoxDecoration({Color color = AppColors.surface}) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: AppColors.border),
    );
  }

  // Banner sambutan sederhana tanpa gradien atau bayangan.
  static BoxDecoration bannerDecoration = BoxDecoration(
    color: AppColors.primary,
    borderRadius: BorderRadius.circular(16),
  );

  // Dekorasi Layar Digital Stopwatch
  static BoxDecoration digitalBoxDecoration({Color borderColor = AppColors.primary}) {
    return BoxDecoration(
      color: AppColors.digitalBg,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: borderColor.withAlpha(170)),
    );
  }

  // Dekorasi Kotak Waktu (Live Ticker Box)
  static BoxDecoration timeBoxDecoration({bool isLive = false}) {
    return BoxDecoration(
      color: isLive ? AppColors.secondary : Colors.white.withAlpha(25),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(
        color: isLive ? AppColors.secondary : Colors.white30,
      ),
    );
  }

  // Dekorasi Input Text (Outline Border)
  static InputDecoration inputDecoration({
    required String labelText,
    String? hintText,
    IconData? prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: AppColors.textMuted) : null,
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: AppColors.background,
      labelStyle: const TextStyle(color: AppColors.textMuted),
      hintStyle: const TextStyle(color: AppColors.textMuted),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    );
  }

  // Gaya tombol utama
  static ButtonStyle primaryButton = ElevatedButton.styleFrom(
    backgroundColor: AppColors.primary,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    elevation: 0,
  );

  // Gaya Tombol Sukses / Tambah (Green Button)
  static ButtonStyle successButton = ElevatedButton.styleFrom(
    backgroundColor: AppColors.success,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    elevation: 0,
  );

  // Gaya Tombol Peringatan / Kurang (Orange Button)
  static ButtonStyle warningButton = ElevatedButton.styleFrom(
    backgroundColor: AppColors.warning,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    elevation: 0,
  );

  // Gaya Tombol Danger / Hapus (Red Button)
  static ButtonStyle dangerButton = ElevatedButton.styleFrom(
    backgroundColor: AppColors.danger,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    elevation: 0,
  );
}
