import 'package:app/providers/controllers/auth_controller_provider.dart';
import 'package:app/providers/general/firestore_provider.dart';
import 'package:app/repositories/saved_news_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final savedNewsRepositoryProvider = Provider((ref) {
  final firestore = ref.watch(firestoreProvider);
  final user = ref.watch(authControllerProvider);
  return SavedNewsRepository(firestore: firestore, user: user);
});
