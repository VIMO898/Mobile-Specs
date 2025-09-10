import 'package:custom_clippers/custom_clippers.dart';
import 'package:flutter/material.dart';

import '../../../theming/app_themes.dart';
import 'rating_emoji_circle.dart';

class StackedClipPathWaves extends StatelessWidget {
  final int rating;
  const StackedClipPathWaves({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    final primaryColor = AppColors.primary;
    final height = 130.0;
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16),
      ),
      child: Container(
        width: double.infinity,
        height: height,
        margin: const EdgeInsets.only(bottom: 60),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            _buildPositionedClipPath(
              color: primaryColor,
              opacity: 0.3,
              clipper: DirectionalWaveClipper(
                horizontalPosition: HorizontalPosition.left,
              ),
            ),
            _buildPositionedClipPath(
              color: primaryColor,
              opacity: 0.6,
              bottom: 10,
              clipper: DirectionalWaveClipper(
                horizontalPosition: HorizontalPosition.right,
              ),
            ),
            _buildPositionedClipPath(
              color: primaryColor,
              opacity: 0.9,
              bottom: 20,
              clipper: SinCosineWaveClipper(
                horizontalPosition: HorizontalPosition.right,
              ),
            ),
            Positioned(top: 55, child: RatingEmojiInCircle(rating: rating)),
          ],
        ),
      ),
    );
  }

  Positioned _buildPositionedClipPath({
    double top = 0,
    double bottom = 0,
    double left = 0,
    double right = 0,
    double opacity = 1.0,
    required Color color,
    required CustomClipper<Path> clipper,
  }) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      bottom: bottom,
      child: ClipPath(
        clipper: clipper,
        child: DecoratedBox(
          decoration: BoxDecoration(color: color.withValues(alpha: opacity)),
        ),
      ),
    );
  }
}
