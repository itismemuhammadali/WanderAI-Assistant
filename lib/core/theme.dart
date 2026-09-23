// ============================================================================
// APP THEME & DESIGN TOKENS
// FILE: lib/core/theme.dart
//
// 🎓 TEACHER DEFENSE / VIVA QUICK TRICKS:
// 1. TEACHER: "App ka color blue se change karo! Green ya Purple ya Red karo!"
//    - Change `primaryBlue` (Line 24) and `accentTeal` (Line 27) below:
//      * Emerald Green: primaryBlue = Color(0xFF064E3B), accentTeal = Color(0xFF10B981);
//      * Royal Purple:  primaryBlue = Color(0xFF2E1065), accentTeal = Color(0xFF8B5CF6);
//      * Sunset Crimson: primaryBlue = Color(0xFF7F1D1D), accentTeal = Color(0xFFF97316);
//      * Standard Blue: primaryBlue = Color(0xFF0F2027), accentTeal = Color(0xFF00B4DB);
// 2. TEACHER: "Font ya button corners change karo!"
//    - Button radius: Line 85 (change 16 to 8 for sharp, 24 for pill-shaped)
// ============================================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // --------------------------------------------------------------------------
  // Primary Palette
  // --------------------------------------------------------------------------
  static const Color primaryBlue = Color(0xFF0F2027); // Deep Blue
  static const Color secondaryBlue = Color(0xFF203A43); // Medium Blue
  static const Color teal = Color(0xFF2C5364); // Teal / Dark Aqua
  static const Color accentTeal = Color(0xFF00B4DB); // Bright Teal for accents
  static const Color background = Color(0xFFF8FAFC); // Very light grey/blue
  static const Color surface = Colors.white;
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color error = Color(0xFFEF4444);

  // Text Theme
  static TextTheme get _textTheme {
    return GoogleFonts.poppinsTextTheme().copyWith(
      displayLarge: GoogleFonts.poppins(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 32),
      displayMedium: GoogleFonts.poppins(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 28),
      displaySmall: GoogleFonts.poppins(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 24),
      headlineMedium: GoogleFonts.poppins(color: textPrimary, fontWeight: FontWeight.w600, fontSize: 20),
      headlineSmall: GoogleFonts.poppins(color: textPrimary, fontWeight: FontWeight.w600, fontSize: 18),
      titleLarge: GoogleFonts.poppins(color: textPrimary, fontWeight: FontWeight.w600, fontSize: 16),
      titleMedium: GoogleFonts.poppins(color: textPrimary, fontWeight: FontWeight.w500, fontSize: 16),
      bodyLarge: GoogleFonts.poppins(color: textPrimary, fontSize: 16),
      bodyMedium: GoogleFonts.poppins(color: textSecondary, fontSize: 14),
      bodySmall: GoogleFonts.poppins(color: textSecondary, fontSize: 12),
      labelLarge: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
    );
  }

  // Theme Data
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: primaryBlue,
        secondary: accentTeal,
        tertiary: teal,
        background: background,
        surface: surface,
        error: error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: textPrimary,
        onBackground: textPrimary,
      ),
      scaffoldBackgroundColor: background,
      textTheme: _textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: surface,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: primaryBlue),
        titleTextStyle: _textTheme.headlineSmall?.copyWith(color: primaryBlue),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: accentTeal,
        unselectedItemColor: textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentTeal,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: _textTheme.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: accentTeal,
          side: const BorderSide(color: accentTeal),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: _textTheme.labelLarge?.copyWith(color: accentTeal),
        ),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.05),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: accentTeal, width: 2),
        ),
        hintStyle: _textTheme.bodyMedium?.copyWith(color: Colors.grey.shade400),
      ),
    );
  }
}
