import 'package:camera/camera.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isg_ihlal/data/entity/violation.dart';
import 'package:isg_ihlal/data/entity/violation_types.dart';
import 'package:isg_ihlal/data/repo/form_repo.dart';
import 'package:isg_ihlal/data/states/form_states.dart';

class FormCubit extends Cubit<FormStates> {
  FormCubit() : super(FormInitial());

  Future<void> uploadViolation(
    XFile xFile,
    String title,
    String location,
    ViolationType violationType,
  ) async {
    emit(FormUploading());
    Violation? violation = await FormRepo.instance.convertViolation(
      xFile,
      title,
      location,
      violationType,
    );
    if (violation == null) {
      emit(FormError("ihlal bulunamadı"));
      return;
    }
    FormRepo.instance.uploadViolation(violation);
    emit(FormUploaded(violation));
    try {} catch (e) {
      emit(FormError(e.toString()));
    }
  }
}
