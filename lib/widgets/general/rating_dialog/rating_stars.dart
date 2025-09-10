import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../theming/app_themes.dart';

class RatingStars extends StatelessWidget {
  final int stars;
  final void Function(int stars) onSelectRatings;
  const RatingStars({
    super.key,
    required this.stars,
    required this.onSelectRatings,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = AppColors.primary;

    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 36),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(5, (index) {
          final fillCurrStar = stars >= (index + 1);
          final isLastStar = index == 4;
          return GestureDetector(
            onTap: () => onSelectRatings(index + 1),
            child: Padding(
              padding: isLastStar
                  ? EdgeInsets.zero
                  : EdgeInsets.only(right: 18),
              child: Icon(
                fillCurrStar
                    ? FontAwesomeIcons.solidStar
                    : FontAwesomeIcons.star,
                size: 36,
                color: primaryColor,
              ),
            ),
          );
        }),
      ),
    );
  }
}
