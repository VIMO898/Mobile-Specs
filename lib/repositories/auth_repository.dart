import 'dart:developer';

import 'package:app/exceptions/custom_exception.dart';
import 'package:app/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseAuthRepository {
  Stream<User?> authStateChanges();
  Future<User?> login({required String email, required String password});
  Future<User?> signup({
    required String email,
    required String username,
    required String password,
  });
  // Future<UserModel> getUserFromFirestore(String uid);
  Future<void> changeUsername({required String uid, required String username});
  Future<UserModel?> getUserInfo({required String uid});
  Future<void> logout();
  // Future<void> resetPassword(
  //     {required String email, required String newPassword});
}

class AuthRepository implements BaseAuthRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  const AuthRepository({required this.auth, required this.firestore});

  CollectionReference<Map<String, dynamic>> get collection =>
      firestore.collection('users');

  @override
  Stream<User?> authStateChanges() {
    return auth.authStateChanges();
  }

  @override
  Future<User?> login({required String email, required String password}) async {
    try {
      final userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw CustomException(
        code: e.code,
        message:
            e.message ??
            'Unable to log in. Please check your internet connection & try again',
      );
    }
  }

  @override
  Future<User?> signup({
    required String email,
    required String username,
    required String password,
  }) async {
    try {
      final userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;
      await userCredential.user?.updateDisplayName(username);
      if (user != null) {
        await collection.doc(userCredential.user!.uid).set({
          'username': username,
          'email': email,
        });
      }
      return user;
    } on FirebaseAuthException catch (e) {
      throw CustomException(
        code: e.code,
        message:
            e.message ??
            'Trouble signing up. Please check your connection & try again.',
      );
    }
  }

  // @override
  // Stream<UserModel?> getUserFromFirestore(String uid) async {
  //   final userCollection = firebstore.collection('users');

  //   final user = userCollection.doc(uid).snapshots().map(
  //     (rawData) {
  //       final userMap = rawData.data();
  //       final user = UserModel.fromMap(userMap!).copyWith(id: rawData.id);
  //       return user;
  //     },
  //   ).toList();
  //   user;
  // }

  @override
  Future<void> changeUsername({
    required String uid,
    required String username,
  }) async {
    try {
      await collection.doc(uid).update({'username': username});
      await auth.currentUser?.updateDisplayName(username);
    } on FirebaseAuthException catch (e) {
      throw CustomException(
        code: e.code,
        message:
            e.message ??
            'Tried to change your username, however we are running into an unexpected error.',
      );
    }
  }

  @override
  Future<UserModel?> getUserInfo({required String uid}) async {
    try {
      final docSnapshot = await collection.doc(uid).get();
      final docExists = docSnapshot.exists;
      log(docExists.toString());
      if (!docExists) return null;
      final userInfoMap = docSnapshot.data()!;
      log(userInfoMap.toString());
      return UserModel.fromMap(userInfoMap);
    } on FirebaseAuthException catch (e) {
      throw CustomException(
        code: e.code,
        message:
            e.message ?? 'Unable to get user info, due to an unexpected error.',
      );
    }
  }

  @override
  Future<void> logout() async {
    try {
      await auth.signOut();
    } on FirebaseAuthException catch (e) {
      throw CustomException(
        code: e.code,
        message:
            e.message ??
            'Failed to logout. Please check your internet status before loggingout',
      );
    }
  }
}
