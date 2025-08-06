import 'package:flutter/material.dart';
import 'package:hpanelx/src/core/utils/responsive_helper.dart';

class SpecItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isTablet;
  final Color? iconColor;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;

  const SpecItem({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.isTablet,
    this.iconColor,
    this.labelStyle,
    this.valueStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          size: isTablet
              ? ResponsiveHelper.responsiveIconSize(context, 20)
              : ResponsiveHelper.responsiveIconSize(context, 18),
          color: iconColor ?? Theme.of(context).textTheme.bodyMedium?.color,
        ),
        SizedBox(height: ResponsiveHelper.h(4, context)),
        Text(
          label,
          style: labelStyle ??
              TextStyle(
                fontSize: isTablet
                    ? ResponsiveHelper.responsiveFontSize(context, 12)
                    : ResponsiveHelper.responsiveFontSize(context, 10),
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
        ),
        SizedBox(height: ResponsiveHelper.h(2, context)),
        Text(
          value,
          style: valueStyle ??
              TextStyle(
                fontSize: isTablet
                    ? ResponsiveHelper.responsiveFontSize(context, 14)
                    : ResponsiveHelper.responsiveFontSize(context, 12),
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
        ),
      ],
    );
  }
}
