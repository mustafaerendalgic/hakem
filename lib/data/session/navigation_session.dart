import 'package:flutter/material.dart';
import 'package:isg_ihlal/data/session/navigation_enum.dart';

class NavigationSession with ChangeNotifier {
  NavigationSession._init();
  static final NavigationSession instance = NavigationSession._init();
  factory NavigationSession() => instance;

  NavigationElement _navigationIndex = NavigationElement.home;
  NavigationElement get navigationIndex => _navigationIndex;

  AuthNavigationElement _authNavigationElement = AuthNavigationElement.login;
  AuthNavigationElement get authNavigationElement => _authNavigationElement;

  CameraNavigationElement _cameraNavigationElement =
      CameraNavigationElement.camera;
  CameraNavigationElement get cameraNavigationElement =>
      _cameraNavigationElement;

  void updateAuthIndex(AuthNavigationElement i) {
    _authNavigationElement = i;
    notifyListeners();
  }

  void updateIndex(NavigationElement i) {
    _navigationIndex = i;
    notifyListeners();
  }

  void updateCameraIndex(CameraNavigationElement i) {
    _cameraNavigationElement = i;
    notifyListeners();
  }
}
