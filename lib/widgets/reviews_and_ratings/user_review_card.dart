import 'package:app/models/review_with_user_info_model.dart';
import 'package:app/theming/app_themes.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

class UserReviewCard extends StatelessWidget {
  final ReviewWithUserInfoModel reviewWithUserInfo;
  const UserReviewCard(this.reviewWithUserInfo, {super.key});

  @override
  Widget build(BuildContext context) {
    final reviewer = reviewWithUserInfo.userInfo;
    final review = reviewWithUserInfo.review;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final textColor = textTheme.bodyLarge?.color ?? AppColors.primary;
    final createdAtDateTime = DateTime.fromMillisecondsSinceEpoch(
      review.reviewedAt,
    );
    final dateTimeFormatter = intl.DateFormat.yMd();
    final formattedDateTime = dateTimeFormatter.format(createdAtDateTime);
    return Container(
      padding: const EdgeInsets.all(12),
      color: theme.cardColor,
      margin: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.secondary,
                radius: 16,
                // image
                // backgroundImage: NetworkImage(
                //   'https://upload.wikimedia.org/wikipedia/commons/thumb/f/fe/Andrew_Garfield_in_2023_%28cropped%29.jpg/640px-Andrew_Garfield_in_2023_%28cropped%29.jpg',
                // ),
                child: Text(
                  reviewer.username[0],
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                reviewer.username,
                style: textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Text(formattedDateTime, style: textTheme.bodySmall),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 8),
            child: Row(
              children: List.generate(5, (index) {
                return Icon(
                  Icons.star,
                  color: index < review.ratings
                      ? textColor
                      : textColor.withValues(alpha: 0.3),
                  size: 20,
                );
              }),
            ),
          ),
          Text(review.review, textAlign: TextAlign.start),
        ],
      ),
    );
  }
}
