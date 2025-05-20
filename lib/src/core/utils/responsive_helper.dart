import 'package:flutter/material.dart';

class ResponsiveHelper {
  // Design sizes based on iPhone 13 Pro dimensions
  static const double designWidth = 390;
  static const double designHeight = 844;

  // Store screen size to avoid multiple MediaQuery calls
  static Size? _cachedScreenSize;

  // Get screen size efficiently
  static Size getScreenSize(BuildContext context) {
    _cachedScreenSize ??= MediaQuery.of(context).size;
    return _cachedScreenSize!;
  }

  // Reset cached size (should be called when orientation changes)
  static void resetCachedSize() {
    _cachedScreenSize = null;
  }

  static bool isMobile(BuildContext context) =>
      getScreenSize(context).width < 600;

  static bool isTablet(BuildContext context) =>
      getScreenSize(context).width >= 600 &&
      getScreenSize(context).width < 1200;

  static bool isDesktop(BuildContext context) =>
      getScreenSize(context).width >= 1200;

  static double getScreenWidth(BuildContext context) =>
      getScreenSize(context).width;

  static double getScreenHeight(BuildContext context) =>
      getScreenSize(context).height;

  static Widget responsiveBuilder({
    required BuildContext context,
    required Widget mobile,
    Widget? tablet,
    Widget? desktop,
  }) {
    if (isDesktop(context) && desktop != null) {
      return desktop;
    } else if (isTablet(context) && tablet != null) {
      return tablet;
    } else {
      return mobile;
    }
  }

  // Get responsive value based on screen size
  static T responsiveValue<T>({
    required BuildContext context,
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    if (isDesktop(context) && desktop != null) {
      return desktop;
    } else if (isTablet(context) && tablet != null) {
      return tablet;
    } else {
      return mobile;
    }
  }

  // Get responsive padding
  static EdgeInsets responsivePadding(BuildContext context) {
    if (isDesktop(context)) {
      return EdgeInsets.symmetric(
        horizontal: getScreenWidth(context) * 0.1,
        vertical: 24,
      );
    } else if (isTablet(context)) {
      return const EdgeInsets.symmetric(horizontal: 24, vertical: 16);
    } else {
      return const EdgeInsets.symmetric(horizontal: 16, vertical: 12);
    }
  }

  // Get responsive spacing
  static double responsiveSpacing(BuildContext context) {
    if (isDesktop(context)) {
      return 24;
    } else if (isTablet(context)) {
      return 16;
    } else {
      return 12;
    }
  }

  // Get responsive font size
  static double responsiveFontSize(BuildContext context, double baseFontSize) {
    if (isDesktop(context)) {
      return baseFontSize * 1.2;
    } else if (isTablet(context)) {
      return baseFontSize * 1.1;
    } else {
      return baseFontSize;
    }
  }

  // Get responsive icon size
  static double responsiveIconSize(BuildContext context, double baseIconSize) {
    if (isDesktop(context)) {
      return baseIconSize * 1.3;
    } else if (isTablet(context)) {
      return baseIconSize * 1.2;
    } else {
      return baseIconSize;
    }
  }

  // Convert ScreenUtil dimensions to responsive dimensions
  static double w(double width, BuildContext context) {
    return width * getScreenWidth(context) / designWidth;
  }

  static double h(double height, BuildContext context) {
    return height * getScreenHeight(context) / designHeight;
  }

  static double r(double radius, BuildContext context) {
    double scale = isMobile(context)
        ? 1
        : isTablet(context)
            ? 1.1
            : 1.2;
    return radius * scale;
  }

  static double sp(double fontSize, BuildContext context) {
    return responsiveFontSize(context, fontSize);
  }
}

// A widget that makes building responsive UIs easier
class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(
    BuildContext context,
    bool isMobile,
    bool isTablet,
    bool isDesktop,
  ) builder;

  const ResponsiveBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    // Reset cached size on each build to ensure we have the latest values
    ResponsiveHelper.resetCachedSize();

    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final isDesktop = ResponsiveHelper.isDesktop(context);

    return builder(context, isMobile, isTablet, isDesktop);
  }
}

// A widget that replaces ScreenUtilInit
class ResponsiveWrapper extends StatelessWidget {
  final Widget child;

  const ResponsiveWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // Reset cached size to ensure we have the latest values
    ResponsiveHelper.resetCachedSize();
    // This widget doesn't actually do any initialization like ScreenUtilInit did
    // Instead, we rely on MediaQuery in the ResponsiveHelper methods
    return child;
  }
}
