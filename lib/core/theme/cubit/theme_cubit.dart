import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../theme_service.dart';
import 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  final ThemeService _themeService;

  ThemeCubit(this._themeService)
      : super(const ThemeState(themeMode: ThemeMode.system));

  /// Loads the persisted theme mode from local storage.
  Future<void> loadTheme() async {
    final savedMode = await _themeService.getSavedThemeMode();
    emit(state.copyWith(themeMode: savedMode));
  }

  /// Updates the theme mode and persists the preference.
  Future<void> setThemeMode(ThemeMode mode) async {
    if (state.themeMode == mode) return;
    emit(state.copyWith(themeMode: mode));
    await _themeService.saveThemeMode(mode);
  }

  /// Cycles between System -> Light -> Dark -> System
  Future<void> cycleTheme() async {
    final nextMode = switch (state.themeMode) {
      ThemeMode.system => ThemeMode.light,
      ThemeMode.light => ThemeMode.dark,
      ThemeMode.dark => ThemeMode.system,
    };
    await setThemeMode(nextMode);
  }
}
