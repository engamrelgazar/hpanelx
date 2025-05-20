import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Theme mode states for the application
enum AppThemeMode {
  light,
  dark,
  system,
}

/// Cubit for managing application theme
class ThemeCubit extends Cubit<AppThemeMode> {
  static const String _prefsKey = 'app_theme_mode';
  final SharedPreferences _prefs;

  ThemeCubit(this._prefs) : super(_loadInitialTheme(_prefs));

  /// Load the saved theme mode from shared preferences
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

  /// Set the theme mode to light
  void setLightTheme() => _setTheme(AppThemeMode.light);

  /// Set the theme mode to dark
  void setDarkTheme() => _setTheme(AppThemeMode.dark);

  /// Set the theme mode to follow system settings
  void setSystemTheme() => _setTheme(AppThemeMode.system);

  /// Toggle between light and dark theme
  void toggleTheme() {
    if (state == AppThemeMode.light) {
      setDarkTheme();
    } else {
      setLightTheme();
    }
  }

  /// Set the theme mode and save to shared preferences
  void _setTheme(AppThemeMode mode) {
    _prefs.setString(_prefsKey, mode.toString());
    emit(mode);
  }

  /// Get the current brightness based on the theme mode and system brightness
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

  /// Check if the current theme is dark
  bool isDarkMode(BuildContext context) {
    return getCurrentBrightness(context) == Brightness.dark;
  }

  /// Convert our custom AppThemeMode to Flutter's ThemeMode
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
