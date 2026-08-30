import 'package:flutter/material.dart';
import 'package:isg_ihlal/data/entity/violation.dart';
import 'package:isg_ihlal/data/session/navigation_enum.dart';

sealed class NavigationScreen {}

class TabScreenSession extends NavigationScreen {
  final NavigationElement element;
  TabScreenSession(this.element);
}

class DetailScreenSession extends NavigationScreen {
  final Violation violation;
  DetailScreenSession(this.violation);
}

class NavigationSession with ChangeNotifier {
  NavigationSession._init();
  static final NavigationSession instance = NavigationSession._init();
  factory NavigationSession() => instance;

  NavigationScreen _navigationIndex = TabScreenSession(NavigationElement.home);
  NavigationScreen get navigationIndex => _navigationIndex;

  AuthNavigationElement _authNavigationElement = AuthNavigationElement.login;
  AuthNavigationElement get authNavigationElement => _authNavigationElement;

  CameraNavigationElement _cameraNavigationElement =
      CameraNavigationElement.camera;
  CameraNavigationElement get cameraNavigationElement =>
      _cameraNavigationElement;

  Violation? _selectedViolation;
  Violation? get selectedViolation => _selectedViolation;

  void updateAuthIndex(AuthNavigationElement i) {
    _authNavigationElement = i;
    notifyListeners();
  }

  void updateIndex(NavigationElement i) {
    _navigationIndex = TabScreenSession(i);
    notifyListeners();
  }

  void updateCameraIndex(CameraNavigationElement i) {
    _cameraNavigationElement = i;
    notifyListeners();
  }

  void navigateToDetail(Violation violation) {
    _selectedViolation = violation;
    _navigationIndex = DetailScreenSession(violation);
    notifyListeners();
  }
}
