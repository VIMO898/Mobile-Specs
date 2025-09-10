import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../models/shimmer_colors_model.dart';

class WideRoundedButtonWithIconSkeleton extends StatelessWidget {
  const WideRoundedButtonWithIconSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final shimmerColors = theme.extension<ShimmerColorsModel>()!;
    final baseColor = shimmerColors.baseColor;
    final highlightColor = shimmerColors.highlightColor;
    return Expanded(
      child: Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: theme.dividerColor,
          ),
        ),
      ),
    );
  }
}
