import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseProvider {
  FirebaseProvider._init();
  static final FirebaseProvider instance = FirebaseProvider._init();
  factory FirebaseProvider() => instance;

  FirebaseAuth get auth => FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? get uid => FirebaseAuth.instance.currentUser?.uid;
  CollectionReference get violationCollection =>
      _firestore.collection("violations");
  CollectionReference get userCollection => _firestore.collection("users");
}
