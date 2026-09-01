import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isg_ihlal/data/entity/violation.dart';
import 'package:isg_ihlal/data/repo/archive_repo.dart';
import 'package:isg_ihlal/data/states/archive_states.dart';

class ArchiveCubit extends Cubit<ArchiveStates> {
  final ArchiveRepository _repo;
  StreamSubscription<List<Violation>>? _subscription;

  ArchiveCubit({ArchiveRepository? repo})
      : _repo = repo ?? ArchiveRepo.instance,
        super(ArchiveInitialState()) {
    listenToArchives();
  }

  void listenToArchives() {
    emit(ArchiveLoadingState());
    _subscription?.cancel();
    _subscription = _repo.archiveList.listen(
      (list) => emit(ArchiveLoadedState(list)),
      onError: (e) => emit(ArchiveErrorState(e.toString())),
    );
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
