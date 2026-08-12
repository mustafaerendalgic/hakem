import 'package:isg_ihlal/data/entity/violation.dart';

sealed class ViolationStates {}

class InitialViolationState extends ViolationStates {}

class ViolationLoadingState extends ViolationStates {}

class ViolationLoadedState extends ViolationStates {
  List<Violation> violations;
  ViolationLoadedState(this.violations);
}

class ViolationErrorState extends ViolationStates {
  String message;
  ViolationErrorState(this.message);
}
