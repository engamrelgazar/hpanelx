import 'package:flutter/material.dart';
/// A widget that displays the application version information
class AppVersionWidget extends StatelessWidget {
  /// The text color
  final Color? color;

  /// The text style
  final TextStyle? style;

  /// Whether to include the build number
  final bool includeBuildNumber;

  /// Creates an app version widget
  const AppVersionWidget({
    super.key,
    this.color,
    this.style,
    this.includeBuildNumber = true,
  });

  @override
  Widget build(BuildContext context) {
    final defaultStyle = Theme.of(context).textTheme.bodySmall;

    final TextStyle textStyle = (style ?? defaultStyle!).copyWith(
      color: color ?? defaultStyle?.color ?? Colors.grey,
    );

    return Text(
      'v1.0.1',
      style: textStyle,
    );
  }
}
