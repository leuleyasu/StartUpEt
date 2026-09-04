import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class ThemeService {
  Future<ThemeMode> getSavedThemeMode();
  Future<void> saveThemeMode(ThemeMode mode);
}

class ThemeServiceImpl implements ThemeService {
  final FlutterSecureStorage _storage;
  static const String _themeStorageKey = 'app_theme_mode';

  ThemeServiceImpl(this._storage);

  @override
  Future<ThemeMode> getSavedThemeMode() async {
    try {
      final savedMode = await _storage.read(key: _themeStorageKey);
      switch (savedMode) {
        case 'light':
          return ThemeMode.light;
        case 'dark':
          return ThemeMode.dark;
        case 'system':
        default:
          return ThemeMode.system;
      }
    } catch (_) {
      return ThemeMode.system;
    }
  }

  @override
  Future<void> saveThemeMode(ThemeMode mode) async {
    try {
      String value;
      switch (mode) {
        case ThemeMode.light:
          value = 'light';
          break;
        case ThemeMode.dark:
          value = 'dark';
          break;
        case ThemeMode.system:
          value = 'system';
          break;
      }
      await _storage.write(key: _themeStorageKey, value: value);
    } catch (_) {
      // Graceful fallback if storage write fails
    }
  }
}
