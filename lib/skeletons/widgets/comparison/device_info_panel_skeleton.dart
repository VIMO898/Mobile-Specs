import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../models/shimmer_colors_model.dart';

class DeviceInfoPanelSkeleton extends StatelessWidget {
  final int deviceCount;
  const DeviceInfoPanelSkeleton({super.key, required this.deviceCount});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final shimmerColors = theme.extension<ShimmerColorsModel>()!;
    final baseColor = shimmerColors.baseColor;
    final highlightColor = shimmerColors.highlightColor;

    return SliverToBoxAdapter(
      child: Row(
        children: List.generate(deviceCount, (index) {
          return Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: theme.cardColor,
                border: Border(right: BorderSide(color: theme.dividerColor)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 12),
                    child: Column(
                      children: [
                        // Image skeleton
                        Shimmer.fromColors(
                          baseColor: baseColor,
                          highlightColor: highlightColor,
                          child: Container(
                            width: 100,
                            height: 150,
                            decoration: BoxDecoration(
                              color: baseColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Name skeleton
                        Shimmer.fromColors(
                          baseColor: baseColor,
                          highlightColor: highlightColor,
                          child: Container(
                            width: 80,
                            height: 18,
                            color: baseColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Subtitle skeleton
                        Shimmer.fromColors(
                          baseColor: baseColor,
                          highlightColor: highlightColor,
                          child: Container(
                            width: 60,
                            height: 14,
                            color: baseColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
