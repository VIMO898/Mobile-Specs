import 'package:flutter/material.dart';

class AverageRatings extends StatelessWidget {
  final int totalReviewerCount;
  final double averageRating;
  const AverageRatings({
    super.key,
    required this.textColor,
    required this.totalReviewerCount,
    required this.averageRating,
  });

  final Color textColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return SizedBox(
      height: 300,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                averageRating.toStringAsFixed(2),
                style: textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: textColor,
                ),
              ),
              const SizedBox(width: 5),
              Icon(Icons.star, size: 38),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.person),
              const SizedBox(width: 4),
              Text(
                '$totalReviewerCount',
                style: TextStyle(
                  color: textColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
