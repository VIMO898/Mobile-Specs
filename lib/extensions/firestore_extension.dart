import 'package:cloud_firestore/cloud_firestore.dart';

extension FirestoreExtension on FirebaseFirestore {
  CollectionReference<Map<String, dynamic>> userCollection() {
    return collection('users');
  }
}
