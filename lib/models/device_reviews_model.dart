// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:app/models/review_model.dart';

class DeviceReviewsModel {
  final List<ReviewModel> reviews;
  final int totalReviewPages;
  DeviceReviewsModel({
    required this.reviews,
    required this.totalReviewPages,
  });

  @override
  String toString() =>
      'DeviceReviewsModel(reviews: $reviews, totalReviewPages: $totalReviewPages)';
}
