import 'package:isg_ihlal/data/entity/violation.dart';

sealed class DetailStates {}

class DetailInitial extends DetailStates {}

class DetailActionPerforming extends DetailStates {}

class DetailActionPerformed extends DetailStates {}

class DetailError extends DetailStates {}

abstract class DetailActions {
  Future<void> takeUnderReview(Violation violation);
  Future<void> cancelViolation(Violation violation);
  Future<void> reopenViolation(Violation violation);
  Future<void> resolveViolation(Violation violation);
}
