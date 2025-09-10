import 'package:app/models/theme_state_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract class BaseThemeStateRepository {
  ThemeStateModel load();
  Future<void> save(ThemeStateModel state);
}

class ThemeStateRepository implements BaseThemeStateRepository {
  static const _boxKey = 'state';
  final Box box;
  ThemeStateRepository(this.box);

  @override
  ThemeStateModel load() {
    final raw = box.get(_boxKey);
    if (raw == null) return defaultThemeState;
    return ThemeStateModel.fromJson(raw);
  }

  @override
  Future<void> save(ThemeStateModel state) async {
    return box.put(_boxKey, state.toJson());
  }
}

final defaultThemeState = ThemeStateModel(
  themeMode: ThemeMode.system,
  useSystem: true,
  fontFamily: 'LexendDeca',
);
