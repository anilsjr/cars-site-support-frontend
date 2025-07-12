import 'package:flutter/material.dart';

/// Responsive typography utilities for consistent text sizing across devices
class ResponsiveTypography {
  // Base font sizes for different screen types
  static const double _mobileBaseSize = 14.0;

  // Font scale factors
  static const double _displayScale = 3.5;
  static const double _headlineScale = 2.5;
  static const double _titleScale = 1.5;
  static const double _bodyScale = 1.0;
  static const double _labelScale = 0.85;

  /// Light theme text styles
  static TextTheme get lightTextTheme => _buildTextTheme(Brightness.light);

  /// Dark theme text styles
  static TextTheme get darkTextTheme => _buildTextTheme(Brightness.dark);

  static TextTheme _buildTextTheme(Brightness brightness) {
    final Color textColor = brightness == Brightness.light
        ? Colors.black87
        : Colors.white;

    return TextTheme(
      // Display styles
      displayLarge: TextStyle(
        fontSize: _mobileBaseSize * _displayScale,
        fontWeight: FontWeight.w300,
        color: textColor,
        letterSpacing: -1.5,
      ),
      displayMedium: TextStyle(
        fontSize: _mobileBaseSize * (_displayScale * 0.85),
        fontWeight: FontWeight.w300,
        color: textColor,
        letterSpacing: -0.5,
      ),
      displaySmall: TextStyle(
        fontSize: _mobileBaseSize * (_displayScale * 0.7),
        fontWeight: FontWeight.w400,
        color: textColor,
      ),

      // Headline styles
      headlineLarge: TextStyle(
        fontSize: _mobileBaseSize * _headlineScale,
        fontWeight: FontWeight.w400,
        color: textColor,
        letterSpacing: -0.25,
      ),
      headlineMedium: TextStyle(
        fontSize: _mobileBaseSize * (_headlineScale * 0.85),
        fontWeight: FontWeight.w400,
        color: textColor,
      ),
      headlineSmall: TextStyle(
        fontSize: _mobileBaseSize * (_headlineScale * 0.7),
        fontWeight: FontWeight.w400,
        color: textColor,
      ),

      // Title styles
      titleLarge: TextStyle(
        fontSize: _mobileBaseSize * _titleScale,
        fontWeight: FontWeight.w500,
        color: textColor,
        letterSpacing: 0.15,
      ),
      titleMedium: TextStyle(
        fontSize: _mobileBaseSize * (_titleScale * 0.9),
        fontWeight: FontWeight.w500,
        color: textColor,
        letterSpacing: 0.15,
      ),
      titleSmall: TextStyle(
        fontSize: _mobileBaseSize * (_titleScale * 0.8),
        fontWeight: FontWeight.w500,
        color: textColor,
        letterSpacing: 0.1,
      ),

      // Body styles
      bodyLarge: TextStyle(
        fontSize: _mobileBaseSize * (_bodyScale * 1.15),
        fontWeight: FontWeight.w400,
        color: textColor,
        letterSpacing: 0.5,
      ),
      bodyMedium: TextStyle(
        fontSize: _mobileBaseSize * _bodyScale,
        fontWeight: FontWeight.w400,
        color: textColor,
        letterSpacing: 0.25,
      ),
      bodySmall: TextStyle(
        fontSize: _mobileBaseSize * (_bodyScale * 0.85),
        fontWeight: FontWeight.w400,
        color: textColor,
        letterSpacing: 0.4,
      ),

      // Label styles
      labelLarge: TextStyle(
        fontSize: _mobileBaseSize * (_labelScale * 1.15),
        fontWeight: FontWeight.w500,
        color: textColor,
        letterSpacing: 1.25,
      ),
      labelMedium: TextStyle(
        fontSize: _mobileBaseSize * _labelScale,
        fontWeight: FontWeight.w500,
        color: textColor,
        letterSpacing: 1.25,
      ),
      labelSmall: TextStyle(
        fontSize: _mobileBaseSize * (_labelScale * 0.85),
        fontWeight: FontWeight.w500,
        color: textColor,
        letterSpacing: 1.5,
      ),
    );
  }

  /// Get responsive font size based on screen width
  static double getResponsiveFontSize(double screenWidth, double baseFontSize) {
    if (screenWidth < 600) {
      // Mobile
      return baseFontSize;
    } else if (screenWidth < 1200) {
      // Tablet
      return baseFontSize * 1.1;
    } else {
      // Desktop
      return baseFontSize * 1.2;
    }
  }

  /// Get responsive text style
  static TextStyle getResponsiveTextStyle(
    BuildContext context, {
    required double baseFontSize,
    FontWeight? fontWeight,
    Color? color,
    double? letterSpacing,
    double? height,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final responsiveFontSize = getResponsiveFontSize(screenWidth, baseFontSize);

    return TextStyle(
      fontSize: responsiveFontSize,
      fontWeight: fontWeight ?? FontWeight.w400,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
    );
  }
}
