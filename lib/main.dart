import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hpanelx/src/core/api/api_constants.dart';
import 'package:hpanelx/src/core/di/injection_container.dart' as di;
import 'package:hpanelx/src/core/theme/app_theme.dart';
import 'hpanelx.dart';

/// Application entry point
Future<void> main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();


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
  // Always use production environment
  ApiConstants.setEnvironment(Environment.production);
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
