import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hpanelx/src/core/api/api_constants.dart';
import 'package:hpanelx/src/core/di/injection_container.dart' as di;
import 'package:hpanelx/src/core/theme/app_theme.dart';
import 'hpanelx.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  _configureEnvironment();

  _configureSystemUI();

  await di.init();

  runApp(const Hpanelx());
}

void _configureEnvironment() {
  ApiConstants.setEnvironment(Environment.production);
}

void _configureSystemUI() {
  AppTheme.setupSystemUI();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
}
