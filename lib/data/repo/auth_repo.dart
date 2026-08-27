import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:isg_ihlal/data/repo/firebase_provider.dart';
import 'package:isg_ihlal/data/states/authentication_states.dart';

class AuthManagerImp implements AuthRepository {
  FirebaseProvider firebaseProvider = FirebaseProvider.instance;
  AuthManagerImp._init(this.firebaseProvider);
  static final AuthManagerImp instance = AuthManagerImp._init(
    FirebaseProvider.instance,
  );
  factory AuthManagerImp() => instance;

  FirebaseAuth get _auth => firebaseProvider.auth;
  CollectionReference get _usersRef => firebaseProvider.userCollection;

  @override
  Stream<User?> get authStateChanges {
    return _auth.authStateChanges().map((user) {
      return user;
    });
  }

  @override
  Future<void> signIn(String eMail, String password) async {
    await _auth.signInWithEmailAndPassword(email: eMail, password: password);
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
  }

  @override
  Future<void> signUp(String eMail, String password) async {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: eMail,
      password: password,
    );
    User? user = userCredential.user;
    //değilse
    if (user != null) {
      final userDocRef = _usersRef.doc(user.uid);
      final doc = await userDocRef.get();
      if (!doc.exists) {
        await userDocRef.set({
          'createdAt': FieldValue.serverTimestamp(),
          'email': user.email,
          'lastReadNotification': FieldValue.serverTimestamp(),
        });
      }
    }
  }
}
