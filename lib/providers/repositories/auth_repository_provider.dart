import 'package:app/providers/general/firebase_auth_provider.dart';
import 'package:app/providers/general/firestore_provider.dart';
import 'package:app/repositories/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRepositoryProvider = Provider((ref) {
  final auth = ref.watch(firebaseAuthProvider);
  final firestore = ref.watch(firestoreProvider);
  return AuthRepository(auth: auth, firestore: firestore);
});
