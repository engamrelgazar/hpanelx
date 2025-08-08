import 'package:flutter/material.dart';

class AppVersionWidget extends StatelessWidget {
  final Color? color;

  final TextStyle? style;

  final bool includeBuildNumber;

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
