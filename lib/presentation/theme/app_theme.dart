import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();
  
  // Colors
  static const Color primaryColor = Color(0xFF1E88E5);
  static const Color secondaryColor = Color(0xFF26A69A);
  static const Color accentColor = Color(0xFFFF4081);
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color cardColor = Colors.white;
  static const Color errorColor = Color(0xFFE53935);
  static const Color successColor = Color(0xFF43A047);
  
  // Dark theme colors
  static const Color darkPrimaryColor = Color(0xFF1976D2);
  static const Color darkSecondaryColor = Color(0xFF00897B);
  static const Color darkAccentColor = Color(0xFFFF4081);
  static const Color darkBackgroundColor = Color(0xFF121212);
  static const Color darkCardColor = Color(0xFF1E1E1E);
  static const Color darkTextColor = Color(0xFFE0E0E0);
  static const Color darkSubtitleColor = Color(0xFFB0B0B0);
  
  // Color schemes for different media types
  static const Map<String, Color> mediaTypeColors = {
    'news': Color(0xFF5C6BC0), // Indigo
    'video': Color(0xFFE53935), // Red
    'meme': Color(0xFF8E24AA), // Purple
    'tweet': Color(0xFF039BE5), // Light Blue
  };
  
  // Text styles
  static TextStyle get headlineLarge => GoogleFonts.poppins(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
  );
  
  static TextStyle get headlineMedium => GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
  );
  
  static TextStyle get headlineSmall => GoogleFonts.poppins(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: Colors.black87,
  );
  
  static TextStyle get titleLarge => GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Colors.black87,
  );
  
  static TextStyle get titleMedium => GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Colors.black87,
  );
  
  static TextStyle get bodyLarge => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: Colors.black87,
  );
  
  static TextStyle get bodyMedium => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: Colors.black87,
  );
  
  static TextStyle get bodySmall => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: Colors.black54,
  );
  
  static TextStyle get labelMedium => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: Colors.black87,
  );
  
  // Theme data
  static ThemeData get lightTheme {
    final baseTheme = ThemeData.light();
    
    return baseTheme.copyWith(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      cardColor: cardColor,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        error: errorColor,
        surface: cardColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.black87,
        onError: Colors.white,
        brightness: Brightness.light,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: primaryColor,
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: const BorderSide(
            color: primaryColor,
            width: 1.5,
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Colors.grey[300]!,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Colors.grey[300]!,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: primaryColor,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: errorColor,
            width: 1,
          ),
        ),
        labelStyle: GoogleFonts.inter(
          fontSize: 16,
          color: Colors.grey[700],
        ),
        hintStyle: GoogleFonts.inter(
          fontSize: 16,
          color: Colors.grey[400],
        ),
        errorStyle: GoogleFonts.inter(
          fontSize: 12,
          color: errorColor,
        ),
      ),
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        clipBehavior: Clip.antiAlias,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: Colors.grey[200]!,
        disabledColor: Colors.grey[300]!,
        selectedColor: primaryColor.withOpacity(0.2),
        secondarySelectedColor: primaryColor,
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        labelStyle: GoogleFonts.inter(
          fontSize: 12,
          color: Colors.black87,
        ),
        secondaryLabelStyle: GoogleFonts.inter(
          fontSize: 12,
          color: primaryColor,
        ),
        brightness: Brightness.light,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey[600],
        selectedLabelStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 12,
        ),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      dividerTheme: DividerThemeData(
        space: 1,
        thickness: 1,
        color: Colors.grey[200],
      ),
      tabBarTheme: TabBarTheme(
        labelColor: primaryColor,
        unselectedLabelColor: Colors.grey[600],
        indicatorSize: TabBarIndicatorSize.tab,
        labelStyle: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: secondaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      dialogTheme: DialogTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
        contentTextStyle: GoogleFonts.inter(
          fontSize: 16,
          color: Colors.black87,
        ),
      ),
      textTheme: TextTheme(
        headlineLarge: headlineLarge,
        headlineMedium: headlineMedium,
        headlineSmall: headlineSmall,
        titleLarge: titleLarge,
        titleMedium: titleMedium,
        bodyLarge: bodyLarge,
        bodyMedium: bodyMedium,
        bodySmall: bodySmall,
        labelMedium: labelMedium,
      ),
    );
  }
  
  // Dark theme data
  static ThemeData get darkTheme {
    final baseTheme = ThemeData.dark();
    const primaryColorDark = darkPrimaryColor;
    
    return baseTheme.copyWith(
      primaryColor: primaryColorDark,
      scaffoldBackgroundColor: darkBackgroundColor,
      cardColor: darkCardColor,
      colorScheme: ColorScheme.dark(
        primary: primaryColorDark,
        secondary: darkSecondaryColor,
        error: Colors.red[300]!,
        surface: darkCardColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: darkTextColor,
        onError: Colors.black,
        brightness: Brightness.dark,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: darkCardColor,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: primaryColorDark,
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          side: const BorderSide(
            color: Colors.white,
            width: 1.5,
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkCardColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Colors.grey[700]!,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Colors.grey[700]!,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: darkPrimaryColor,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Colors.red[300]!,
            width: 1,
          ),
        ),
        labelStyle: GoogleFonts.inter(
          fontSize: 16,
          color: Colors.grey[300],
        ),
        hintStyle: GoogleFonts.inter(
          fontSize: 16,
          color: Colors.grey[500],
        ),
        errorStyle: GoogleFonts.inter(
          fontSize: 12,
          color: Colors.red[300]!,
        ),
      ),
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        clipBehavior: Clip.antiAlias,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: Colors.grey[800],
        disabledColor: Colors.grey[700]!,
        selectedColor: darkPrimaryColor.withOpacity(0.7),
        secondarySelectedColor: darkPrimaryColor,
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        labelStyle: GoogleFonts.inter(
          fontSize: 12,
          color: Colors.grey[300],
        ),
        secondaryLabelStyle: GoogleFonts.inter(
          fontSize: 12,
          color: Colors.white,
        ),
        brightness: Brightness.dark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: darkCardColor,
        selectedItemColor: darkPrimaryColor,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 12,
        ),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      dividerTheme: DividerThemeData(
        space: 1,
        thickness: 1,
        color: Colors.grey[700],
      ),
      tabBarTheme: TabBarTheme(
        labelColor: darkPrimaryColor,
        unselectedLabelColor: Colors.grey,
        indicatorSize: TabBarIndicatorSize.tab,
        labelStyle: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: darkSecondaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      dialogTheme: DialogTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        contentTextStyle: GoogleFonts.inter(
          fontSize: 16,
          color: Colors.white,
        ),
      ),
      textTheme: TextTheme(
        headlineLarge: headlineLarge,
        headlineMedium: headlineMedium,
        headlineSmall: headlineSmall,
        titleLarge: titleLarge,
        titleMedium: titleMedium,
        bodyLarge: bodyLarge,
        bodyMedium: bodyMedium,
        bodySmall: bodySmall,
        labelMedium: labelMedium,
      ),
    );
  }
  
  // Method to get theme based on brightness
  static ThemeData getTheme(Brightness brightness) {
    return brightness == Brightness.light ? lightTheme : darkTheme;
  }
}

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  void setThemeMode(ThemeMode themeMode) {
    _themeMode = themeMode;
    notifyListeners();
  }

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    // Provide haptic feedback
    HapticFeedback.mediumImpact();
    notifyListeners();
  }
} 