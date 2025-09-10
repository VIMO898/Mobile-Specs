import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../models/shimmer_colors_model.dart';

class DeviceHighlightFeatureSkeleton extends StatelessWidget {
  const DeviceHighlightFeatureSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final shimmerColors = theme.extension<ShimmerColorsModel>()!;
    final baseColor = shimmerColors.baseColor;
    final highlightColor = shimmerColors.highlightColor;
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Icon skeleton
        Shimmer.fromColors(
          baseColor: baseColor,
          highlightColor: highlightColor,
          child: Container(
            width: 21,
            height: 21,
            decoration: BoxDecoration(
              color: baseColor,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ),
        const SizedBox(width: 6),
        // Text skeleton
        Flexible(
          child: Shimmer.fromColors(
            baseColor: baseColor,
            highlightColor: highlightColor,
            child: Container(
              height: 16,
              width: 80,
              decoration: BoxDecoration(
                color: baseColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
