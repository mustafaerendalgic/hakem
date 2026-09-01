import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isg_ihlal/data/repo/camera.dart';
import 'package:isg_ihlal/data/session/navigation_session.dart';
import 'package:isg_ihlal/data/session/navigation_enum.dart';
import 'package:isg_ihlal/data/states/camera_states.dart';

class CameraCubit extends Cubit<CameraState> {
  final CameraRepository _cameraRepository;

  CameraCubit(this._cameraRepository) : super(const CameraInitial());

  Future<void> initializeCamera() async {
    emit(const CameraLoading());
    try {
      await _cameraRepository.initializeCamera();
      final controller = _cameraRepository.controller;

      if (controller == null) {
        emit(const CameraError('Kamera başlatılamadı'));
        return;
      }

      emit(CameraReady(controller));
    } catch (e) {
      emit(CameraError(e.toString()));
    }
  }

  Future<void> takePicture() async {
    final currentState = state;
    if (currentState is! CameraReady) return;

    emit(CameraCapturing(currentState.controller));

    try {
      final file = await _cameraRepository.takePicture();
      emit(CameraCaptured(file));
    } catch (e) {
      emit(CameraError(e.toString()));
    }
  }

  void resetToReady() {
    final controller = _cameraRepository.controller;
    if (controller != null) {
      emit(CameraReady(controller));
    } else {
      emit(const CameraInitial());
    }

    NavigationSession.instance.updateCameraIndex(
      CameraNavigationElement.camera,
    );
  }

  @override
  Future<void> close() {
    _cameraRepository.dispose();
    return super.close();
  }
}
