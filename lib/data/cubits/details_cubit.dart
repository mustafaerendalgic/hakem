import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isg_ihlal/data/entity/violation.dart';
import 'package:isg_ihlal/data/repo/detail_repo.dart';
import 'package:isg_ihlal/data/repo/firebase_provider.dart';
import 'package:isg_ihlal/data/states/detail_states.dart';

class DetailsCubit extends Cubit<DetailStates> implements DetailActions {
  DetailsCubit() : super(DetailInitial());
  final DetailRepo _repo = DetailRepo.instance;

  StreamSubscription? _violationSubscription;

  void listenToViolation(String violationId) {
    _violationSubscription?.cancel();
    bool _markedAsSeen = false;
    _violationSubscription = FirebaseProvider.instance.violationCollection
        .doc(violationId)
        .snapshots()
        .listen(
      (snapshot) {
        if (snapshot.exists) {
          final map = snapshot.data() as Map<String, dynamic>;
          final violation = Violation.fromMap(snapshot.id, map);
          emit(DetailLoaded(violation));

          if (!_markedAsSeen) {
            _markedAsSeen = true;
            final uid = FirebaseProvider.instance.uid;
            if (uid != null && !violation.seenBy.contains(uid)) {
              _repo.markAsSeen(violationId);
            }
          }
        }
      },
      onError: (e) => emit(DetailError()),
    );
  }

  @override
  Future<void> reopenViolation(Violation violation) async {
    emit(DetailViolationReopening());
    try {
      await _repo.updateViolation(violation, ActionType.posted);
    } catch (e) {
      emit(DetailError());
    }
  }

  @override
  Future<void> resolveViolation(Violation violation) async {
    emit(DetailViolationResolving());
    try {
      await _repo.updateViolation(violation, ActionType.resolved);
    } catch (e) {
      emit(DetailError());
    }
  }

  @override
  Future<void> takeUnderReview(Violation violation) async {
    emit(DetailViolationInvestigating());
    try {
      await _repo.updateViolation(violation, ActionType.investigating);
    } catch (e) {
      emit(DetailError());
    }
  }

  @override
  Future<void> cancelViolation(Violation violation) async {
    emit(DetailViolationCanceling());
    try {
      await _repo.updateViolation(violation, ActionType.rejected);
    } catch (e) {
      emit(DetailError());
    }
  }

  @override
  Future<void> close() {
    _violationSubscription?.cancel();
    return super.close();
  }
}
