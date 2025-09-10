import 'package:app/models/theme_state_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show SchedulerBinding;
import 'package:flutter_riverpod/flutter_riverpod.dart' show StateNotifier;

import '../providers/general/theme_state_repository.dart';

class ThemeStateController extends StateNotifier<ThemeStateModel> {
  final BaseThemeStateRepository repo;
  ThemeStateController(this.repo) : super(defaultThemeState) {
    state = repo.load().copyWith(
      themeMode: getEffectiveThemeMode(state.themeMode, state.useSystem),
    );
  }

  ThemeMode getEffectiveThemeMode(ThemeMode themeMode, bool useSystem) {
    if (useSystem) {
      final systemBrightness =
          SchedulerBinding.instance.platformDispatcher.platformBrightness;
      return systemBrightness == Brightness.dark
          ? ThemeMode.dark
          : ThemeMode.light;
    } else {
      return themeMode;
    }
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    final useSystem = themeMode == ThemeMode.system;
    final mode = getEffectiveThemeMode(themeMode, useSystem);
    final newState = state.copyWith(themeMode: mode, useSystem: useSystem);
    state = newState;
    return repo.save(newState);
  }

  Future<void> setFontFamily(String fontFamily) {
    state = state.copyWith(fontFamily: fontFamily);
    return repo.save(state);
  }

  // void useSystemTheme() => setTheme(ThemeMode.system, useSystem: true);
}
