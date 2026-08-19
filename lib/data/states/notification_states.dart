import 'package:isg_ihlal/data/entity/violation.dart';

sealed class NotificationStates {}

class NotificationInitialState extends NotificationStates {}

class NotificationLoadingState extends NotificationStates {}

class NotificationLoadedState extends NotificationStates {
  List<Violation> notifications;
  NotificationLoadedState(this.notifications);
}

class NotificationErrorState extends NotificationStates {
  String error;
  NotificationErrorState(this.error);
}
