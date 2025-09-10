// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:app/models/review_model.dart';
import 'package:app/models/user_model.dart';

class ReviewWithUserInfoModel {
  final UserModel userInfo;
  final ReviewModel review;
  const ReviewWithUserInfoModel({required this.userInfo, required this.review});

  @override
  String toString() =>
      'ReviewWithUserInfoModel(userInfo: $userInfo, review: $review)';
}
