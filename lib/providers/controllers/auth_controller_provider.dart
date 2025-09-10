import 'package:app/controllers/auth_controller.dart';
import 'package:app/providers/repositories/auth_repository_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, User?>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return AuthController(repo);
});
