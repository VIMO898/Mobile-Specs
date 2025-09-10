import 'package:app/models/device_overview_model.dart';
import 'package:app/models/review_model.dart';
import 'package:app/models/review_with_user_info_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../exceptions/custom_exception.dart';
import '../models/user_model.dart';

abstract class BaseReviewsRepository {
  Future<List<ReviewWithUserInfoModel>> getReviews(String deviceId);
  Future<void> submitReview(DeviceOverviewModel device, ReviewModel review);
  // Future<void> editReview(
  //   DeviceOverviewModel device,
  //   ReviewModel updatedReview,
  // );
  Future<void> deleteReview(String uid, String deviceId);
}

class ReviewsRepository implements BaseReviewsRepository {
  final User? user;
  final FirebaseFirestore firestore;
  const ReviewsRepository({required this.user, required this.firestore});

  CollectionReference<Map<String, dynamic>> get collection =>
      firestore.collection('reviews');
  CollectionReference<Map<String, dynamic>> get usersCollection =>
      firestore.collection('users');

  @override
  Future<List<ReviewWithUserInfoModel>> getReviews(String deviceId) async {
    try {
      final uid = user?.uid;
      if (uid == null) return [];

      final docSnapshot = await collection.doc(deviceId).get();
      final docExists = docSnapshot.exists;
      if (!docExists) return [];
      final data = docSnapshot.data()!;
      final List<ReviewWithUserInfoModel> reviews = [];
      for (final entry in data.entries) {
        final uid = entry.key;
        final r = entry.value;
        final userDoc = await usersCollection.doc(uid).get();
        final userInfo = UserModel.fromMap(userDoc.data()!).copyWith(id: uid);
        final review = ReviewModel.fromMap(r);
        reviews.add(
          ReviewWithUserInfoModel(userInfo: userInfo, review: review),
        );
      }
      return reviews;
    } on FirebaseException catch (e) {
      throw CustomException(
        code: e.code,
        message: e.message ?? 'Oops! Something went wrong. Please try again.',
      );
    } catch (e) {
      throw CustomException(
        code: '500',
        message:
            'An unknown error has occurred. Please check your internet connection.',
      );
    }
  }

  @override
  Future<void> submitReview(
    DeviceOverviewModel device,
    ReviewModel review,
  ) async {
    final uid = user?.uid;
    if (uid == null) return;
    try {
      return collection.doc(device.id).set({
        uid: review.toMap(),
      }, SetOptions(merge: true));
    } on FirebaseException catch (e) {
      throw CustomException(
        code: e.code,
        message: e.message ?? 'Oops! Something went wrong. Please try again.',
      );
    } catch (e) {
      throw CustomException(
        code: '500',
        message:
            'An unknown error has occurred. Please check your internet connection.',
      );
    }
  }

  // @override
  // Future<void> editReview(
  //   DeviceOverviewModel device,
  //   ReviewModel updatedReview,
  // ) {
  //   try {} on FirebaseException catch (e) {
  //     throw CustomException(
  //       code: e.code,
  //       message: e.message ?? 'Oops! Something went wrong. Please try again.',
  //     );
  //   } catch (e) {
  //     throw CustomException(
  //       code: '500',
  //       message:
  //           'An unknown error has occurred. Please check your internet connection.',
  //     );
  //   }
  // }

  @override
  Future<void> deleteReview(String uid, String deviceId) async {
    try {
      final docSnapshot = await collection.doc(deviceId).get();
      final docExists = docSnapshot.exists;
      if (!docExists) return;
      final deviceReviews = docSnapshot.data();
      await deviceReviews!.remove(uid);
    } on FirebaseException catch (e) {
      throw CustomException(
        code: e.code,
        message: e.message ?? 'Oops! Something went wrong. Please try again.',
      );
    } catch (e) {
      throw CustomException(
        code: '500',
        message:
            'An unknown error has occurred. Please check your internet connection.',
      );
    }
  }
}
