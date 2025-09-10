import 'package:app/providers/controllers/auth_controller_provider.dart';
import 'package:app/providers/general/firestore_provider.dart';
import 'package:app/repositories/reviews_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final reviewsRepositoryProvider = Provider((ref) {
  final user = ref.watch(authControllerProvider);
  final firestore = ref.watch(firestoreProvider);
  return ReviewsRepository(user: user, firestore: firestore);
});
