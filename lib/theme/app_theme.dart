import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A class that contains all theme configurations for the HomeSnap Pro application with modern DevKit design.
class AppTheme {
  AppTheme._();

  // DevKit Modern Color Palette
  static const Color primaryBlue = Color(0xFF0181cc);
  static const Color accentOrange = Color(0xFFe75f3f);
  static const Color darkGray = Color(0xFF212121);
  static const Color mediumGray = Color(0xFF555555);
  static const Color lightGray = Color(0xFF777777);
  static const Color softGray = Color(0xFFaaaaaa);
  static const Color softBlue = Color(0xff01aed6);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  // Semantic color mappings
  static const Color primary = primaryBlue;
  static const Color accent = accentOrange;
  static const Color surface = white;
  static const Color background = Color(0xFFF8F9FA);
  static const Color textPrimary = darkGray;
  static const Color textSecondary = mediumGray;
  static const Color border = Color(0xFFE1E5E9);

  /// Light theme with modern DevKit design
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: primaryBlue,
      onPrimary: white,
      primaryContainer: Color(0xFFE3F2FD),
      onPrimaryContainer: primaryBlue,
      secondary: accentOrange,
      onSecondary: white,
      secondaryContainer: Color(0xFFFFE7E0),
      onSecondaryContainer: accentOrange,
      tertiary: softBlue,
      onTertiary: white,
      error: Color(0xFFD32F2F),
      onError: white,
      surface: surface,
      onSurface: textPrimary,
      onSurfaceVariant: textSecondary,
      outline: border,
      shadow: Color(0x1A000000),
      scrim: Color(0x80000000),
    ),
    scaffoldBackgroundColor: background,
    cardColor: surface,
    dividerColor: border,

    // Modern AppBar
    appBarTheme: AppBarTheme(
      backgroundColor: surface,
      foregroundColor: textPrimary,
      elevation: 0,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
    ),

    // Modern Cards
    cardTheme: CardThemeData(
      color: surface,
      elevation: 2,
      shadowColor: Color(0x1A000000),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
    ),

    // Modern Buttons
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: white,
        backgroundColor: primaryBlue,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryBlue,
        backgroundColor: Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        side: BorderSide(color: primaryBlue, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    // Modern Typography
    textTheme: _buildModernTextTheme(),

    // Modern Input Fields
    inputDecorationTheme: InputDecorationTheme(
      fillColor: surface,
      filled: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: border, width: 1.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: border, width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: primaryBlue, width: 2.0),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: Color(0xFFD32F2F), width: 1.0),
      ),
      labelStyle: GoogleFonts.inter(
        color: textSecondary,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      hintStyle: GoogleFonts.inter(
        color: softGray,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
    ),

    // Modern FAB
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: accentOrange,
      foregroundColor: white,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
    ),

    // Modern Bottom Navigation
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: surface,
      selectedItemColor: primaryBlue,
      unselectedItemColor: softGray,
      elevation: 8,
      type: BottomNavigationBarType.fixed,
    ),
  );

  /// Modern text theme using Inter font
  static TextTheme _buildModernTextTheme() {
    return TextTheme(
      displayLarge: GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: textPrimary,
      ),
      displayMedium: GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: textPrimary,
      ),
      displaySmall: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: textPrimary,
      ),
      headlineLarge: GoogleFonts.inter(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      headlineSmall: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      titleLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      titleSmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textPrimary,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textPrimary,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: textSecondary,
      ),
      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textPrimary,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: textSecondary,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: textSecondary,
      ),
    );
  }

  // Additional colors needed by the app widgets
  static const Color yellow = Color(0xFFFFD700);
  static const Color backgroundElevated = Color(0xFF1E1E1E);
  static const Color borderSubtle = Color(0xFFE8E8E8);
  static const Color shadowLight = Color(0x1A000000);
  static const Color accentStart = Color(0xFF0181cc);
  static const Color accentEnd = Color(0xFFe75f3f);
  static const Color successColor = Color(0xFF4CAF50);
  static const Color errorColor = Color(0xFFD32F2F);
  static const Color warningColor = Color(0xFFFFC107);
  static const Color textSecondaryDark = Color(0xFF9E9E9E);
  static const Color primaryLight = Color(0xFF64B5F6);
  static ThemeData? darkTheme = null;
}
