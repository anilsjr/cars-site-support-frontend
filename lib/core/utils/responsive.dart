import 'package:flutter/material.dart';

/// Responsive breakpoints for different screen sizes
class ResponsiveBreakpoints {
  static const double mobile = 600;
  static const double tablet = 900;
  static const double desktop = 1200;
  static const double largeDesktop = 1600;
}

/// Responsive utility class to help with responsive design
class Responsive {
  /// Check if screen is mobile size
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < ResponsiveBreakpoints.mobile;

  /// Check if screen is tablet size
  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= ResponsiveBreakpoints.mobile &&
      MediaQuery.of(context).size.width < ResponsiveBreakpoints.desktop;

  /// Check if screen is desktop size
  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= ResponsiveBreakpoints.desktop;

  /// Check if screen is large desktop size
  static bool isLargeDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= ResponsiveBreakpoints.largeDesktop;

  /// Get the current screen type
  static ResponsiveScreenType getScreenType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width < ResponsiveBreakpoints.mobile) {
      return ResponsiveScreenType.mobile;
    } else if (width < ResponsiveBreakpoints.desktop) {
      return ResponsiveScreenType.tablet;
    } else if (width < ResponsiveBreakpoints.largeDesktop) {
      return ResponsiveScreenType.desktop;
    } else {
      return ResponsiveScreenType.largeDesktop;
    }
  }

  /// Get responsive value based on screen size
  static T getResponsiveValue<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    T? desktop,
    T? largeDesktop,
  }) {
    final screenType = getScreenType(context);

    switch (screenType) {
      case ResponsiveScreenType.mobile:
        return mobile;
      case ResponsiveScreenType.tablet:
        return tablet ?? mobile;
      case ResponsiveScreenType.desktop:
        return desktop ?? tablet ?? mobile;
      case ResponsiveScreenType.largeDesktop:
        return largeDesktop ?? desktop ?? tablet ?? mobile;
    }
  }

  /// Get responsive font size
  static double getFontSize(
    BuildContext context, {
    required double mobile,
    double? tablet,
    double? desktop,
    double? largeDesktop,
  }) {
    return getResponsiveValue(
      context,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
      largeDesktop: largeDesktop,
    );
  }

  /// Get responsive padding
  static EdgeInsets getPadding(
    BuildContext context, {
    required EdgeInsets mobile,
    EdgeInsets? tablet,
    EdgeInsets? desktop,
    EdgeInsets? largeDesktop,
  }) {
    return getResponsiveValue(
      context,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
      largeDesktop: largeDesktop,
    );
  }

  /// Get responsive grid cross axis count
  static int getGridCrossAxisCount(
    BuildContext context, {
    int mobile = 1,
    int? tablet,
    int? desktop,
    int? largeDesktop,
  }) {
    return getResponsiveValue(
      context,
      mobile: mobile,
      tablet: tablet ?? 2,
      desktop: desktop ?? 3,
      largeDesktop: largeDesktop ?? 4,
    );
  }

  /// Get responsive maximum width for content
  static double getMaxContentWidth(BuildContext context) {
    return getResponsiveValue(
      context,
      mobile: double.infinity,
      tablet: 800,
      desktop: 1000,
      largeDesktop: 1200,
    );
  }
}

/// Enum for different screen types
enum ResponsiveScreenType { mobile, tablet, desktop, largeDesktop }

/// Widget that builds different layouts based on screen size
class ResponsiveBuilder extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;
  final Widget? largeDesktop;

  const ResponsiveBuilder({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
    this.largeDesktop,
  });

  @override
  Widget build(BuildContext context) {
    return Responsive.getResponsiveValue(
      context,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
      largeDesktop: largeDesktop,
    );
  }
}

/// Responsive layout builder that provides screen size information
class ResponsiveLayoutBuilder extends StatelessWidget {
  final Widget Function(
    BuildContext context,
    ResponsiveScreenType screenType,
    double width,
  )
  builder;

  const ResponsiveLayoutBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenType = Responsive.getScreenType(context);
        return builder(context, screenType, constraints.maxWidth);
      },
    );
  }
}
