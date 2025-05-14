import 'package:flutter/material.dart';
import 'package:hpanelx/src/core/utils/responsive_helper.dart';

/// A container that adapts its constraints based on screen size.
class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final double? mobileWidth;
  final double? tabletWidth;
  final double? desktopWidth;
  final double? mobileHeight;
  final double? tabletHeight;
  final double? desktopHeight;
  final BoxConstraints? mobileConstraints;
  final BoxConstraints? tabletConstraints;
  final BoxConstraints? desktopConstraints;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Decoration? decoration;
  final Color? color;
  final Alignment? alignment;

  const ResponsiveContainer({
    super.key,
    required this.child,
    this.mobileWidth,
    this.tabletWidth,
    this.desktopWidth,
    this.mobileHeight,
    this.tabletHeight,
    this.desktopHeight,
    this.mobileConstraints,
    this.tabletConstraints,
    this.desktopConstraints,
    this.padding,
    this.margin,
    this.decoration,
    this.color,
    this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, isMobile, isTablet, isDesktop) {
        // Determine width
        double? width;
        if (isDesktop && desktopWidth != null) {
          width = desktopWidth;
        } else if (isTablet && tabletWidth != null) {
          width = tabletWidth;
        } else if (mobileWidth != null) {
          width = mobileWidth;
        }

        // Determine height
        double? height;
        if (isDesktop && desktopHeight != null) {
          height = desktopHeight;
        } else if (isTablet && tabletHeight != null) {
          height = tabletHeight;
        } else if (mobileHeight != null) {
          height = mobileHeight;
        }

        // Determine constraints
        BoxConstraints? constraints;
        if (isDesktop && desktopConstraints != null) {
          constraints = desktopConstraints;
        } else if (isTablet && tabletConstraints != null) {
          constraints = tabletConstraints;
        } else if (mobileConstraints != null) {
          constraints = mobileConstraints;
        }

        return Container(
          width: width,
          height: height,
          constraints: constraints,
          padding: padding,
          margin: margin,
          decoration: decoration,
          color: color,
          alignment: alignment,
          child: child,
        );
      },
    );
  }
}
