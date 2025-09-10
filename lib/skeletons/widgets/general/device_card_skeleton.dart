import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../models/shimmer_colors_model.dart';

class DeviceCardSkeleton extends StatelessWidget {
  final double? width;
  final double? height;
  final EdgeInsets? margin;
  final bool isStaggeredHeight;

  const DeviceCardSkeleton({
    super.key,
    this.width,
    this.height,
    this.margin,
    this.isStaggeredHeight = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final shimmerColors = theme.extension<ShimmerColorsModel>()!;
    final baseColor = shimmerColors.baseColor;
    final highlightColor = shimmerColors.highlightColor;

    return Container(
      margin: margin,
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: theme.cardColor,
        border: Border.all(color: theme.dividerColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // Image placeholder
          Shimmer.fromColors(
            baseColor: baseColor,
            highlightColor: highlightColor,
            child: Container(
              margin: const EdgeInsets.fromLTRB(2, 2, 2, 12),
              width: double.infinity,
              height: isStaggeredHeight ? 120 : 105,
              decoration: BoxDecoration(
                color: baseColor,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          // Title placeholder
          Shimmer.fromColors(
            baseColor: baseColor,
            highlightColor: highlightColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SizedBox(
                height: 60,
                child: ListView.builder(
                  itemCount: 2,
                  itemBuilder: (context, index) => Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    height: 18,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: baseColor,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const Spacer(),
          // Bottom buttons row
          Shimmer.fromColors(
            baseColor: baseColor,
            highlightColor: highlightColor,
            child: SizedBox(
              height: 38,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
                child: Row(
                  children: [
                    // Compare button skeleton
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        color: theme.cardColor,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Icon placeholder
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: baseColor,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            const SizedBox(width: 4),
                            // Text placeholder
                            Container(
                              width: 48,
                              height: 14,
                              decoration: BoxDecoration(
                                color: baseColor,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Fav button skeleton
                    Shimmer.fromColors(
                      baseColor: baseColor,
                      highlightColor: highlightColor,
                      child: Container(
                        width: 40,
                        height: double.infinity,
                        alignment: Alignment.center,
                        child: Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            color: baseColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
