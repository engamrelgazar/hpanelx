import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hpanelx/src/core/api/api_constants.dart';
import 'package:hpanelx/src/core/di/injection_container.dart' as di;
import 'package:hpanelx/src/core/theme/app_theme.dart';
import 'package:hpanelx/src/core/utils/app_info.dart';
import 'hpanelx.dart';

/// Application entry point
Future<void> main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize app info
  await AppInfo().initialize();

  // Set the environment based on build configuration
  _configureEnvironment();

  // Configure system UI
  _configureSystemUI();

  // Initialize dependency injection
  await di.init();

  // Launch the application
  runApp(const Hpanelx());
}

/// Configure the app environment (can be expanded with build flags)
void _configureEnvironment() {
  final appInfo = AppInfo();

  // Set API environment based on app environment
  switch (appInfo.environment) {
    case BuildEnvironment.production:
      ApiConstants.setEnvironment(Environment.production);
      break;
    case BuildEnvironment.staging:
      ApiConstants.setEnvironment(Environment.staging);
      break;
    case BuildEnvironment.development:
      ApiConstants.setEnvironment(Environment.development);
      break;
  }
}

/// Configure the system UI (status bar, navigation bar)
void _configureSystemUI() {
  // Set up system UI appearance
  AppTheme.setupSystemUI();

  // Set preferred orientations
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
}
