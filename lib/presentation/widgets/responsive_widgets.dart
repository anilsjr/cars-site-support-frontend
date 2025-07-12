import 'package:flutter/material.dart';
import '../../core/utils/responsive.dart';

/// A responsive container that adapts its layout based on screen size
class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? maxWidth;
  final bool centerContent;

  const ResponsiveContainer({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.maxWidth,
    this.centerContent = true,
  });

  @override
  Widget build(BuildContext context) {
    final responsivePadding =
        padding ??
        Responsive.getPadding(
          context,
          mobile: const EdgeInsets.all(16),
          tablet: const EdgeInsets.all(24),
          desktop: const EdgeInsets.all(32),
        );

    final responsiveMaxWidth =
        maxWidth ?? Responsive.getMaxContentWidth(context);

    Widget content = Container(
      padding: responsivePadding,
      margin: margin,
      constraints: BoxConstraints(maxWidth: responsiveMaxWidth),
      child: child,
    );

    if (centerContent && Responsive.isDesktop(context)) {
      return Center(child: content);
    }

    return content;
  }
}

/// A responsive grid that adapts its column count based on screen size
class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final int? mobileColumns;
  final int? tabletColumns;
  final int? desktopColumns;
  final int? largeDesktopColumns;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final double? childAspectRatio;
  final EdgeInsets? padding;

  const ResponsiveGrid({
    super.key,
    required this.children,
    this.mobileColumns,
    this.tabletColumns,
    this.desktopColumns,
    this.largeDesktopColumns,
    this.crossAxisSpacing = 16,
    this.mainAxisSpacing = 16,
    this.childAspectRatio,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final crossAxisCount = Responsive.getGridCrossAxisCount(
      context,
      mobile: mobileColumns ?? 1,
      tablet: tabletColumns ?? 2,
      desktop: desktopColumns ?? 3,
      largeDesktop: largeDesktopColumns ?? 4,
    );

    final responsivePadding =
        padding ??
        Responsive.getPadding(
          context,
          mobile: const EdgeInsets.all(16),
          tablet: const EdgeInsets.all(24),
          desktop: const EdgeInsets.all(32),
        );

    return Padding(
      padding: responsivePadding,
      child: GridView.count(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: crossAxisSpacing,
        mainAxisSpacing: mainAxisSpacing,
        childAspectRatio: childAspectRatio ?? 1.0,
        children: children,
      ),
    );
  }
}

/// A responsive row that stacks vertically on smaller screens
class ResponsiveRow extends StatelessWidget {
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;
  final bool stackOnMobile;
  final bool stackOnTablet;

  const ResponsiveRow({
    super.key,
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.max,
    this.stackOnMobile = true,
    this.stackOnTablet = false,
  });

  @override
  Widget build(BuildContext context) {
    final shouldStack =
        (Responsive.isMobile(context) && stackOnMobile) ||
        (Responsive.isTablet(context) && stackOnTablet);

    if (shouldStack) {
      return Column(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        mainAxisSize: mainAxisSize,
        children: children,
      );
    }

    return Row(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      children: children,
    );
  }
}

/// A responsive column that becomes a row on larger screens
class ResponsiveColumn extends StatelessWidget {
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;
  final bool rowOnDesktop;
  final bool rowOnTablet;

  const ResponsiveColumn({
    super.key,
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.max,
    this.rowOnDesktop = false,
    this.rowOnTablet = false,
  });

  @override
  Widget build(BuildContext context) {
    final shouldUseRow =
        (Responsive.isDesktop(context) && rowOnDesktop) ||
        (Responsive.isTablet(context) && rowOnTablet);

    if (shouldUseRow) {
      return Row(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        mainAxisSize: mainAxisSize,
        children: children,
      );
    }

    return Column(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      children: children,
    );
  }
}

/// A responsive card with adaptive sizing and spacing
class ResponsiveCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final VoidCallback? onTap;
  final double? elevation;

  const ResponsiveCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.elevation,
  });

  @override
  Widget build(BuildContext context) {
    final responsivePadding =
        padding ??
        Responsive.getPadding(
          context,
          mobile: const EdgeInsets.all(12),
          tablet: const EdgeInsets.all(16),
          desktop: const EdgeInsets.all(20),
        );

    final responsiveMargin =
        margin ??
        Responsive.getPadding(
          context,
          mobile: const EdgeInsets.all(4),
          tablet: const EdgeInsets.all(6),
          desktop: const EdgeInsets.all(8),
        );

    final card = Card(
      elevation: elevation,
      margin: responsiveMargin,
      child: Padding(padding: responsivePadding, child: child),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: card,
      );
    }

    return card;
  }
}

/// A responsive text widget that adapts font size based on screen size
class ResponsiveText extends StatelessWidget {
  final String text;
  final double? mobileFontSize;
  final double? tabletFontSize;
  final double? desktopFontSize;
  final double? largeDesktopFontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextStyle? baseStyle;

  const ResponsiveText(
    this.text, {
    super.key,
    this.mobileFontSize,
    this.tabletFontSize,
    this.desktopFontSize,
    this.largeDesktopFontSize,
    this.fontWeight,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.baseStyle,
  });

  @override
  Widget build(BuildContext context) {
    final fontSize = Responsive.getFontSize(
      context,
      mobile: mobileFontSize ?? 14,
      tablet: tabletFontSize,
      desktop: desktopFontSize,
      largeDesktop: largeDesktopFontSize,
    );

    return Text(
      text,
      style: (baseStyle ?? const TextStyle()).copyWith(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
