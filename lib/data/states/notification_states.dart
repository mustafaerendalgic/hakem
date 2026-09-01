import 'package:isg_ihlal/data/entity/violation.dart';

sealed class NotificationStates {}

class NotificationInitialState extends NotificationStates {}

class NotificationLoadingState extends NotificationStates {}

class NotificationItem {
  final Violation violation;
  final bool isNew;

  const NotificationItem({
    required this.violation,
    required this.isNew,
  });
}

class NotificationLoadedState extends NotificationStates {
  final List<NotificationItem> items;
  final int unseenCount;

  NotificationLoadedState({
    required this.items,
    required this.unseenCount,
  });
}

class NotificationErrorState extends NotificationStates {
  final String error;
  NotificationErrorState(this.error);
}
