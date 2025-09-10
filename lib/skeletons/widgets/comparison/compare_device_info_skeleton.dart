import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../models/shimmer_colors_model.dart';

class CompareDeviceSpecsSkeleton extends StatelessWidget {
  final int featureCount;
  final int specsPerFeature;
  final int deviceCount;
  const CompareDeviceSpecsSkeleton({
    super.key,
    this.featureCount = 3,
    this.specsPerFeature = 2,
    required this.deviceCount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final shimmerColors = theme.extension<ShimmerColorsModel>()!;
    final baseColor = shimmerColors.baseColor;
    final highlightColor = shimmerColors.highlightColor;

    return SliverList.builder(
      itemCount: featureCount,
      itemBuilder: (context, featureIdx) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Feature name skeleton
            Padding(
              padding: const EdgeInsets.all(14),
              child: Shimmer.fromColors(
                baseColor: baseColor,
                highlightColor: highlightColor,
                child: Container(width: 120, height: 22, color: baseColor),
              ),
            ),
            ...List.generate(specsPerFeature, (specIdx) {
              return Container(
                color: theme.cardColor,
                margin: const EdgeInsets.only(bottom: 8),
                child: Column(
                  children: [
                    // Spec name skeleton
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Shimmer.fromColors(
                        baseColor: baseColor,
                        highlightColor: highlightColor,
                        child: Container(
                          width: 90,
                          height: 18,
                          color: baseColor,
                        ),
                      ),
                    ),
                    // Table skeleton
                    Table(
                      border: TableBorder(
                        top: BorderSide(color: theme.dividerColor),
                        bottom: BorderSide(color: theme.dividerColor),
                        verticalInside: BorderSide(color: theme.dividerColor),
                      ),
                      children: [
                        TableRow(
                          children: List.generate(deviceCount, (devIdx) {
                            return Padding(
                              padding: const EdgeInsets.all(7.0),
                              child: Shimmer.fromColors(
                                baseColor: baseColor,
                                highlightColor: highlightColor,
                                child: Container(
                                  width: double.infinity,
                                  height: 16,
                                  color: baseColor,
                                ),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
          ],
        );
      },
    );
  }
}
