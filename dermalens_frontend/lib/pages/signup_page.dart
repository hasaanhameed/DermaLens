import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../notifiers/auth_notifier.dart';
import '../theme/app_colors.dart';
import 'terms_page.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthNotifier>(
      builder: (context, notifier, child) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: AppColors.surface,
            body: SingleChildScrollView(
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Center(
                    child: Column(
                      children: [
                        const SizedBox(height: 24),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(
                              Icons.arrow_back,
                              color: AppColors.sand,
                            ),
                          ),
                        ),
                        const Text(
                          'Create Account',
                          style: TextStyle(
                            fontFamily: 'Raleway',
                            fontSize: 30,
                            fontWeight: FontWeight.w400,
                            color: AppColors.sand,
                          ),
                        ),
                        const SizedBox(height: 24),
                        TextField(
                          controller: notifier.signupNameController,
                          style: const TextStyle(
                            fontFamily: 'Raleway',
                            color: AppColors.blush,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Name',
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
                        TextField(
                          controller: notifier.signupEmailController,
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
                        TextField(
                          controller: notifier.signupPasswordController,
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
                        const SizedBox(height: 12),
                        TextField(
                          controller: notifier.signupConfirmPasswordController,
                          obscureText: notifier.hideConfirmPassword,
                          style: const TextStyle(
                            fontFamily: 'Raleway',
                            color: AppColors.blush,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Confirm Password',
                            labelStyle: const TextStyle(
                              fontFamily: 'Raleway',
                              color: AppColors.sand,
                            ),
                            suffixIcon: IconButton(
                              onPressed: notifier.toggleConfirmPassword,
                              icon: Icon(
                                notifier.hideConfirmPassword ? Icons.visibility_off : Icons.visibility,
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
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Checkbox(
                              value: notifier.agreedToTerms,
                              onChanged: (val) => notifier.toggleTerms(val ?? false),
                              activeColor: AppColors.warmGold,
                              checkColor: AppColors.surface,
                              side: const BorderSide(
                                color: AppColors.sand,
                                width: 1.5,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const TermsPage()),
                                  );
                                },
                                child: const Text(
                                  'I agree to the Privacy Policy and Terms & Conditions',
                                  style: TextStyle(
                                    fontFamily: 'Raleway',
                                    color: AppColors.warmGold,
                                    decoration: TextDecoration.underline,
                                    decorationColor: AppColors.warmGold,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: ElevatedButton(
                            onPressed: notifier.isLoading ? null : () => notifier.handleSignup(context),
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
                                    'Create Account',
                                    style: TextStyle(
                                      fontFamily: 'Raleway',
                                      fontSize: 15,
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
          ),
        );
      },
    );
  }
}
