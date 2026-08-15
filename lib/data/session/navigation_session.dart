import 'package:flutter/material.dart';
import 'package:isg_ihlal/data/session/navigation_enum.dart';

class NavigationSession with ChangeNotifier {
  NavigationSession._init();
  static final NavigationSession instance = NavigationSession._init();
  factory NavigationSession() => instance;

  NavigationElement _navigationIndex = NavigationElement.home;
  NavigationElement get navigationIndex => _navigationIndex;

  void updateIndex(NavigationElement i) {
    _navigationIndex = i;
    notifyListeners();
  }
}