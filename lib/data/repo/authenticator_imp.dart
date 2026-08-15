import 'package:firebase_auth/firebase_auth.dart';
import 'package:isg_ihlal/data/states/authentication_states.dart';

class AuthManagerImp implements AuthRepository {
  AuthManagerImp._init();
  static final AuthManagerImp instance = AuthManagerImp._init();
  factory AuthManagerImp() => instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;

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
}
