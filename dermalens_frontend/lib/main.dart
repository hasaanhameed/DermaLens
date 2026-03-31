import 'package:flutter/material.dart';
import 'package:dermalens/pages/welcome_page.dart';
import 'package:dermalens/theme/app_colors.dart';
import 'package:dermalens/notifiers/theme_notifier.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // We plug in the radio here!
    return ListenableBuilder(
      listenable: ThemeNotifier(),
      builder: (context, child) {
        
        return MaterialApp(
          title: 'DermaLens',
          debugShowCheckedModeBanner: false,
          
          // Switch themes instantly based on the radio signal!
          themeMode: ThemeNotifier().isLightMode ? ThemeMode.light : ThemeMode.dark,

          // ------------------------------------------------
          // 1. YOUR DARK THEME MAPPING
          // ------------------------------------------------
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            scaffoldBackgroundColor: AppColors.surface, // Dark Grey Background
            cardColor: AppColors.elevated,              // Dark Grey Cards
            colorScheme: const ColorScheme.dark(
              surface: AppColors.surface,               // Replaces manual AppColors.surface
              onSurface: AppColors.sand,                // Text color on dark surfaces
              primary: AppColors.warmGold,              // Accent color
              secondary: AppColors.elevated,            // Card colors
            ),
            fontFamily: 'Raleway',
          ),

       
          theme: ThemeData( // This represents the 'lightTheme'
            brightness: Brightness.light,
            scaffoldBackgroundColor: AppColors.blush,   // Beautiful Cream Background
            cardColor: AppColors.cream,                    // Off-white cream cards instead of stark white!
            colorScheme: const ColorScheme.light(
              surface: AppColors.blush,                 // The cream background
              onSurface: AppColors.deepVoid,            // Almost black text for readability
              primary: AppColors.deepVoid,              // Black accent instead of gold!
              secondary: AppColors.cream,                  // Soft cream alternative to white
            ),
            fontFamily: 'Raleway',
          ),
          
          home: const WelcomePage(),
        );
      },
    );
  }
}
