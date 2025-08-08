import 'package:flutter/material.dart';

class ResponsiveHelper {
  static const double designWidth = 390;
  static const double designHeight = 844;

  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 1200;

  static Size? _cachedScreenSize;
  static BuildContext? _cachedContext;

  static Size getScreenSize(BuildContext context) {
    if (_cachedContext != context) {
      _cachedScreenSize = MediaQuery.of(context).size;
      _cachedContext = context;
    }
    return _cachedScreenSize!;
  }

  static void resetCachedSize() {
    _cachedScreenSize = null;
    _cachedContext = null;
  }

  static bool isMobile(BuildContext context) =>
      getScreenSize(context).width < mobileBreakpoint;

  static bool isTablet(BuildContext context) =>
      getScreenSize(context).width >= mobileBreakpoint &&
      getScreenSize(context).width < tabletBreakpoint;

  static bool isDesktop(BuildContext context) =>
      getScreenSize(context).width >= tabletBreakpoint;

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

  static EdgeInsets responsiveMargin(BuildContext context) {
    if (isDesktop(context)) {
      return const EdgeInsets.symmetric(horizontal: 32, vertical: 24);
    } else if (isTablet(context)) {
      return const EdgeInsets.symmetric(horizontal: 24, vertical: 16);
    } else {
      return const EdgeInsets.symmetric(horizontal: 16, vertical: 12);
    }
  }

  static double responsiveSpacing(BuildContext context) {
    if (isDesktop(context)) {
      return 24;
    } else if (isTablet(context)) {
      return 16;
    } else {
      return 12;
    }
  }

  static double responsiveFontSize(BuildContext context, double baseFontSize) {
    if (isDesktop(context)) {
      return baseFontSize * 1.2;
    } else if (isTablet(context)) {
      return baseFontSize * 1.1;
    } else {
      return baseFontSize;
    }
  }

  static double responsiveIconSize(BuildContext context, double baseIconSize) {
    if (isDesktop(context)) {
      return baseIconSize * 1.3;
    } else if (isTablet(context)) {
      return baseIconSize * 1.2;
    } else {
      return baseIconSize;
    }
  }

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
    ResponsiveHelper.resetCachedSize();

    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final isDesktop = ResponsiveHelper.isDesktop(context);

    return builder(context, isMobile, isTablet, isDesktop);
  }
}

class ResponsiveWrapper extends StatelessWidget {
  final Widget child;

  const ResponsiveWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.resetCachedSize();
    return child;
  }
}
