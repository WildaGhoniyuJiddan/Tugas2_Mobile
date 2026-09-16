import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Class AppStyles
/// Berfungsi layaknya berkas "CSS Stylesheet" di Flutter:
/// Menyediakan dekorasi kartu, field input, tombol, dan kotak timer reusable.
class AppStyles {
  // Dekorasi Kartu Utama (Card Box Shadow)
  static BoxDecoration cardBoxDecoration({Color color = AppColors.surface}) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppColors.border),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withAlpha(8),
          blurRadius: 8,
          offset: const Offset(0, 3),
        ),
      ],
    );
  }

  // Dekorasi Banner Sambutan (Lavender Gradient)
  static BoxDecoration bannerDecoration = BoxDecoration(
    gradient: const LinearGradient(
      colors: [AppColors.primary, AppColors.primaryDark],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.circular(14),
    boxShadow: [
      BoxShadow(
        color: AppColors.primary.withAlpha(60),
        blurRadius: 12,
        offset: const Offset(0, 4),
      ),
    ],
  );

  // Dekorasi Layar Digital Stopwatch
  static BoxDecoration digitalBoxDecoration({Color borderColor = AppColors.primary}) {
    return BoxDecoration(
      color: AppColors.digitalBg,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: borderColor, width: 2),
      boxShadow: [
        BoxShadow(
          color: borderColor.withAlpha(40),
          blurRadius: 10,
          spreadRadius: 1,
        ),
      ],
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
      prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: AppColors.primary) : null,
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    );
  }

  // Gaya Tombol Utama (Lavender Button)
  static ButtonStyle primaryButton = ElevatedButton.styleFrom(
    backgroundColor: AppColors.primary,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    elevation: 2,
  );

  // Gaya Tombol Sukses / Tambah (Green Button)
  static ButtonStyle successButton = ElevatedButton.styleFrom(
    backgroundColor: AppColors.success,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  );

  // Gaya Tombol Peringatan / Kurang (Orange Button)
  static ButtonStyle warningButton = ElevatedButton.styleFrom(
    backgroundColor: AppColors.warning,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  );

  // Gaya Tombol Danger / Hapus (Red Button)
  static ButtonStyle dangerButton = ElevatedButton.styleFrom(
    backgroundColor: AppColors.danger,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  );
}
