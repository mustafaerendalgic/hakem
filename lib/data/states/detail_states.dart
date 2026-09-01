import 'package:isg_ihlal/data/entity/violation.dart';

sealed class DetailStates {}

class DetailInitial extends DetailStates {}
class DetailLoaded extends DetailStates {
  final Violation violation;
  DetailLoaded(this.violation);
}
class DetailViolationCanceling extends DetailStates {}
class DetailViolationInvestigating extends DetailStates {}
class DetailViolationResolving extends DetailStates {}
class DetailViolationReopening extends DetailStates {}

class DetailError extends DetailStates {}

abstract class DetailActions {
  Future<void> takeUnderReview(Violation violation);
  Future<void> cancelViolation(Violation violation);
  Future<void> reopenViolation(Violation violation);
  Future<void> resolveViolation(Violation violation);
}
