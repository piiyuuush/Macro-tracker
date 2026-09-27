import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _themeModeKey = 'themeMode';

ThemeMode _decode(String? raw) {
  switch (raw) {
    case 'light':
      return ThemeMode.light;
    case 'dark':
      return ThemeMode.dark;
    default:
      return ThemeMode.system;
  }
}

/// Holds the app [ThemeMode].
///
/// Loads the persisted value before the first frame so callers can gate
/// their UI on [AsyncValue] and avoid a light/dark flash on cold start.
/// Values stored as 'system' | 'light' | 'dark' ('dark' = AMOLED pure black).
class ThemeModeNotifier extends AsyncNotifier<ThemeMode> {
  @override
  Future<ThemeMode> build() async {
    final prefs = await SharedPreferences.getInstance();
    return _decode(prefs.getString(_themeModeKey));
  }

  Future<void> setTheme(ThemeMode mode) async {
    state = AsyncData(mode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeModeKey, mode.name);
  }

  Future<void> followSystem(bool value) async {
    if (value) {
      await setTheme(ThemeMode.system);
    } else {
      // When turning off "follow system", fall back to light so the
      // user can then pick Light / AMOLED explicitly.
      await setTheme(ThemeMode.light);
    }
  }
}

final themeModeProvider =
    AsyncNotifierProvider<ThemeModeNotifier, ThemeMode>(ThemeModeNotifier.new);
