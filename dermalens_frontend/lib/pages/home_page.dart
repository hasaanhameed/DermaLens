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


                            // 2. PRIMARY AI TOOL
              
              const SizedBox(height: 16),
              
              // The Single "Scan Now" Button
                            // The Single "Scan Now" Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // For now, it just prints to the terminal, routing comes later!
                    print("Scan Button Clicked!");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.elevated,
                    padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: const BorderSide(color: AppColors.warmGold, width: 0.5),
                    ),
                    elevation: 0, // Set to 0 so it matches your flat, sleek design
                  ),
                  child: const Column(
                    children: [
                      Icon(Icons.center_focus_strong, color: AppColors.warmGold, size: 56),
                      SizedBox(height: 16),
                      Text(
                        'Scan Image',
                        style: TextStyle(
                          fontFamily: 'Raleway',
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.warmGold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'AI analysis of skin lesions',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Raleway',
                          fontSize: 14,
                          color: AppColors.sand,
                        ),
                      ),
                    ],
                  ),
                ),
              ),


              const SizedBox(height: 24),

              // INSTRUCTIONS BOX
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'How to use DermaLens:',
                      style: TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.warmGold,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      '1. Tap the Scan Image button above.\n'
                      '2. Take or upload a clear, well-lit photo of the affected area.\n'
                      '3. Wait while our Deep Learning model identifies the issue.\n'
                      '4. Review your results, confidence score, and severity.',
                      style: TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 14,
                        height: 1.6, // Adding line height to make it spaced out and readable
                        color: AppColors.sand,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 36),


                           
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
