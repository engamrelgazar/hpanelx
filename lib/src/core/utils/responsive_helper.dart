import 'package:flutter/material.dart';

/// A utility class that provides methods for responsive design in Flutter applications.
///
/// This helper class includes methods for determining device types (mobile, tablet, desktop),
/// calculating responsive dimensions, and providing responsive widgets and values.
class ResponsiveHelper {
  // Design sizes based on iPhone 13 Pro dimensions
  static const double designWidth = 390;
  static const double designHeight = 844;

  // Breakpoints for different device types
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 1200;

  // Store screen size to avoid multiple MediaQuery calls
  static Size? _cachedScreenSize;
  static BuildContext? _cachedContext;

  /// Gets the screen size efficiently, using cached value if context hasn't changed
  static Size getScreenSize(BuildContext context) {
    if (_cachedContext != context) {
      _cachedScreenSize = MediaQuery.of(context).size;
      _cachedContext = context;
    }
    return _cachedScreenSize!;
  }

  /// Resets cached size (should be called when orientation changes)
  static void resetCachedSize() {
    _cachedScreenSize = null;
    _cachedContext = null;
  }

  /// Checks if the device is a mobile device based on screen width
  static bool isMobile(BuildContext context) =>
      getScreenSize(context).width < mobileBreakpoint;

  /// Checks if the device is a tablet based on screen width
  static bool isTablet(BuildContext context) =>
      getScreenSize(context).width >= mobileBreakpoint &&
      getScreenSize(context).width < tabletBreakpoint;

  /// Checks if the device is a desktop based on screen width
  static bool isDesktop(BuildContext context) =>
      getScreenSize(context).width >= tabletBreakpoint;

  /// Gets the screen width
  static double getScreenWidth(BuildContext context) =>
      getScreenSize(context).width;

  /// Gets the screen height
  static double getScreenHeight(BuildContext context) =>
      getScreenSize(context).height;

  /// A builder widget that returns different widgets based on screen size
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

  /// Returns a responsive value based on screen size
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

  /// Returns responsive padding based on screen size
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

  /// Returns responsive margin based on screen size
  static EdgeInsets responsiveMargin(BuildContext context) {
    if (isDesktop(context)) {
      return const EdgeInsets.symmetric(horizontal: 32, vertical: 24);
    } else if (isTablet(context)) {
      return const EdgeInsets.symmetric(horizontal: 24, vertical: 16);
    } else {
      return const EdgeInsets.symmetric(horizontal: 16, vertical: 12);
    }
  }

  /// Returns responsive spacing based on screen size
  static double responsiveSpacing(BuildContext context) {
    if (isDesktop(context)) {
      return 24;
    } else if (isTablet(context)) {
      return 16;
    } else {
      return 12;
    }
  }

  /// Returns responsive font size based on screen size
  static double responsiveFontSize(BuildContext context, double baseFontSize) {
    if (isDesktop(context)) {
      return baseFontSize * 1.2;
    } else if (isTablet(context)) {
      return baseFontSize * 1.1;
    } else {
      return baseFontSize;
    }
  }

  /// Returns responsive icon size based on screen size
  static double responsiveIconSize(BuildContext context, double baseIconSize) {
    if (isDesktop(context)) {
      return baseIconSize * 1.3;
    } else if (isTablet(context)) {
      return baseIconSize * 1.2;
    } else {
      return baseIconSize;
    }
  }

  /// Calculates width based on design width (similar to ScreenUtil)
  static double w(double width, BuildContext context) {
    return width * getScreenWidth(context) / designWidth;
  }

  /// Calculates height based on design height (similar to ScreenUtil)
  static double h(double height, BuildContext context) {
    return height * getScreenHeight(context) / designHeight;
  }

  /// Calculates responsive radius
  static double r(double radius, BuildContext context) {
    double scale = isMobile(context)
        ? 1
        : isTablet(context)
            ? 1.1
            : 1.2;
    return radius * scale;
  }

  /// Calculates responsive font size (similar to ScreenUtil's sp)
  static double sp(double fontSize, BuildContext context) {
    return responsiveFontSize(context, fontSize);
  }
}

/// A widget that makes building responsive UIs easier
class ResponsiveBuilder extends StatelessWidget {
  /// Function that builds widget based on screen size information
  final Widget Function(
    BuildContext context,
    bool isMobile,
    bool isTablet,
    bool isDesktop,
  ) builder;

  /// Creates a new [ResponsiveBuilder] widget
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

/// A widget that replaces ScreenUtilInit for responsive design
class ResponsiveWrapper extends StatelessWidget {
  /// The child widget to be wrapped
  final Widget child;

  /// Creates a new [ResponsiveWrapper] widget
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
