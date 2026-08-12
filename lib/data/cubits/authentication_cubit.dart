import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isg_ihlal/data/states/authentication_states.dart';

class AuthenticationCubit extends Cubit<AuthenticationStates> {
  AuthenticationCubit() : super(NotAuthenticatedState());

  void authenticate() {
    emit(AuthenticatedState());
  }

  void deAuthenticate() {
    emit(NotAuthenticatedState());
  }
}
