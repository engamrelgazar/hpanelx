import 'package:flutter/material.dart';
import 'package:hpanelx/src/core/utils/responsive_helper.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobileLayout;
  final Widget? tabletLayout;
  final Widget? desktopLayout;

  const ResponsiveLayout({
    super.key,
    required this.mobileLayout,
    this.tabletLayout,
    this.desktopLayout,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, isMobile, isTablet, isDesktop) {
        if (isDesktop && desktopLayout != null) {
          return desktopLayout!;
        } else if (isTablet && tabletLayout != null) {
          return tabletLayout!;
        } else {
          return mobileLayout;
        }
      },
    );
  }
}

/// A widget that adapts its child's padding based on the screen size.
class ResponsivePadding extends StatelessWidget {
  final Widget child;
  final EdgeInsets? mobilePadding;
  final EdgeInsets? tabletPadding;
  final EdgeInsets? desktopPadding;

  const ResponsivePadding({
    super.key,
    required this.child,
    this.mobilePadding,
    this.tabletPadding,
    this.desktopPadding,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, isMobile, isTablet, isDesktop) {
        EdgeInsets padding;

        if (isDesktop && desktopPadding != null) {
          padding = desktopPadding!;
        } else if (isTablet && tabletPadding != null) {
          padding = tabletPadding!;
        } else if (mobilePadding != null) {
          padding = mobilePadding!;
        } else {
          padding = ResponsiveHelper.responsivePadding(context);
        }

        return Padding(padding: padding, child: child);
      },
    );
  }
}

/// A widget that creates a responsive grid layout.
class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final int mobileCrossAxisCount;
  final int? tabletCrossAxisCount;
  final int? desktopCrossAxisCount;
  final double spacing;
  final double runSpacing;

  const ResponsiveGrid({
    super.key,
    required this.children,
    required this.mobileCrossAxisCount,
    this.tabletCrossAxisCount,
    this.desktopCrossAxisCount,
    this.spacing = 10,
    this.runSpacing = 10,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, isMobile, isTablet, isDesktop) {
        final crossAxisCount =
            isDesktop && desktopCrossAxisCount != null
                ? desktopCrossAxisCount!
                : isTablet && tabletCrossAxisCount != null
                ? tabletCrossAxisCount!
                : mobileCrossAxisCount;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: spacing,
            mainAxisSpacing: runSpacing,
          ),
          itemCount: children.length,
          itemBuilder: (context, index) => children[index],
        );
      },
    );
  }
}
