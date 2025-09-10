import 'package:flutter/material.dart';

import 'star_progress_bar.dart';

class RatingProgressListView extends StatelessWidget {
  final Color color;
  final Map<int, int> reviewsWithRatings;
  final int totalReviewCount;
  const RatingProgressListView({
    super.key,
    required this.color,
    required this.reviewsWithRatings,
    required this.totalReviewCount,
  });

  @override
  Widget build(BuildContext context) {
    final mqs = MediaQuery.of(context).size;
    final screenWidth = mqs.width;
    final fullProgressWidth = screenWidth * 0.38;
    return SizedBox(
      width: fullProgressWidth,
      child: Column(
        children: List.generate(5, (index) {
          final star = index + 1;
          final totalReviewsInThisRating = reviewsWithRatings[star] ?? 0;
          final progressWidth = totalReviewCount == 0
              ? 0
              : fullProgressWidth *
                    (totalReviewsInThisRating / totalReviewCount);
          return StarProgressBar(
            star: star,
            color: color,
            fullWidth: fullProgressWidth,
            progressWidth: progressWidth.toDouble(),
          );
        }),
      ),
    );
  }
}
