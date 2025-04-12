import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF2563EB);
  static const Color secondaryColor = Color(0xFF6B7280);
  static const Color accentColor = Color(0xFFEF4444);
  static const Color backgroundColor = Color(0xFFF3F4F6);
  static const Color cardColor = Colors.white;
  static const Color textPrimaryColor = Color(0xFF1F2937);
  static const Color textSecondaryColor = Color(0xFF4B5563);
  static const Color disabledColor = Color(0xFFE5E7EB);

  // Light theme
  static ThemeData lightTheme = ThemeData.light().copyWith(
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      surface: cardColor,
      error: accentColor,
    ),
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    cardTheme: CardTheme(
      color: cardColor,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: primaryColor,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: primaryColor,
      unselectedItemColor: secondaryColor,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
    textTheme: TextTheme(
      displayLarge: GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: textPrimaryColor,
      ),
      displayMedium: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: textPrimaryColor,
      ),
      displaySmall: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textPrimaryColor,
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: textPrimaryColor,
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        color: textPrimaryColor,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        color: textPrimaryColor,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        color: textSecondaryColor,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryColor,
        minimumSize: const Size(double.infinity, 48),
        side: const BorderSide(color: primaryColor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryColor,
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: secondaryColor.withOpacity(0.2)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: secondaryColor.withOpacity(0.2)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: primaryColor),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: accentColor),
      ),
      hintStyle: GoogleFonts.inter(
        fontSize: 14,
        color: textSecondaryColor.withOpacity(0.7),
      ),
    ),
  );

  // Dark theme
  static ThemeData darkTheme = ThemeData.dark().copyWith(
    colorScheme: const ColorScheme.dark(
      primary: primaryColor,
      secondary: secondaryColor,
      surface: Color(0xFF1F2937),
      error: accentColor,
    ),
    primaryColor: primaryColor,
    scaffoldBackgroundColor: const Color(0xFF111827),
    cardTheme: CardTheme(
      color: const Color(0xFF1F2937),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF1F2937),
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: const Color(0xFF1F2937),
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.grey[400],
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
    textTheme: TextTheme(
      displayLarge: GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      displayMedium: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      displaySmall: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        color: Colors.white,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        color: Colors.white,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        color: Colors.grey[400],
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryColor,
        minimumSize: const Size(double.infinity, 48),
        side: const BorderSide(color: primaryColor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryColor,
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF1F2937),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey[600]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey[600]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: primaryColor),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: accentColor),
      ),
      hintStyle: GoogleFonts.inter(
        fontSize: 14,
        color: Colors.grey[400],
      ),
    ),
  );
} 