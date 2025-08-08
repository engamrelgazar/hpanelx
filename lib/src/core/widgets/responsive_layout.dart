import 'package:flutter/material.dart';
import 'package:hpanelx/src/core/utils/responsive_helper.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;

  final Widget? tablet;

  final Widget? desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
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

class ResponsivePadding extends StatelessWidget {
  final Widget child;

  final bool horizontal;

  final bool vertical;

  final EdgeInsets? mobilePadding;
  final EdgeInsets? tabletPadding;
  final EdgeInsets? desktopPadding;

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

class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;

  final int mobileColumns;
  final int tabletColumns;
  final int desktopColumns;

  final double crossAxisSpacing;
  final double mainAxisSpacing;

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
