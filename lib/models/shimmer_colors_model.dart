import 'package:flutter/material.dart';

@immutable
class ShimmerColorsModel extends ThemeExtension<ShimmerColorsModel> {
  final Color baseColor;
  final Color highlightColor;

  const ShimmerColorsModel({
    required this.baseColor,
    required this.highlightColor,
  });

  @override
  ShimmerColorsModel copyWith({Color? baseColor, Color? highlightColor}) {
    return ShimmerColorsModel(
      baseColor: baseColor ?? this.baseColor,
      highlightColor: highlightColor ?? this.highlightColor,
    );
  }

  @override
  ShimmerColorsModel lerp(ThemeExtension<ShimmerColorsModel>? other, double t) {
    if (other is! ShimmerColorsModel) return this;
    return ShimmerColorsModel(
      baseColor: Color.lerp(baseColor, other.baseColor, t)!,
      highlightColor: Color.lerp(highlightColor, other.highlightColor, t)!,
    );
  }
}
