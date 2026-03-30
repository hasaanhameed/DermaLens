import 'package:dermalens/widget_tree.dart';
import 'package:flutter/material.dart';
import '../notifiers/password_notifier.dart';
import '../theme/app_colors.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _passwordNotifier = PasswordNotifier();

  @override
  void dispose() {
    _passwordNotifier.dispose();
    super.dispose();
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
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const WidgetTree(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.warmGold,
                        foregroundColor: AppColors.deepVoid,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
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
