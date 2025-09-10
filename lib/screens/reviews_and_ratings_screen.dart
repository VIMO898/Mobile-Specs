import 'dart:developer';

import 'package:app/exceptions/custom_exception.dart';
import 'package:app/models/device_overview_model.dart';
import 'package:app/models/review_with_user_info_model.dart';
import 'package:app/providers/controllers/auth_controller_provider.dart';
import 'package:app/providers/controllers/theme_state_controller.dart';
import 'package:app/providers/repositories/reviews_repository_provider.dart';
import 'package:app/skeletons/widgets/reviews_and_ratings/user_review_list_view_skeleton.dart';
import 'package:app/widgets/reviews_and_ratings/rating_progress_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/general/no_data_message.dart';
import '../widgets/reviews_and_ratings/average_ratings.dart';
import '../widgets/reviews_and_ratings/user_review_card.dart';
import '../widgets/reviews_and_ratings/write_review.dart';

class ReviewsAndRatingsScreen extends ConsumerStatefulWidget {
  final DeviceOverviewModel device;
  const ReviewsAndRatingsScreen({super.key, required this.device});

  @override
  ConsumerState<ReviewsAndRatingsScreen> createState() =>
      _ReviewsAndRatingsScreenState();
}

class _ReviewsAndRatingsScreenState
    extends ConsumerState<ReviewsAndRatingsScreen> {
  bool _isLoading = false;
  CustomException? _exception;
  List<ReviewWithUserInfoModel>? _reviews;
  ReviewWithUserInfoModel? _myReview;
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      setState(() => _isLoading = true);
      final user = ref.read(authControllerProvider);
      final reviewsRepo = ref.read(reviewsRepositoryProvider);
      _reviews = await reviewsRepo.getReviews(widget.device.id);
      final myReviewIndex = _reviews!.indexWhere(
        (r) => r.userInfo.id == user!.uid,
      );
      log(myReviewIndex.toString());
      _myReview = myReviewIndex != -1 ? _reviews![myReviewIndex] : null;
      log(_reviews.toString());
      setState(() => _isLoading = false);
    } on CustomException catch (e) {
      _exception = e;
      setState(() => _isLoading = false);
    } catch (_) {
      _exception = CustomException(
        message: 'Something went wrong. Please try again.',
      );
      setState(() => _isLoading = false);
    }
  }

  void _handleMyReviewChanged(ReviewWithUserInfoModel updatedReview) {
    setState(() => _myReview = updatedReview);
  }

  @override
  Widget build(BuildContext context) {
    // final theme = Theme.of(context);
    // final textColor = theme.dividerColor;
    final user = ref.watch(authControllerProvider);
    final isDarkMode =
        ref.watch(themeStateControllerProvider).themeMode == ThemeMode.dark;
    final textColor = isDarkMode ? Colors.grey.shade300 : Colors.grey.shade900;

    final reviews = _reviews ?? [];
    final otherReviews = reviews.where((r) => r.userInfo.id != user!.uid);
    final totalReviews = _myReview != null
        ? [_myReview, ...otherReviews]
        : [...otherReviews];
    final totalReviewsCount = totalReviews.length;
    final mappedReviewsByRatings = mapReviewsByRatings(allReviews: reviews);
    return Scaffold(
      appBar: AppBar(title: const Text('Reviews & Ratings')),

      body: _isLoading
          ? UserReviewListViewSkeleton()
          : _exception != null
          ? NoDataMessage(
              icon: Icons.priority_high_outlined,
              title: 'Error',
              subtitle: _exception!.message,
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Container(
                      padding: const EdgeInsets.only(top: 14),
                      height: 156,
                      child: Row(
                        children: [
                          Expanded(
                            child: AverageRatings(
                              textColor: textColor,
                              totalReviewerCount: totalReviewsCount,
                              averageRating: findReviewsAverage(reviews),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(12),
                            child: VerticalDivider(indent: 12, endIndent: 12),
                          ),
                          RatingProgressListView(
                            color: textColor,
                            reviewsWithRatings: mappedReviewsByRatings.map(
                              (key, value) => MapEntry(key, value.length),
                            ),
                            totalReviewCount: totalReviewsCount,
                          ),
                        ],
                      ),
                    ),
                  ),
                  WriteReview(
                    deviceOverview: widget.device,
                    submittedReview: _myReview?.review,
                    onSuccessfulReviewSubmission: _handleMyReviewChanged,
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.only(bottom: 14),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        childCount: totalReviewsCount,
                        (context, index) {
                          final review = totalReviews[index]!;
                          return UserReviewCard(review);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

Map<int, List<ReviewWithUserInfoModel>> mapReviewsByRatings({
  required List<ReviewWithUserInfoModel> allReviews,
}) {
  Map<int, List<ReviewWithUserInfoModel>> mappedReviews = {};
  for (int i = 1; i <= 5; i++) {
    mappedReviews[i] = allReviews.where((r) => r.review.ratings == i).toList();
  }
  return mappedReviews;
}

double findReviewsAverage(List<ReviewWithUserInfoModel> reviews) {
  if (reviews.isEmpty) return 0.00;
  final sum = reviews.fold(0, (value, r) => r.review.ratings + value);
  final totalReviewCount = reviews.length;
  return sum / totalReviewCount;
}
