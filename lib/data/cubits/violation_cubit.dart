import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isg_ihlal/data/entity/violation.dart';
import 'package:isg_ihlal/data/repo/home_repo.dart';
import 'package:isg_ihlal/data/states/home_states.dart';

class ViolationCubit extends Cubit<ViolationStates> {
  HomeRepo _repo = HomeRepo.instance;

  ViolationCubit() : super(InitialViolationState()) {
    listenToTheList();
    listenToTheArchives();
  }
  
  void listenToTheList() {
    emit(ViolationLoadingState());
    _repo.violationList.listen(
      (list) => emit(ViolationLoadedState(list)),
      onError: (e) => emit(ViolationErrorState("Sıkıntı var")),
    );
  }

  void listenToTheArchives() {
    emit(ViolationLoadingState());
    _repo.archives.listen(
      (list) => emit(ViolationLoadedState(list)),
      onError: (e) => emit(ViolationErrorState(e)),
    );
  }
}
