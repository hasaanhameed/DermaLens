import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../notifiers/auth_notifier.dart';
import '../theme/app_colors.dart';
import 'signup_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthNotifier>(
      builder: (context, notifier, child) {
        return Scaffold(
          backgroundColor: AppColors.surface,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  // Back Button
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, color: AppColors.sand),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  
                  const SizedBox(height: 80),
                  
                  Center(
                    child: Text(
                      'Login',
                      style: TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 48,
                        fontWeight: FontWeight.w400,
                        color: AppColors.sand.withOpacity(0.9),
                      ),
                    ),
                  ),

                  const SizedBox(height: 48),

                  TextField(
                    controller: notifier.loginEmailController,
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
                  
                  const SizedBox(height: 16),
                  
                  TextField(
                    controller: notifier.loginPasswordController,
                    obscureText: notifier.hidePassword,
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
                        onPressed: notifier.togglePassword,
                        icon: Icon(
                          notifier.hidePassword ? Icons.visibility_off : Icons.visibility,
                          color: AppColors.sand,
                        ),
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

                  const SizedBox(height: 32),

                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: notifier.isLoading ? null : () => notifier.handleLogin(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.warmGold,
                        foregroundColor: AppColors.deepVoid,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: notifier.isLoading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(color: AppColors.deepVoid, strokeWidth: 3),
                            )
                          : const Text(
                              'Continue',
                              style: TextStyle(
                                fontFamily: 'Raleway',
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account? ",
                        style: TextStyle(
                          fontFamily: 'Raleway',
                          color: AppColors.sand,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const SignupPage()),
                          );
                        },
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                            fontFamily: 'Raleway',
                            color: AppColors.warmGold,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
