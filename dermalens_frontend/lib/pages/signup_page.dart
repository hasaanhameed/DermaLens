import 'package:flutter/material.dart';
import '../notifiers/password_notifier.dart';
import '../theme/app_colors.dart';
import 'terms_page.dart';
import '../services/auth_service.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _passwordNotifier = PasswordNotifier();
  bool _agreedToTerms = false;
  
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  @override
  void dispose() {
    _passwordNotifier.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                      controller: _nameController,
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
                    ),

                    const SizedBox(height: 12),

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

                    ListenableBuilder(
                      listenable: _passwordNotifier,
                      builder: (context, _) {
                        return TextField(
                          controller: _confirmPasswordController,
                          obscureText: _passwordNotifier.hideConfirmPassword,
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
                              onPressed:
                                  _passwordNotifier.toggleConfirmPassword,
                              icon: Icon(
                                _passwordNotifier.hideConfirmPassword
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

                    Row(
                      children: [
                        Checkbox(
                          value: _agreedToTerms,
                          onChanged: (val) {
                            setState(() {
                              _agreedToTerms = val ?? false;
                            });
                          },
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
                                MaterialPageRoute(
                                  builder: (context) => const TermsPage(),
                                ),
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
                        onPressed: _isLoading ? null : () async {
                          if (!_agreedToTerms) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'You must agree to the Terms & Conditions first',
                                  style: TextStyle(
                                    fontFamily: 'Raleway',
                                    color: AppColors.elevated,
                                  ),
                                ),
                                backgroundColor: AppColors.sand,
                                duration: Duration(seconds: 2),
                              ),
                            );
                            return;
                          }

                          if (_passwordController.text != _confirmPasswordController.text) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Passwords do not match'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }

                          setState(() => _isLoading = true);

                          try {
                            await _authService.registerUser(
                              _nameController.text,
                              _emailController.text,
                              _passwordController.text,
                            );

                            if (mounted) {
                              Navigator.popUntil(context, (route) => route.isFirst);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Account successfully created',
                                    style: TextStyle(
                                      fontFamily: 'Raleway',
                                      color: AppColors.elevated,
                                    ),
                                  ),
                                  backgroundColor: AppColors.sand,
                                  duration: Duration(seconds: 3),
                                ),
                              );
                            }
                          } catch (e) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    e.toString().replaceAll('Exception: ', ''),
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          } finally {
                            if (mounted) {
                              setState(() => _isLoading = false);
                            }
                          }
                        },
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
                                child: CircularProgressIndicator(color: AppColors.deepVoid, strokeWidth: 3,)
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
  }
}
