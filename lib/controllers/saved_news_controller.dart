import 'dart:async';

import 'package:app/models/news_model.dart';
import 'package:app/models/user_activity_entry_model.dart';
import 'package:app/repositories/saved_news_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SavedNewsController extends StateNotifier<List<UserActivityEntryModel>> {
  final BaseSavedNewsRepository repo;
  StreamSubscription<List<UserActivityEntryModel>>? _subscription;

  SavedNewsController(this.repo) : super([]) {
    _initializeState();
  }

  void _initializeState() {
    _subscription = repo.getSavedNewsEntriesStream().listen((newsEntries) {
      state = newsEntries;
    });
  }

  Future<List<NewsModel>> getSavedNewsArticles() async {
    final savedNewsIds = state.map((n) => n.id).toList();
    return repo.getListOfSavedNews(savedNewsIds);
  }

  Stream<Future<List<NewsModel>>> getSavedNewsArticleStream() {
    return repo.getListOfSavedNewsStream();
  }

  Future<void> saveNewsArticle(NewsModel news) async {
    final newsExists = state.any((entry) {
      final newsId = news.overview.id;
      return entry.id == newsId;
    });
    if (newsExists) return;
    final newsId = news.overview.id;
    final currTimestamp = DateTime.now().millisecondsSinceEpoch;

    final newsEntry = UserActivityEntryModel(
      id: newsId,
      timestamp: currTimestamp,
    );
    return repo.saveNewsArticle(newsEntry: newsEntry, news: news);
  }

  Future<void> removeNewsArticle(String newsId) async {
    final newsToBeRemovedIndex = state.indexWhere(
      (entry) => entry.id == newsId,
    );
    if (newsToBeRemovedIndex == -1) return;
    return repo.removeNewsArticle(state[newsToBeRemovedIndex]);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
