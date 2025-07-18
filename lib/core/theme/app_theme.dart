import 'package:flutter/material.dart';

class AppTheme {
  // Modernized Color Palette with Same Names
  static const Color primaryDark = Color(
    0xFF1F2937,
  ); // Very dark blue-gray (modern dark)
  static const Color primaryMedium = Color(
    0xFF4F46E5,
  ); // Vibrant indigo (main primary)
  static const Color primaryLight = Color(0xFF6366F1); // Light indigo (accent)
  static const Color primaryVeryLight = Color(
    0xFFF9FAFB,
  ); // Light gray background

  // Semantic Colors (same names, better UI contrast)
  static const Color successColor = Color(0xFF10B981); // Green
  static const Color errorColor = Color(0xFFEF4444); // Red
  static const Color warningColor = Color(0xFFF59E0B); // Amber
  static const Color infoColor = Color(0xFF3B82F6); // Blue

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: primaryVeryLight,
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: primaryMedium,
      onPrimary: Colors.white,
      secondary: primaryLight,
      onSecondary: Colors.black,
      surface: Colors.white,
      onSurface: Colors.black,
      error: errorColor,
      onError: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryMedium,
      foregroundColor: Colors.white,
      centerTitle: true,
      elevation: 0,
    ),
    cardTheme: const CardThemeData(
      color: Colors.white,
      elevation: 3,
      margin: EdgeInsets.all(12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryMedium,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: primaryDark,
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: primaryLight,
      onPrimary: Colors.white,
      secondary: primaryMedium,
      onSecondary: Colors.white,
      surface: Color(0xFF374151), // Mid-dark surface for cards
      onSurface: Colors.white,
      error: errorColor,
      onError: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1F2937),
      foregroundColor: Colors.white,
      centerTitle: true,
      elevation: 0,
    ),
    cardTheme: const CardThemeData(
      color: Color(0xFF1F2937),
      elevation: 2,
      margin: EdgeInsets.all(12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryLight,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
  );
}
