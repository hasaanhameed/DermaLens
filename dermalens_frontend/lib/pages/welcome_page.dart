import 'package:dermalens/pages/login_page.dart';
import 'package:dermalens/pages/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:dermalens/theme/app_colors.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.elevated,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'DermaLens',
                style: TextStyle(
                  fontFamily: 'Raleway',
                  fontSize: 36,
                  fontWeight: FontWeight.w600,
                  color: AppColors.sand,
                ),
              ),

              const SizedBox(height: 2),

              const Text(
                'Scan. Identify. Heal.',
                style: TextStyle(
                  fontFamily: 'Raleway',
                  fontSize: 14,
                  color: AppColors.warmGold,
                ),
              ),

              Lottie.asset(
                'lib/assets/animations/liquid_circle.json',
                width: 300,
                height: 300,
              ),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return const SignupPage();
                        },
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.surface,
                    foregroundColor: AppColors.sand,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Create Account',
                    style: TextStyle(
                      fontFamily: 'Raleway',
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              SizedBox(
                width: double.infinity,
                height: 54,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.sand,
                    side: const BorderSide(color: AppColors.sand),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Login',
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
    );
  }
}
