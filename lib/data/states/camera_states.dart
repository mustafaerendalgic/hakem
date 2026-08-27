
import 'package:camera/camera.dart';

sealed class CameraState {
  const CameraState();
}

class CameraInitial extends CameraState {
  const CameraInitial();
}

class CameraLoading extends CameraState {
  const CameraLoading();
}

class CameraReady extends CameraState {
  final CameraController controller;

  const CameraReady(this.controller);
}

class CameraCapturing extends CameraState {
  final CameraController controller;

  const CameraCapturing(this.controller);
}

class CameraCaptured extends CameraState {
  final XFile image;

  const CameraCaptured(this.image);
}

class CameraError extends CameraState {
  final String message;

  const CameraError(this.message);
}