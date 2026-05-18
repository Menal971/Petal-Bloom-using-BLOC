import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Warm mauve-rose palette (distinct from blush-pink of the Provider app)
  static const Color bloom = Color(0xFFE05C8A); // deep magenta-rose
  static const Color petal = Color(0xFFF48FB1); // medium pink
  static const Color mist = Color(0xFFFCE4EC); // background
  static const Color frost = Color(0xFFFFF8FA); // card bg
  static const Color mauveTint = Color(0xFFFFD9E8); // accent bg
  static const Color dustyRose = Color(0xFFFFB3CC); // dividers
  static const Color inkDeep = Color(0xFF1E0F17); // primary text
  static const Color inkSoft = Color(0xFF7A4060); // secondary text
  static const Color white = Colors.white;
  static const Color success = Color(0xFF388E3C);
  static const Color danger = Color(0xFFC62828);

  // Per-card left stripe colors (warm spectrum)
  static const List<Color> stripes = [
    Color(0xFFFFC1D8),
    Color(0xFFFFCCE2),
    Color(0xFFFFD6EB),
    Color(0xFFFFBED4),
    Color(0xFFFFCADF),
  ];

  static ThemeData get theme {
    final base = ThemeData(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: mist,
      colorScheme: ColorScheme.fromSeed(
        seedColor: bloom,
        primary: bloom,
        onPrimary: white,
        primaryContainer: mauveTint,
        onPrimaryContainer: inkDeep,
        secondary: petal,
        surface: mist,
        onSurface: inkDeep,
        onSurfaceVariant: inkSoft,
        error: danger,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: mist,
        foregroundColor: inkDeep,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.cormorantGaramond(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: inkDeep,
          letterSpacing: 0.5,
        ),
        iconTheme: const IconThemeData(color: bloom),
      ),
      textTheme: GoogleFonts.nunitoTextTheme(base.textTheme).copyWith(
        displayLarge: GoogleFonts.cormorantGaramond(
            fontSize: 36, fontWeight: FontWeight.w800, color: inkDeep),
        headlineMedium: GoogleFonts.cormorantGaramond(
            fontSize: 24, fontWeight: FontWeight.w700, color: inkDeep),
        titleLarge: GoogleFonts.nunito(
            fontSize: 16, fontWeight: FontWeight.w700, color: inkDeep),
        bodyLarge:
            GoogleFonts.nunito(fontSize: 15, color: inkSoft, height: 1.65),
        bodyMedium: GoogleFonts.nunito(fontSize: 13, color: inkSoft),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: dustyRose),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: dustyRose, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: bloom, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: danger, width: 1.5),
        ),
        labelStyle: GoogleFonts.nunito(color: inkSoft, fontSize: 14),
        hintStyle: GoogleFonts.nunito(
            color: dustyRose, fontSize: 14, fontStyle: FontStyle.italic),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      ),
      cardTheme: CardThemeData(
        color: frost,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: inkDeep,
        contentTextStyle: GoogleFonts.nunito(color: white, fontSize: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
