import 'package:flutter/material.dart';
import 'package:hpanelx/src/core/di/injection_container.dart' as di;
import 'package:hpanelx/src/core/theme/app_theme.dart';
import 'hpanelx.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Configure status bar color to match app theme
  AppTheme.setupSystemUI();

  // Initialize dependency injection
  await di.init();

  // Launch the application
  runApp(const Hpanelx());
}
