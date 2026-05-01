import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';
import '../widget_tree.dart';

class AuthNotifier extends ChangeNotifier {
  final AuthService _authService = AuthService();

  final TextEditingController loginEmailController = TextEditingController();
  final TextEditingController loginPasswordController = TextEditingController();

  final TextEditingController signupNameController = TextEditingController();
  final TextEditingController signupEmailController = TextEditingController();
  final TextEditingController signupPasswordController = TextEditingController();
  final TextEditingController signupConfirmPasswordController = TextEditingController();

  bool isLoading = false;
  bool hidePassword = true;
  bool hideConfirmPassword = true;
  bool agreedToTerms = false;

  void togglePassword() {
    hidePassword = !hidePassword;
    notifyListeners();
  }

  void toggleConfirmPassword() {
    hideConfirmPassword = !hideConfirmPassword;
    notifyListeners();
  }

  void toggleTerms(bool value) {
    agreedToTerms = value;
    notifyListeners();
  }

  Future<void> handleLogin(BuildContext context) async {
    final email = loginEmailController.text.trim();
    final password = loginPasswordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showError(context, "Please fill in all fields");
      return;
    }

    _setLoading(true);

    try {
      final response = await _authService.loginUser(email, password);
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', response['access_token']);
      await prefs.setString('user_name', response['user']['name'] ?? 'User');

      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const WidgetTree()),
        );
      }
    } catch (e) {
      if (context.mounted) _showError(context, e.toString().replaceAll('Exception: ', ''));
    } finally {
      _setLoading(false);
    }
  }

  Future<void> handleSignup(BuildContext context) async {
    final name = signupNameController.text.trim();
    final email = signupEmailController.text.trim();
    final password = signupPasswordController.text;
    final confirmPassword = signupConfirmPasswordController.text;

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      _showError(context, "Please fill in all fields");
      return;
    }

    if (password != confirmPassword) {
      _showError(context, "Passwords do not match");
      return;
    }

    if (!agreedToTerms) {
      _showError(context, "You must agree to the Terms & Conditions first");
      return;
    }

    _setLoading(true);

    try {
      await _authService.registerUser(name, email, password);
      if (context.mounted) {
        _showSuccess(context, "Account created! Please login.");
        Navigator.pop(context); 
      }
    } catch (e) {
      if (context.mounted) _showError(context, e.toString().replaceAll('Exception: ', ''));
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.redAccent),
    );
  }

  void _showSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }
  @override
  void dispose() {
    loginEmailController.dispose();
    loginPasswordController.dispose();
    signupNameController.dispose();
    signupEmailController.dispose();
    signupPasswordController.dispose();
    signupConfirmPasswordController.dispose();
    super.dispose();
  }
}
