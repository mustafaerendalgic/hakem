
import 'package:camera/camera.dart';

class CameraRepository {
  CameraRepository._();
  static final CameraRepository instance = CameraRepository._();
  factory CameraRepository() => instance;

  CameraController? _controller;
  CameraDescription? _camera;

  CameraController? get controller => _controller;

  Future<void> initializeCamera() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) {
      throw Exception('Kullanılabilir kamera bulunamadı');
    }
    _camera = cameras.first;
    _controller = CameraController(_camera!, ResolutionPreset.high);
    await _controller!.initialize();
  }

  Future<XFile> takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized) {
      throw Exception('Kamera henüz hazır değil');
    }
    final XFile xFile = await _controller!.takePicture();
    return xFile;
  }

  void dispose() {
    _controller?.dispose();
    _controller = null;
  }
}
