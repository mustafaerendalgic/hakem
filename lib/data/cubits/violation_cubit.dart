import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isg_ihlal/data/entity/violation.dart';
import 'package:isg_ihlal/data/repo/home_repo.dart';
import 'package:isg_ihlal/data/states/home_states.dart';

class ViolationCubit extends Cubit<ViolationStates> {
  final HomeRepo _repo = HomeRepo.instance;
  StreamSubscription<List<Violation>>? _violationSubscription;

  ViolationCubit() : super(InitialViolationState()) {
    listenToTheList();
  }

  Future<void> addViolations() async {
    _repo.addViolations();
  }

  void listenToTheList() {
    emit(ViolationLoadingState());
    _violationSubscription?.cancel();
    _violationSubscription = _repo.violationList.listen(
      (list) => emit(ViolationLoadedState(list)),
      onError: (e) => emit(ViolationErrorState(e.toString())),
    );
  }

  @override
  Future<void> close() {
    _violationSubscription?.cancel();
    return super.close();
  }
}
