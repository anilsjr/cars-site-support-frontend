import 'package:flutter/material.dart';

class AppTheme {
  // Custom color palette
  static const List<Color> customColors = [
    Color(0xFF03045e), // Dark navy
    Color(0xFF023e8a), // Navy blue
    Color(0xFF0077b6), // Blue
    Color(0xFF0096c7), // Medium blue
    Color(0xFF00b4d8), // Light blue
    Color(0xFF48cae4), // Sky blue
    Color(0xFF90e0ef), // Light sky blue
    Color(0xFFade8f4), // Very light blue
    Color(0xFFcaf0f8), // Pale blue
  ];

  // Primary colors from the palette
  static const Color primaryDark = Color(0xFF03045e);
  static const Color primaryMedium = Color(0xFF0077b6);
  static const Color primaryLight = Color(0xFF48cae4);
  static const Color primaryVeryLight = Color(0xFFcaf0f8);

  // Additional semantic colors
  static const Color successColor = Color(0xFF00b4d8); // Light blue for success
  static const Color errorColor = Color(0xFF03045e); // Dark navy for errors
  static const Color warningColor = Color(
    0xFF0096c7,
  ); // Medium blue for warnings
  static const Color infoColor = Color(0xFF48cae4); // Sky blue for info

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryMedium,
      brightness: Brightness.light,
      primary: primaryMedium,
      secondary: primaryLight,
      surface: primaryVeryLight,
    ),
    appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
    cardTheme: const CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryMedium,
      brightness: Brightness.dark,
      primary: primaryLight,
      secondary: primaryMedium,
      surface: primaryDark,
    ),
    appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
    cardTheme: const CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
  );
}
