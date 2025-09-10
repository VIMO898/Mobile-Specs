import 'package:app/skeletons/widgets/reviews_and_ratings/user_review_card_skeleton.dart';
import 'package:flutter/material.dart';

class UserReviewListViewSkeleton extends StatelessWidget {
  const UserReviewListViewSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 10,
        itemBuilder: (context, index) {
          return UserReviewCardSkeleton();
        },
      ),
    );
  }
}
