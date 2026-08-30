import 'package:isg_ihlal/data/entity/violation.dart';

sealed class FormStates {}

class FormInitial extends FormStates {}

class FormUploading extends FormStates {
}

class FormUploaded extends FormStates {
  Violation violation;
  FormUploaded(this.violation);
}

class FormError extends FormStates {
  String error;
  FormError(this.error);
}
