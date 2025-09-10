import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../models/shimmer_colors_model.dart';

class PopularComparisonTileSkeleton extends StatelessWidget {
  const PopularComparisonTileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final shimmerColors = theme.extension<ShimmerColorsModel>()!;
    final baseColor = shimmerColors.baseColor;
    final highlightColor = shimmerColors.highlightColor;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      decoration: BoxDecoration(
        color: theme.cardColor,
        border: Border(
          bottom: BorderSide(color: theme.dividerColor, width: 0.35),
        ),
      ),
      child: Row(
        children: [
          _buildDeviceSkeleton(baseColor, highlightColor),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Shimmer.fromColors(
              baseColor: baseColor,
              highlightColor: highlightColor,
              child: CircleAvatar(
                radius: 22,
                backgroundColor: baseColor,
                child: Container(width: 24, height: 14, color: highlightColor),
              ),
            ),
          ),
          _buildDeviceSkeleton(baseColor, highlightColor, reversed: true),
        ],
      ),
    );
  }

  Flexible _buildDeviceSkeleton(
    Color baseColor,
    Color highlightColor, {
    bool reversed = false,
  }) {
    final children = [
      Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        child: Container(
          width: 40,
          height: 60,
          decoration: BoxDecoration(
            color: baseColor,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Align(
          alignment: !reversed ? Alignment.centerLeft : Alignment.centerRight,
          child: Shimmer.fromColors(
            baseColor: baseColor,
            highlightColor: highlightColor,
            child: Container(width: 60, height: 18, color: baseColor),
          ),
        ),
      ),
    ];
    return Flexible(
      flex: 2,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: reversed ? children.reversed.toList() : children,
      ),
    );
  }
}
