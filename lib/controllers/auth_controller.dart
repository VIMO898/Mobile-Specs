import 'dart:async';

import 'package:app/models/user_model.dart';
import 'package:app/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthController extends StateNotifier<User?> {
  final BaseAuthRepository repo;
  StreamSubscription<User?>? _authStreamSubscription;
  AuthController(this.repo) : super(null) {
    _initializeState();
  }
  void _initializeState() {
    _authStreamSubscription = repo.authStateChanges().listen((user) {
      state = user;
    });
  }

  Future<void> login(String email, String password) {
    return repo.login(email: email, password: password);
  }

  Future<void> signup(String email, String username, String password) {
    return repo.signup(email: email, username: username, password: password);
  }

  Future<void> changeUsername(String updatedUsername) async {
    final uid = state?.uid;
    if (uid == null) return;
    return repo.changeUsername(uid: uid, username: updatedUsername);
  }

  Future<UserModel?> getUserInfo() async {
    final uid = state?.uid;
    if (uid == null) return null;
    return repo.getUserInfo(uid: uid);
  }

  Future<void> logout() {
    return repo.logout();
  }

  @override
  void dispose() {
    super.dispose();
    _authStreamSubscription?.cancel();
  }
}
