import 'package:firebase_auth/firebase_auth.dart';

sealed class AuthenticationStates {}

class AuthenticatedState extends AuthenticationStates {
  User user;
  AuthenticatedState(this.user);
}

class AuthenticatingState extends AuthenticationStates {
  String eMail;
  String password;
  AuthenticatingState(this.eMail, this.password);
}

class NotAuthenticatedState extends AuthenticationStates {}

class AuthenticationErrorState extends AuthenticationStates {
  String e;
  AuthenticationErrorState(this.e);
}

class SignUpInitial extends AuthenticationStates {}

class SigningUpState extends AuthenticationStates {
  final String eMail;
  final String password;
  SigningUpState(this.eMail, this.password);
}

class SignedUpState extends AuthenticationStates {}

class SigningUpErrorState extends AuthenticationStates {
  String e;
  SigningUpErrorState(this.e);
}

abstract class AuthRepository {
  Stream<User?> get authStateChanges;
  Future<void> signIn(String eMail, String password);
  Future<void> signOut();
  Future<void> signUp(String eMail, String password);
}
