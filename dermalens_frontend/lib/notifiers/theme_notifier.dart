import 'package:flutter/material.dart';

class ThemeNotifier extends ChangeNotifier {
  // This is a "Singleton" - it ensures the entire app shares the exact same radio station.
  static final ThemeNotifier _instance = ThemeNotifier._internal();
  factory ThemeNotifier() => _instance;
  ThemeNotifier._internal();

  // We start the app in Dark Mode.
  bool _isLightMode = false;

  bool get isLightMode => _isLightMode;

  void toggleTheme() {
    _isLightMode = !_isLightMode;
    notifyListeners(); // This shouts through the radio to redraw the app!
  }
}
