import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppThemeMode {
  light,
  dark,
  system,
}

class ThemeCubit extends Cubit<AppThemeMode> {
  static const String _prefsKey = 'app_theme_mode';
  final SharedPreferences _prefs;

  ThemeCubit(this._prefs) : super(_loadInitialTheme(_prefs));

  static AppThemeMode _loadInitialTheme(SharedPreferences prefs) {
    final String? savedTheme = prefs.getString(_prefsKey);

    if (savedTheme == null) {
      return AppThemeMode.system;
    }

    return AppThemeMode.values.firstWhere(
      (e) => e.toString() == savedTheme,
      orElse: () => AppThemeMode.system,
    );
  }

  void setLightTheme() => _setTheme(AppThemeMode.light);

  void setDarkTheme() => _setTheme(AppThemeMode.dark);

  void setSystemTheme() => _setTheme(AppThemeMode.system);

  void toggleTheme() {
    if (state == AppThemeMode.light) {
      setDarkTheme();
    } else {
      setLightTheme();
    }
  }

  void _setTheme(AppThemeMode mode) {
    _prefs.setString(_prefsKey, mode.toString());
    emit(mode);
  }

  Brightness getCurrentBrightness(BuildContext context) {
    final Brightness systemBrightness =
        MediaQuery.of(context).platformBrightness;

    switch (state) {
      case AppThemeMode.light:
        return Brightness.light;
      case AppThemeMode.dark:
        return Brightness.dark;
      case AppThemeMode.system:
        return systemBrightness;
    }
  }

  bool isDarkMode(BuildContext context) {
    return getCurrentBrightness(context) == Brightness.dark;
  }

  ThemeMode getThemeMode() {
    switch (state) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.system:
        return ThemeMode.system;
    }
  }
}
