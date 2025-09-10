import 'package:app/skeletons/widgets/general/device_feature_grid_view_skeleton.dart';
import 'package:app/skeletons/widgets/general/device_images_skeleton.dart';
import 'package:app/skeletons/widgets/general/wide_rounded_button_with_icon_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../models/shimmer_colors_model.dart';

class DeviceSpecsOverviewCardSkeleton extends StatelessWidget {
  const DeviceSpecsOverviewCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final shimmerColors = theme.extension<ShimmerColorsModel>()!;
    final baseColor = shimmerColors.baseColor;
    final highlightColor = shimmerColors.highlightColor;
    final mqs = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Device name skeleton
                  Shimmer.fromColors(
                    baseColor: baseColor,
                    highlightColor: highlightColor,
                    child: SizedBox(
                      width: mqs.width * 0.62,
                      child: Container(height: 24, color: baseColor),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Launch date skeleton
                  Shimmer.fromColors(
                    baseColor: baseColor,
                    highlightColor: highlightColor,
                    child: Container(width: 120, height: 14, color: baseColor),
                  ),
                ],
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Shimmer.fromColors(
                    baseColor: baseColor,
                    highlightColor: highlightColor,
                    child: Container(width: 60, height: 20, color: baseColor),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 170,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DeviceImagesSkeleton(width: 120, height: 180),
                const SizedBox(width: 14),
                Expanded(child: DeviceFeaturesGridViewSkeleton()),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // action buttons skeleton
          Row(
            children: [
              const WideRoundedButtonWithIconSkeleton(),
              const SizedBox(width: 12),
              const WideRoundedButtonWithIconSkeleton(),
            ],
          ),
        ],
      ),
    );
  }
}

// You may need to create WideRoundedButtonWithIconSkeleton if not already present.
