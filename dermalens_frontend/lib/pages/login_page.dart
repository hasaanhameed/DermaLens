import 'package:dermalens/widget_tree.dart';
import 'package:flutter/material.dart';
import '../notifiers/password_notifier.dart';
import '../theme/app_colors.dart';
import '../services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _passwordNotifier = PasswordNotifier();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  @override
  void dispose() {
    _passwordNotifier.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final data = await _authService.loginUser(email, password);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_name', data['user']['name'] ?? 'User');
      await prefs.setString('access_token', data['access_token']);

      
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const WidgetTree()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.surface,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Center(
              child: Column(
                children: [

                  SizedBox(height: 20),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back, color: AppColors.sand),
                    ),
                  ),
                  const SizedBox(height: 80),

                  

                  const SizedBox(height: 30),

                  const Text(
                    'Login',
                    style: TextStyle(
                      fontFamily: 'Raleway',
                      fontSize: 38,
                      fontWeight: FontWeight.w400,
                      color: AppColors.sand,
                    ),
                  ),

                  const SizedBox(height: 24),

                  TextField(
                    controller: _emailController,
                    style: const TextStyle(
                      fontFamily: 'Raleway',
                      color: AppColors.blush,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: const TextStyle(
                        fontFamily: 'Raleway',
                        color: AppColors.sand,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.elevated),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.warmGold),
                      ),
                      filled: true,
                      fillColor: AppColors.elevated,
                    ),
                  ),

                  const SizedBox(height: 12),

                  ListenableBuilder(
                    listenable: _passwordNotifier,
                    builder: (context, _) {
                      return TextField(
                        controller: _passwordController,
                        obscureText: _passwordNotifier.hidePassword,
                        style: const TextStyle(
                          fontFamily: 'Raleway',
                          color: AppColors.blush,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: const TextStyle(
                            fontFamily: 'Raleway',
                            color: AppColors.sand,
                          ),
                          suffixIcon: IconButton(
                            onPressed: _passwordNotifier.togglePassword,
                            icon: Icon(
                              _passwordNotifier.hidePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: AppColors.sand,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: AppColors.elevated,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: AppColors.warmGold,
                            ),
                          ),
                          filled: true,
                          fillColor: AppColors.elevated,
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 12),

                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.warmGold,
                        foregroundColor: AppColors.deepVoid,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                color: AppColors.deepVoid,
                                strokeWidth: 3,
                              ),
                            )
                          : const Text(
                              'Continue',
                              style: TextStyle(
                                fontFamily: 'Raleway',
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
