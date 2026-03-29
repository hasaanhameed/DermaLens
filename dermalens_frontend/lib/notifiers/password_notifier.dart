import 'package:flutter/material.dart';

class PasswordNotifier extends ChangeNotifier {
  bool hidePassword = true;
  bool hideConfirmPassword = true;

  void togglePassword() {
    hidePassword = !hidePassword;
    notifyListeners();
  }

  void toggleConfirmPassword() {
    hideConfirmPassword = !hideConfirmPassword;
    notifyListeners();
  }
}
