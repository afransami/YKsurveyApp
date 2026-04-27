import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ═══════════════════════════════════════════
  // COLOR PALETTE
  // ═══════════════════════════════════════════
  static const Color primary = Color(0xFF1B5E20);       // Deep green
  static const Color primaryLight = Color(0xFF2E7D32);  // Medium green
  static const Color primarySurface = Color(0xFFE8F5E9); // Light green bg
  static const Color accent = Color(0xFFFFB300);         // Amber accent
  static const Color accentLight = Color(0xFFFFF8E1);    // Light amber
  static const Color danger = Color(0xFFC62828);
  static const Color dangerLight = Color(0xFFFFEBEE);
  static const Color info = Color(0xFF1565C0);
  static const Color infoLight = Color(0xFFE3F2FD);
  static const Color purple = Color(0xFF4527A0);
  static const Color purpleLight = Color(0xFFEDE7F6);
  static const Color teal = Color(0xFF00695C);
  static const Color tealLight = Color(0xFFE0F2F1);

  static const Color surface = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF5F7F5);
  static const Color cardBg = Color(0xFFFFFFFF);
  static const Color divider = Color(0xFFEEEEEE);
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF666666);
  static const Color textHint = Color(0xFFAAAAAA);

  // ═══════════════════════════════════════════
  // LIGHT THEME
  // ═══════════════════════════════════════════
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        brightness: Brightness.light,
        primary: primary,
        secondary: accent,
        surface: surface,
        background: background,
        error: danger,
      ),
      scaffoldBackgroundColor: background,
      textTheme: GoogleFonts.hindSiliguriTextTheme().copyWith(
        displayLarge: GoogleFonts.hindSiliguri(
          fontSize: 28, fontWeight: FontWeight.w700, color: textPrimary,
        ),
        displayMedium: GoogleFonts.hindSiliguri(
          fontSize: 24, fontWeight: FontWeight.w600, color: textPrimary,
        ),
        headlineLarge: GoogleFonts.hindSiliguri(
          fontSize: 22, fontWeight: FontWeight.w700, color: textPrimary,
        ),
        headlineMedium: GoogleFonts.hindSiliguri(
          fontSize: 18, fontWeight: FontWeight.w600, color: textPrimary,
        ),
        headlineSmall: GoogleFonts.hindSiliguri(
          fontSize: 16, fontWeight: FontWeight.w600, color: textPrimary,
        ),
        titleLarge: GoogleFonts.hindSiliguri(
          fontSize: 16, fontWeight: FontWeight.w600, color: textPrimary,
        ),
        titleMedium: GoogleFonts.hindSiliguri(
          fontSize: 14, fontWeight: FontWeight.w500, color: textPrimary,
        ),
        bodyLarge: GoogleFonts.hindSiliguri(
          fontSize: 15, fontWeight: FontWeight.w400, color: textPrimary,
        ),
        bodyMedium: GoogleFonts.hindSiliguri(
          fontSize: 14, fontWeight: FontWeight.w400, color: textSecondary,
        ),
        bodySmall: GoogleFonts.hindSiliguri(
          fontSize: 12, fontWeight: FontWeight.w400, color: textHint,
        ),
        labelLarge: GoogleFonts.hindSiliguri(
          fontSize: 14, fontWeight: FontWeight.w600, color: surface,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.hindSiliguri(
          fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      cardTheme: CardTheme(
        color: cardBg,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFFE8E8E8), width: 1),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: GoogleFonts.hindSiliguri(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          side: const BorderSide(color: primary, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF8F9FA),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: danger),
        ),
        labelStyle: GoogleFonts.hindSiliguri(fontSize: 14, color: textSecondary),
        hintStyle: GoogleFonts.hindSiliguri(fontSize: 14, color: textHint),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: primarySurface,
        labelStyle: GoogleFonts.hindSiliguri(fontSize: 12, color: primaryLight),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: primary,
        unselectedItemColor: textHint,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      dividerTheme: const DividerThemeData(color: divider, thickness: 1, space: 1),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: const Color(0xFF2E2E2E),
        contentTextStyle: GoogleFonts.hindSiliguri(color: Colors.white, fontSize: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

// ═══════════════════════════════════════════
// BADGE COLORS HELPER
// ═══════════════════════════════════════════
class BadgeStyle {
  final Color bg;
  final Color text;
  const BadgeStyle(this.bg, this.text);
}

class AppBadges {
  static const pending = BadgeStyle(Color(0xFFFFF8E1), Color(0xFFE65100));
  static const active = BadgeStyle(Color(0xFFE8F5E9), Color(0xFF1B5E20));
  static const done = BadgeStyle(Color(0xFFE3F2FD), Color(0xFF0D47A1));
  static const urgent = BadgeStyle(Color(0xFFFFEBEE), Color(0xFFC62828));
  static const namjari = BadgeStyle(Color(0xFFEDE7F6), Color(0xFF311B92));
  static const dalil = BadgeStyle(Color(0xFFE0F2F1), Color(0xFF004D40));
}
