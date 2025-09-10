import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../models/shimmer_colors_model.dart';

class DeviceSpecsCardSkeleton extends StatelessWidget {
  const DeviceSpecsCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final shimmerColors = theme.extension<ShimmerColorsModel>()!;
    final baseColor = shimmerColors.baseColor;
    final highlightColor = shimmerColors.highlightColor;
    return Column(
      children: [
        // Header skeleton
        Container(
          color: theme.cardColor,
          height: 90,
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Shimmer.fromColors(
                    baseColor: baseColor,
                    highlightColor: highlightColor,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.7,
                      height: 24,
                      color: baseColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Shimmer.fromColors(
                    baseColor: baseColor,
                    highlightColor: highlightColor,
                    child: Container(width: 60, height: 16, color: baseColor),
                  ),
                ],
              ),
              Shimmer.fromColors(
                baseColor: baseColor,
                highlightColor: highlightColor,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: baseColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 0),
        // Main card skeleton
        DecoratedBox(
          decoration: BoxDecoration(color: theme.cardColor),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 300,
                child: Row(
                  children: [
                    // Device image skeleton
                    Expanded(
                      child: Shimmer.fromColors(
                        baseColor: baseColor,
                        highlightColor: highlightColor,
                        child: Container(
                          height: 280,
                          margin: const EdgeInsets.symmetric(horizontal: 18),
                          decoration: BoxDecoration(
                            color: baseColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const VerticalDivider(width: 0),
                    // Vertical icon-label buttons skeleton
                    SizedBox(
                      width: 105,
                      child: Column(
                        children:
                            List.generate(3, (i) {
                                  return Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Shimmer.fromColors(
                                          baseColor: baseColor,
                                          highlightColor: highlightColor,
                                          child: Container(
                                            width: 30,
                                            height: 30,
                                            decoration: BoxDecoration(
                                              color: baseColor,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 3),
                                        Shimmer.fromColors(
                                          baseColor: baseColor,
                                          highlightColor: highlightColor,
                                          child: Container(
                                            width: 48,
                                            height: 14,
                                            color: baseColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                })
                                .expand(
                                  (w) => [
                                    w,
                                    if (w != 2) const Divider(height: 0),
                                  ],
                                )
                                .toList(),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 0),
              // Price skeleton
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 18,
                  horizontal: 10,
                ),
                child: Shimmer.fromColors(
                  baseColor: baseColor,
                  highlightColor: highlightColor,
                  child: Container(width: 100, height: 22, color: baseColor),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
