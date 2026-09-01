import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isg_ihlal/data/repo/firebase_provider.dart';
import 'package:isg_ihlal/data/repo/notification_repo.dart';
import 'package:isg_ihlal/data/states/notification_states.dart';

class NotificationCubit extends Cubit<NotificationStates> {
  NotificationCubit() : super(NotificationInitialState()) {
    listenToNotifications();
  }

  final NotificationRepo _notRepo = NotificationRepo.instance;

  void listenToNotifications() {
    emit(NotificationLoadingState());
    _notRepo.getNotifications.listen((list) {
      final uid = FirebaseProvider.instance.uid;

      final items = list.map((v) {
        final bool isNew = uid != null && !v.seenBy.contains(uid);
        return NotificationItem(violation: v, isNew: isNew);
      }).toList();

      final int unseenCount = items.where((item) => item.isNew).length;

      emit(
        NotificationLoadedState(
          items: items,
          unseenCount: unseenCount,
        ),
      );
    }, onError: (e) => emit(NotificationErrorState(e.toString())));
  }
}
