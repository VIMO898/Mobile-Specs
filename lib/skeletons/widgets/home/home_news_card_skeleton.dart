import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../models/shimmer_colors_model.dart';

class HomeNewsCardSkeleton extends StatelessWidget {
  const HomeNewsCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final shimmerColors = theme.extension<ShimmerColorsModel>()!;
    final baseColor = shimmerColors.baseColor;
    final highlightColor = shimmerColors.highlightColor;
    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(6),
      ),
      alignment: Alignment.topLeft,
      width: 160,
      height: double.infinity,
      margin: const EdgeInsets.only(right: 10),
      child: Column(
        children: [
          // news image/thumbnail
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(6),
              topRight: Radius.circular(6),
            ),
            child: Shimmer.fromColors(
              baseColor: baseColor,
              highlightColor: highlightColor,
              child: Container(
                height: 95,
                width: double.infinity,
                color: baseColor,
              ),
            ),
          ),
          const SizedBox(height: 5),
          // news title
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              itemCount: 3,
              itemBuilder: (context, index) => Shimmer.fromColors(
                baseColor: baseColor,
                highlightColor: highlightColor,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 4),
                  height: 12,
                  width: double.infinity,
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
    );
  }
}
