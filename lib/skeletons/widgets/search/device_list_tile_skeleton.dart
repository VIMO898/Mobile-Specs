import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../models/shimmer_colors_model.dart';

class DeviceListTileSkeleton extends StatelessWidget {
  const DeviceListTileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final shimmerColors = theme.extension<ShimmerColorsModel>()!;
    final baseColor = shimmerColors.baseColor;
    final highlightColor = shimmerColors.highlightColor;
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 16, 8),
      decoration: BoxDecoration(
        color: theme.cardColor,
        border: Border(
          bottom: BorderSide(
            width: theme.dividerTheme.thickness ?? 1,
            color: theme.dividerColor,
          ),
        ),
      ),
      child: Row(
        children: [
          // Image skeleton
          Shimmer.fromColors(
            baseColor: baseColor,
            highlightColor: highlightColor,
            child: Container(
              height: 55,
              width: 45,
              decoration: BoxDecoration(
                color: baseColor,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Text skeletons
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Shimmer.fromColors(
                baseColor: baseColor,
                highlightColor: highlightColor,
                child: Container(width: 110, height: 16, color: baseColor),
              ),
              const SizedBox(height: 3),
              Shimmer.fromColors(
                baseColor: baseColor,
                highlightColor: highlightColor,
                child: Container(width: 70, height: 12, color: baseColor),
              ),
            ],
          ),
          const Spacer(),
          // Chevron icon skeleton
          Shimmer.fromColors(
            baseColor: baseColor,
            highlightColor: highlightColor,
            child: Container(
              width: 15,
              height: 15,
              decoration: BoxDecoration(
                color: baseColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
