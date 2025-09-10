import 'dart:convert';

import 'package:flutter/material.dart';

class ThemeStateModel {
  final String fontFamily;
  final ThemeMode themeMode;
  final bool useSystem;
  const ThemeStateModel({
    required this.themeMode,
    required this.useSystem,
    required this.fontFamily,
  });

  ThemeStateModel copyWith({
    ThemeMode? themeMode,
    bool? useSystem,
    String? fontFamily,
  }) {
    return ThemeStateModel(
      themeMode: themeMode ?? this.themeMode,
      useSystem: useSystem ?? this.useSystem,
      fontFamily: fontFamily ?? this.fontFamily,
    );
  }

  @override
  String toString() =>
      'ThemeStateModel(fontFamily: $fontFamily, themeMode: $themeMode, useSystem: $useSystem)';

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'fontFamily': fontFamily,
      'themeMode': themeMode.index,
      'useSystem': useSystem,
    };
  }

  factory ThemeStateModel.fromMap(Map<String, dynamic> map) {
    return ThemeStateModel(
      fontFamily: map['fontFamily'] ?? 'LexendDeca',
      themeMode: ThemeMode.values[map['themeMode'] ?? ThemeMode.system.index],
      useSystem: map['useSystem'] ?? true,
    );
  }

  String toJson() => json.encode(toMap());

  factory ThemeStateModel.fromJson(String source) =>
      ThemeStateModel.fromMap(json.decode(source));
}
