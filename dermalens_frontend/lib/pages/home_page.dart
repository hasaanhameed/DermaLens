import 'package:flutter/material.dart';
import 'package:dermalens/theme/app_colors.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Grab the current theme (which magically updates when the toggle is flipped!)
    final theme = Theme.of(context);

    final bgColor = theme.scaffoldBackgroundColor;
    final cardColor = theme.cardColor;
    final textColor = theme.colorScheme.onSurface; // DeepVoid for light mode, Sand for dark mode
        final accentColor = theme.colorScheme.primary; // Mapped to gold in dark, black in light!


    return Scaffold(
      backgroundColor: bgColor, 
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. GREETING & PROFILE SECTION
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    'Welcome, Hasaan!',
                    style: TextStyle(
                      fontFamily: 'Raleway',
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: textColor, // <--- Dynamic text!
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Ready to start your skincare journey?',
                    style: TextStyle(
                      fontFamily: 'Raleway',
                      fontSize: 17,
                      color: textColor,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 36),

              // 2. PRIMARY AI TOOL
              const SizedBox(height: 16),

              // The Single "Scan Now" Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    print("Scan Button Clicked!");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cardColor, // <--- Dynamic Card background!
                    padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: accentColor, width: 0.5),
                    ),
                    elevation: 0,
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.center_focus_strong, color: accentColor, size: 56),
                      const SizedBox(height: 16),
                      Text(
                        'Scan Image',
                        style: TextStyle(
                          fontFamily: 'Raleway',
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: accentColor, // Keep Gold fixed
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'AI analysis of skin lesions',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontFamily: 'Raleway', fontSize: 14, color: textColor),
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
                  color: bgColor.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: textColor.withOpacity(0.2), width: 1), // Subtle dynamic border
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'How to use DermaLens:',
                      style: TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: accentColor, // Keep Gold fixed
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '1. Tap the Scan Image button above.\n'
                      '2. Take or upload a clear, well-lit photo of the affected area.\n'
                      '3. Wait while our AI model identifies the issue.\n'
                      '4. Review your results, confidence score, and severity.',
                      style: TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 14,
                        height: 1.6, 
                        color: textColor, // Dynamic text!
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
                  color: bgColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: textColor.withOpacity(0.1), width: 1),
                ),
                child: Row(
                  children: [
                    Icon(Icons.lightbulb_outline, color: accentColor, size: 32),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Skincare Tip of the Day',
                            style: TextStyle(fontFamily: 'Raleway', fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Remember to apply sunscreen even on cloudy days!',
                            style: TextStyle(fontFamily: 'Raleway', fontSize: 13, color: textColor.withOpacity(0.8)),
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
