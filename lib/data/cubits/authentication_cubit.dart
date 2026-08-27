import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isg_ihlal/data/repo/auth_repo.dart';
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

  Future<void> deAuthenticate(VoidCallback callback) async {
    try {
      await _authRepo.signOut();
      callback();
      emit(NotAuthenticatedState());
    } catch (e) {
      emit(AuthenticationErrorState(e.toString()));
    }
  }

  Future<void> signUp(String eMail, String password) async {
    emit(SigningUpState(eMail, password));
    try {
      await _authRepo.signUp(eMail, password);
    } catch (e) {
      emit(SigningUpErrorState(e.toString()));
    }
  }
}
