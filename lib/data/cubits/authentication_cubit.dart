import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isg_ihlal/data/repo/authenticator_imp.dart';
import 'package:isg_ihlal/data/states/authentication_states.dart';

class AuthenticationCubit extends Cubit<AuthenticationStates> {
  AuthManagerImp _authRepo = AuthManagerImp();

  AuthenticationCubit() : super(NotAuthenticatedState()) {
    listenToAuthStates();
  }

  Future<void> listenToAuthStates() async {
    _authRepo.authStateChanges.listen((user) {
      user != null
          ? emit(AuthenticatedState(user))
          : emit(NotAuthenticatedState());
    }, onError: (e) => emit(AuthenticationErrorState(e.toString())));
  }

  Future<void> authenticate(String eMail, String password) async {
    emit(AuthenticatingState(eMail, password));
    try {
      await _authRepo.signIn(eMail, password);
    } catch (e) {
      emit(AuthenticationErrorState(e.toString()));
    }
  }

  Future<void> deAuthenticate() async {
    try {
      await _authRepo.signOut();
      emit(NotAuthenticatedState());
    } catch (e) {
      emit(AuthenticationErrorState(e.toString()));
    }
  }
}
