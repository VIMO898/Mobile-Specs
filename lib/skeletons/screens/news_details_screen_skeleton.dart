import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../models/shimmer_colors_model.dart';

class NewsDetailsScreenSkeleton extends StatelessWidget {
  const NewsDetailsScreenSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final shimmerColors = theme.extension<ShimmerColorsModel>()!;
    final baseColor = shimmerColors.baseColor;
    final highlightColor = shimmerColors.highlightColor;

    return Padding(
      padding: const EdgeInsets.all(8),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image skeleton
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Shimmer.fromColors(
                baseColor: baseColor,
                highlightColor: highlightColor,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Container(
                    width: double.infinity,
                    height: 200,
                    color: baseColor,
                  ),
                ),
              ),
            ),
            // Title skeleton
            Shimmer.fromColors(
              baseColor: baseColor,
              highlightColor: highlightColor,
              child: Container(
                width: double.infinity,
                height: 28,
                decoration: BoxDecoration(
                  color: baseColor,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
            const SizedBox(height: 4),
            // Written by skeleton
            Shimmer.fromColors(
              baseColor: baseColor,
              highlightColor: highlightColor,
              child: Container(
                width: 120,
                height: 18,
                decoration: BoxDecoration(
                  color: baseColor,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
            const SizedBox(height: 14),
            // Description skeleton (multiple lines)
            ...List.generate(
              16,
              (i) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Shimmer.fromColors(
                  baseColor: baseColor,
                  highlightColor: highlightColor,
                  child: Container(
                    width: double.infinity,
                    height: 16,
                    decoration: BoxDecoration(
                      color: baseColor,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
