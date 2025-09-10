import 'package:app/controllers/saved_news_controller.dart';
import 'package:app/providers/repositories/saved_news_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final savedNewsControllerProvider = StateNotifierProvider((ref) {
  final repo = ref.watch(savedNewsRepositoryProvider);
  return SavedNewsController(repo);
});
