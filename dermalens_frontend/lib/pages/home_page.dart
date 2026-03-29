import 'package:flutter/material.dart';
import 'package:dermalens/theme/app_colors.dart';
import 'package:lottie/lottie.dart'; // <--- ADD THIS LINE


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface, // The base dark surface
      body: SafeArea(
        child: SingleChildScrollView( 
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. GREETING & PROFILE SECTION
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    const SizedBox(height: 20),
                      const Text(
                        'Welcome, Hasaan!',
                        style: TextStyle(
                          fontFamily: 'Raleway',
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: AppColors.sand,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Ready to start your skincare journey?',
                        style: TextStyle(
                          fontFamily: 'Raleway',
                          fontSize: 17,
                          color: AppColors.sand, 
                        ),
                      ),
                    ],
                  ),
                                    // The Animated DermaLens Logo
                  Lottie.asset(
                    'lib/assets/animations/liquid_circle.json',
                    width: 40,
                    height: 40,
                    fit: BoxFit.contain,
                  ),

                 
                ],
                
              ),
              
              const SizedBox(height: 36),

                            // 2. PRIMARY AI TOOLS (SPLIT VIEW)
              const Text(
                'Diagnostic Tools',
                style: TextStyle(
                  fontFamily: 'Raleway',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.sand,
                ),
              ),
              const SizedBox(height: 16),
              
              Row(
                children: [
                  // BUTTON 1: Targeted Spot Check
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                      decoration: BoxDecoration(
                        color: AppColors.elevated,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.warmGold, width: 0.5),
                      ),
                      child: const Column(
                        children: [
                          Icon(Icons.center_focus_strong, color: AppColors.warmGold, size: 40),
                          SizedBox(height: 16),
                          Text(
                            'Spot Check',
                            style: TextStyle(
                              fontFamily: 'Raleway',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.warmGold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Analyze single lesion',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Raleway',
                              fontSize: 12,
                              color: AppColors.sand,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(width: 16), // Space between the cards

                  // BUTTON 2: Full Body Assessment
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                      decoration: BoxDecoration(
                        color: AppColors.surface, // Different color to contrast
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.sand, width: 0.5),
                      ),
                      child: const Column(
                        children: [
                          Icon(Icons.accessibility_new, color: AppColors.sand, size: 40),
                          SizedBox(height: 16),
                          Text(
                            'Full Check',
                            style: TextStyle(
                              fontFamily: 'Raleway',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.sand,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Whole body AI scan',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Raleway',
                              fontSize: 12,
                              color: AppColors.sand,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 300),

              // 3. DAILY SKIN TIP
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.sand),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.lightbulb_outline, color: AppColors.warmGold, size: 32),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Skincare Tip of the Day',
                            style: TextStyle(
                              fontFamily: 'Raleway',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.sand,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Remember to apply sunscreen even on cloudy days!',
                            style: TextStyle(
                              fontFamily: 'Raleway',
                              fontSize: 13,
                              color: AppColors.sand,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 36),
            ],
          ),
        ),
      ),
    );
  }
}
