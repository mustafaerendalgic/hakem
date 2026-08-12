import 'package:flutter/material.dart';
import 'package:isg_ihlal/data/session/navigation_enum.dart';

class Session with ChangeNotifier {
  Session._internal();
  static final Session instance = Session._internal();
  factory Session() => instance;

  NavigationElement _navigationIndex = NavigationElement.home;
  NavigationElement get navigationIndex => _navigationIndex;

  void updateIndex(NavigationElement i) {
    _navigationIndex = i;
    notifyListeners();
  }
}
