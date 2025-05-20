import 'package:flutter/material.dart';
import 'package:hpanelx/src/core/utils/responsive_helper.dart';

/// A widget that provides different layouts based on screen size
class ResponsiveLayout extends StatelessWidget {
  /// The widget to display on mobile screens
  final Widget mobile;

  /// The widget to display on tablet screens (optional)
  final Widget? tablet;

  /// The widget to display on desktop screens (optional)
  final Widget? desktop;

  /// Creates a responsive layout that adapts to different screen sizes
  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    // This ensures we reset the cached size if the orientation or size changes
    ResponsiveHelper.resetCachedSize();

    return LayoutBuilder(
      builder: (context, constraints) {
        if (ResponsiveHelper.isDesktop(context) && desktop != null) {
          return desktop!;
        } else if (ResponsiveHelper.isTablet(context) && tablet != null) {
          return tablet!;
        } else {
          return mobile;
        }
      },
    );
  }
}

/// A widget that wraps content with responsive padding based on screen size
class ResponsivePadding extends StatelessWidget {
  /// The child widget to be wrapped with padding
  final Widget child;

  /// Whether to apply horizontal padding
  final bool horizontal;

  /// Whether to apply vertical padding
  final bool vertical;

  /// Custom padding values by screen size
  final EdgeInsets? mobilePadding;
  final EdgeInsets? tabletPadding;
  final EdgeInsets? desktopPadding;

  /// Creates a widget that applies responsive padding
  const ResponsivePadding({
    super.key,
    required this.child,
    this.horizontal = true,
    this.vertical = true,
    this.mobilePadding,
    this.tabletPadding,
    this.desktopPadding,
  });

  @override
  Widget build(BuildContext context) {
    EdgeInsets padding;

    if (ResponsiveHelper.isDesktop(context)) {
      padding = desktopPadding ??
          EdgeInsets.symmetric(
            horizontal: horizontal ? 32.0 : 0.0,
            vertical: vertical ? 24.0 : 0.0,
          );
    } else if (ResponsiveHelper.isTablet(context)) {
      padding = tabletPadding ??
          EdgeInsets.symmetric(
            horizontal: horizontal ? 24.0 : 0.0,
            vertical: vertical ? 16.0 : 0.0,
          );
    } else {
      padding = mobilePadding ??
          EdgeInsets.symmetric(
            horizontal: horizontal ? 16.0 : 0.0,
            vertical: vertical ? 12.0 : 0.0,
          );
    }

    return Padding(
      padding: padding,
      child: child,
    );
  }
}

/// A widget that creates responsive grid layouts
class ResponsiveGrid extends StatelessWidget {
  /// List of child widgets to display in the grid
  final List<Widget> children;

  /// Number of columns for each screen size
  final int mobileColumns;
  final int tabletColumns;
  final int desktopColumns;

  /// Spacing between items
  final double crossAxisSpacing;
  final double mainAxisSpacing;

  /// Creates a responsive grid layout
  const ResponsiveGrid({
    super.key,
    required this.children,
    this.mobileColumns = 1,
    this.tabletColumns = 2,
    this.desktopColumns = 4,
    this.crossAxisSpacing = 16.0,
    this.mainAxisSpacing = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    int columns;

    if (ResponsiveHelper.isDesktop(context)) {
      columns = desktopColumns;
    } else if (ResponsiveHelper.isTablet(context)) {
      columns = tabletColumns;
    } else {
      columns = mobileColumns;
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: crossAxisSpacing,
        mainAxisSpacing: mainAxisSpacing,
        childAspectRatio: 1.0,
      ),
      itemCount: children.length,
      itemBuilder: (context, index) => children[index],
    );
  }
}
