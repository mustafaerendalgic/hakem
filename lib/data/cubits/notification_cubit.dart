import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isg_ihlal/data/repo/notification_repo.dart';
import 'package:isg_ihlal/data/states/notification_states.dart';

class NotificationCubit extends Cubit<NotificationStates> {
  NotificationCubit() : super(NotificationInitialState()) {
    listenToNotifications();
  }

  NotificationRepo _notRepo = NotificationRepo.instance;

  void listenToNotifications() {
    emit(NotificationLoadingState());
    _notRepo.getNewViolations.listen((list) {
      emit(NotificationLoadedState(list));
    }, onError: (e) => emit(NotificationErrorState(e.toString())));
  }
}
