import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Environment configurations
enum BuildEnvironment {
  development,
  staging,
  production,
}

/// Application information and configuration
class AppInfo {
  /// Singleton instance
  static final AppInfo _instance = AppInfo._internal();

  /// Factory constructor
  factory AppInfo() => _instance;

  /// Internal constructor
  AppInfo._internal();

  /// The current build environment
  late BuildEnvironment environment;

  /// Package information
  late PackageInfo packageInfo;

  /// Whether this is a debug build
  bool get isDebug => kDebugMode;

  /// Whether this is a release build
  bool get isRelease => kReleaseMode;

  /// Whether this is a profile build
  bool get isProfile => kProfileMode;

  /// Whether this is a production environment
  bool get isProduction => environment == BuildEnvironment.production;

  /// App version with build number
  String get versionWithBuild =>
      '${packageInfo.version}+${packageInfo.buildNumber}';

  /// Initialize the app info
  Future<void> initialize() async {
    // Set environment based on build flags
    _initializeEnvironment();

    // Get package info
    packageInfo = await PackageInfo.fromPlatform();

    // Log info in debug mode
    if (isDebug) {
      _logAppInfo();
    }
  }

  /// Initialize environment based on build flags
  void _initializeEnvironment() {
    const envName = String.fromEnvironment(
      'ENVIRONMENT',
      defaultValue: 'development',
    );

    switch (envName.toLowerCase()) {
      case 'production':
        environment = BuildEnvironment.production;
        break;
      case 'staging':
        environment = BuildEnvironment.staging;
        break;
      default:
        environment = BuildEnvironment.development;
        break;
    }
  }

  /// Log app information in debug mode
  void _logAppInfo() {
    debugPrint('---------- APP INFO ----------');
    debugPrint('App Name: ${packageInfo.appName}');
    debugPrint('Package Name: ${packageInfo.packageName}');
    debugPrint('Version: ${packageInfo.version}');
    debugPrint('Build Number: ${packageInfo.buildNumber}');
    debugPrint('Environment: ${environment.name}');
    debugPrint('Debug Mode: $isDebug');
    debugPrint('Release Mode: $isRelease');
    debugPrint('Profile Mode: $isProfile');
    debugPrint('-----------------------------');
  }
}
