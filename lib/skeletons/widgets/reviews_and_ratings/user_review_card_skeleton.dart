import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../models/shimmer_colors_model.dart';

class UserReviewCardSkeleton extends StatelessWidget {
  const UserReviewCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final shimmerColors = theme.extension<ShimmerColorsModel>()!;
    final baseColor = shimmerColors.baseColor;
    final highlightColor = shimmerColors.highlightColor;
    return Container(
      height: 185,
      padding: const EdgeInsets.all(12),
      color: theme.cardColor,
      margin: const EdgeInsets.only(bottom: 14),
      child: Column(
        children: [
          Row(
            children: [
              // Avatar skeleton
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
              const SizedBox(width: 12),
              // Username skeleton
              Shimmer.fromColors(
                baseColor: baseColor,
                highlightColor: highlightColor,
                child: Container(width: 80, height: 16, color: baseColor),
              ),
              const Spacer(),
              // Date skeleton
              Shimmer.fromColors(
                baseColor: baseColor,
                highlightColor: highlightColor,
                child: Container(width: 60, height: 14, color: baseColor),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Stars skeleton
          Row(
            children: List.generate(
              5,
              (index) => Padding(
                padding: const EdgeInsets.only(right: 4),
                child: Shimmer.fromColors(
                  baseColor: baseColor,
                  highlightColor: highlightColor,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: baseColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Review text skeleton
          Expanded(
            child: ListView.builder(
              itemCount: 4,
              itemBuilder: (context, index) => Shimmer.fromColors(
                baseColor: baseColor,
                highlightColor: highlightColor,
                child: Container(
                  width: double.infinity,
                  height: 14,
                  color: baseColor,
                  margin: const EdgeInsets.only(bottom: 6),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
