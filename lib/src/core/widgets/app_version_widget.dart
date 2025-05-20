import 'package:flutter/material.dart';
import 'package:hpanelx/src/core/utils/app_info.dart';

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
    final appInfo = AppInfo();
    final defaultStyle = Theme.of(context).textTheme.bodySmall;

    final TextStyle textStyle = (style ?? defaultStyle!).copyWith(
      color: color ?? defaultStyle?.color ?? Colors.grey,
    );

    final String versionText = includeBuildNumber
        ? 'v${appInfo.versionWithBuild}'
        : 'v${appInfo.packageInfo.version}';

    return Text(
      versionText,
      style: textStyle,
    );
  }
}
