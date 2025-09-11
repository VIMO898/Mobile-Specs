import 'dart:developer';

import 'package:app/models/news_model.dart';
import 'package:app/models/user_activity_entry_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../exceptions/custom_exception.dart';

abstract class BaseSavedNewsRepository {
  Stream<List<UserActivityEntryModel>> getSavedNewsEntriesStream();
  Future<void> saveNewsArticle({
    required UserActivityEntryModel newsEntry,
    required NewsModel news,
  });
  Future<void> removeNewsArticle(UserActivityEntryModel newsEntry);
  Future<List<NewsModel>> getListOfSavedNews(List<String> newsIds);
  Stream<Future<List<NewsModel>>> getListOfSavedNewsStream();
}

class SavedNewsRepository implements BaseSavedNewsRepository {
  final FirebaseFirestore firestore;
  final User? user;
  const SavedNewsRepository({required this.firestore, required this.user});

  CollectionReference<Map<String, dynamic>> get userActivityCollection =>
      firestore.collection('userActivity');
  CollectionReference<Map<String, dynamic>> get collection =>
      firestore.collection('savedNews');

  @override
  Stream<List<UserActivityEntryModel>> getSavedNewsEntriesStream() {
    final uid = user?.uid;
    if (uid == null) return Stream.empty();

    final docSnapshotStream = userActivityCollection.doc(uid).snapshots();
    return docSnapshotStream.map((docSnapshot) {
      final userActivityExists = docSnapshot.exists;
      if (!userActivityExists) return [];
      final userNewsActivityMap = List.from(
        docSnapshot.data()?['savedNews'] ?? [],
      );
      final userNewsActivity = userNewsActivityMap
          .map((n) => UserActivityEntryModel.fromMap(n))
          .toList();
      return userNewsActivity;
    });
  }

  Future<NewsModel?> _getSavedNews(String newsId) async {
    try {
      final uid = user?.uid;
      if (uid == null) return null;
      final docSnapshot = await collection.doc(newsId).get();
      final data = docSnapshot.data();
      return data != null ? NewsModel.fromMap(data) : null;
    } on FirebaseException catch (e) {
      log(e.toString());
      throw CustomException(
        code: e.code,
        message: e.message ?? 'Oops! Something went wrong. Please try again.',
      );
    } catch (e) {
      log(e.toString());
      throw CustomException(
        code: '500',
        message:
            'An unknown error has occurred. Please check your internet connection.',
      );
    }
  }

  @override
  Future<List<NewsModel>> getListOfSavedNews(List<String> newsIds) async {
    final newsFutures = newsIds.map((id) => _getSavedNews(id)).toList();
    final news = await Future.wait<NewsModel?>(newsFutures);
    return news.whereType<NewsModel>().toList();
  }

  @override
  Stream<Future<List<NewsModel>>> getListOfSavedNewsStream() {
    return getSavedNewsEntriesStream().map((newsEntries) {
      final newsEntriesIds = newsEntries.map((e) => e.id).toList();
      return getListOfSavedNews(newsEntriesIds);
    });
  }

  @override
  Future<void> saveNewsArticle({
    required UserActivityEntryModel newsEntry,
    required NewsModel news,
  }) async {
    try {
      final uid = user?.uid;
      if (uid == null) return;
      final newsId = news.overview.id;
      await userActivityCollection.doc(uid).set({
        'savedNews': FieldValue.arrayUnion([newsEntry.toMap()]),
      }, SetOptions(merge: true));
      final docSnapshot = await collection.doc(newsId).get();
      final newsExists = docSnapshot.exists;
      final collectionDoc = collection.doc(newsId);
      if (!newsExists) {
        final newsMap = news.toMap();
        newsMap.addAll({
          'usedBy': [uid],
        });
        await collectionDoc.set(newsMap);
      } else {
        await collectionDoc.update({
          'usedBy': FieldValue.arrayUnion([uid]),
        });
      }
    } on FirebaseException catch (e) {
      throw CustomException(
        code: e.code,
        message: e.message ?? 'Unable to save the news',
      );
    } catch (e) {
      log(e.toString());
      throw CustomException(
        code: '500',
        message:
            'An unknown error has occurred. Please check your internet connection.',
      );
    }
  }

  @override
  Future<void> removeNewsArticle(UserActivityEntryModel entry) async {
    try {
      final uid = user?.uid;
      if (uid == null) return;
      await userActivityCollection.doc(uid).set({
        'savedNews': FieldValue.arrayRemove([entry.toMap()]),
      }, SetOptions(merge: true));
      final collectionDoc = collection.doc(entry.id);
      final docSnapshot = await collectionDoc.get();

      if (docSnapshot.exists) {
        final dataMap = docSnapshot.data()!;
        final List<dynamic> usersUsingThisData = dataMap['usedBy'] ?? [];
        final containsThisUser = usersUsingThisData.contains(uid);

        if (containsThisUser) {
          await collectionDoc.update({
            'usedBy': FieldValue.arrayRemove([uid]),
          });
        }

        final updatedSnapshot = await collectionDoc.get();
        final updatedData = updatedSnapshot.data();
        final List<dynamic> updatedUsers = updatedData?['usedBy'] ?? [];
        if (updatedUsers.isEmpty) {
          await collectionDoc.delete();
        }
      }
    } on FirebaseException catch (e) {
      log(e.toString());
      throw CustomException(
        code: e.code,
        message: e.message ?? 'Unable to remove the news',
      );
    } catch (e) {
      log(e.toString());
      throw CustomException(
        code: '500',
        message:
            'An unknown error has occurred. Please check your internet connection.',
      );
    }
  }
}
