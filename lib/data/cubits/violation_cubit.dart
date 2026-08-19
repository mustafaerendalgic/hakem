import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isg_ihlal/data/entity/violation.dart';
import 'package:isg_ihlal/data/repo/home_repo.dart';
import 'package:isg_ihlal/data/repo/notification_repo.dart';
import 'package:isg_ihlal/data/states/home_states.dart';

class ViolationCubit extends Cubit<ViolationStates> {
  // kısıtlama
  HomeRepo _repo = HomeRepo.instance;

  ViolationCubit() : super(InitialViolationState()) {
    listenToTheList();
  }

  Future<void> addViolations() async {
    _repo.addViolations();
  }

  void listenToTheList() {
    emit(ViolationLoadingState());
    _repo.violationList.listen(
      (list) => emit(ViolationLoadedState(list)),
      onError: (e) => emit(ViolationErrorState(e.toString())),
    );
  }

  void listenToTheArchives() {
    emit(ViolationLoadingState());
    _repo.archives.listen(
      (list) => emit(ViolationLoadedState(list)),
      onError: (e) => emit(ViolationErrorState(e.toString())),
    );
  }
}
