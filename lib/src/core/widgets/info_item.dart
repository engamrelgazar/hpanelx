import 'package:flutter/material.dart';
import 'package:hpanelx/src/core/utils/responsive_helper.dart';

class InfoItem extends StatelessWidget {
  final IconData? icon;
  final String text;
  final String label;
  final bool isTablet;
  final Color? iconColor;
  final int maxLines;
  final TextStyle? labelStyle;
  final TextStyle? textStyle;

  const InfoItem({
    super.key,
    this.icon,
    required this.text,
    required this.label,
    required this.isTablet,
    this.iconColor,
    this.maxLines = 1,
    this.labelStyle,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (icon != null) ...[
          Icon(
            icon,
            size: isTablet
                ? ResponsiveHelper.responsiveIconSize(context, 18)
                : ResponsiveHelper.responsiveIconSize(context, 16),
            color: iconColor ?? Theme.of(context).primaryColor,
          ),
          SizedBox(width: ResponsiveHelper.w(6, context)),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: labelStyle ??
                    TextStyle(
                      fontSize: isTablet
                          ? ResponsiveHelper.responsiveFontSize(context, 12)
                          : ResponsiveHelper.responsiveFontSize(
                              context,
                              10,
                            ),
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
              ),
              SizedBox(height: ResponsiveHelper.h(2, context)),
              Text(
                text,
                style: textStyle ??
                    TextStyle(
                      fontSize: isTablet
                          ? ResponsiveHelper.responsiveFontSize(context, 14)
                          : ResponsiveHelper.responsiveFontSize(
                              context,
                              12,
                            ),
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                maxLines: maxLines,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
