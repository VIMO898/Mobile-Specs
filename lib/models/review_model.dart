// // ignore_for_file: public_member_api_docs, sort_constructors_first
// class ReviewModel {
//   final String? reviewerName;
//   final String? reviewerImg;
//   final String reviewPublicationDate;
//   final String reviewLocationIdentifier;
//   final String reviewText;
//   final String? replyAuthorUsername;
//   final String? replyText;
//   final String? replyPublicationDate;

//   const ReviewModel({
//     this.reviewerName,
//     this.reviewerImg,
//     required this.reviewPublicationDate,
//     required this.reviewLocationIdentifier,
//     required this.reviewText,
//     this.replyAuthorUsername,
//     this.replyText,
//     this.replyPublicationDate,
//   });

//   @override
//   String toString() {
//     return 'ReviewModel(reviewerName: $reviewerName, reviewerImg: $reviewerImg, reviewPublicationDate: $reviewPublicationDate, reviewLocationIdentifier: $reviewLocationIdentifier, reviewText: $reviewText, replyAuthorUsername: $replyAuthorUsername, replyText: $replyText, replyPublicationDate: $replyPublicationDate)';
//   }
// }

import 'dart:convert';

class ReviewModel {
  final String review;
  final int ratings;
  final int reviewedAt;

  const ReviewModel({
    required this.review,
    required this.ratings,
    required this.reviewedAt,
  });

  @override
  String toString() {
    return 'ReviewModel(review: $review, ratings: $ratings, reviewedAt: $reviewedAt)';
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'review': review,
      'ratings': ratings,
      'reviewedAt': reviewedAt,
    };
  }

  factory ReviewModel.fromMap(Map<String, dynamic> map) {
    return ReviewModel(
      review: map['review'],
      ratings: map['ratings'],
      reviewedAt: map['reviewedAt'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ReviewModel.fromJson(String source) =>
      ReviewModel.fromMap(json.decode(source));

  ReviewModel copyWith({String? review, int? ratings, int? reviewedAt}) {
    return ReviewModel(
      review: review ?? this.review,
      ratings: ratings ?? this.ratings,
      reviewedAt: reviewedAt ?? this.reviewedAt,
    );
  }
}
