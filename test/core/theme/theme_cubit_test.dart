import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:startupet/core/theme/cubit/theme_cubit.dart';
import 'package:startupet/core/theme/cubit/theme_state.dart';
import 'package:startupet/core/theme/theme_service.dart';

class MockThemeService implements ThemeService {
  ThemeMode _savedMode = ThemeMode.system;

  @override
  Future<ThemeMode> getSavedThemeMode() async {
    return _savedMode;
  }

  @override
  Future<void> saveThemeMode(ThemeMode mode) async {
    _savedMode = mode;
  }
}

void main() {
  // Tests commented out per user request
  /*
  group('ThemeCubit Tests', () {
    late MockThemeService mockThemeService;
    late ThemeCubit themeCubit;

    setUp(() {
      mockThemeService = MockThemeService();
      themeCubit = ThemeCubit(mockThemeService);
    });

    tearDown(() {
      themeCubit.close();
    });

    test('initial state has ThemeMode.system', () {
      expect(themeCubit.state.themeMode, ThemeMode.system);
    });

    test('loadTheme retrieves saved theme from ThemeService', () async {
      await mockThemeService.saveThemeMode(ThemeMode.dark);
      await themeCubit.loadTheme();

      expect(themeCubit.state.themeMode, ThemeMode.dark);
    });

    test('setThemeMode updates state and persists mode', () async {
      await themeCubit.setThemeMode(ThemeMode.light);

      expect(themeCubit.state.themeMode, ThemeMode.light);
      expect(await mockThemeService.getSavedThemeMode(), ThemeMode.light);

      await themeCubit.setThemeMode(ThemeMode.dark);

      expect(themeCubit.state.themeMode, ThemeMode.dark);
      expect(await mockThemeService.getSavedThemeMode(), ThemeMode.dark);
    });

    test('cycleTheme cycles through system -> light -> dark -> system', () async {
      expect(themeCubit.state.themeMode, ThemeMode.system);

      await themeCubit.cycleTheme();
      expect(themeCubit.state.themeMode, ThemeMode.light);

      await themeCubit.cycleTheme();
      expect(themeCubit.state.themeMode, ThemeMode.dark);

      await themeCubit.cycleTheme();
      expect(themeCubit.state.themeMode, ThemeMode.system);
    });

    test('ThemeState props test', () {
      const state1 = ThemeState(themeMode: ThemeMode.light);
      const state2 = ThemeState(themeMode: ThemeMode.light);
      const state3 = ThemeState(themeMode: ThemeMode.dark);

      expect(state1, equals(state2));
      expect(state1, isNot(equals(state3)));
    });
  });
  */
}
