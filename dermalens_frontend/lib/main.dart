import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'notifiers/theme_notifier.dart';
import 'notifiers/auth_notifier.dart';
import 'notifiers/home_notifier.dart';
import 'notifiers/chat_notifier.dart';
import 'notifiers/profile_notifier.dart';
import 'notifiers/history_notifier.dart';
import 'pages/welcome_page.dart';
import 'theme/app_colors.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthNotifier()),
        ChangeNotifierProvider(create: (_) => HomeNotifier()),
        ChangeNotifierProvider(create: (_) => ChatNotifier()),
        ChangeNotifierProvider(create: (_) => ProfileNotifier()),
        ChangeNotifierProvider(create: (_) => HistoryNotifier()),
      ],
      child: const MyApp(),
    ),
  );
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
            scaffoldBackgroundColor: AppColors.blush,   // Warm cream background
            cardColor: AppColors.sand,                  // Blended sand for all cards & boxes
            colorScheme: const ColorScheme.light(
              surface: AppColors.blush,
              onSurface: AppColors.deepVoid,
              primary: AppColors.deepVoid,
              secondary: AppColors.sand,
            ),
            fontFamily: 'Raleway',
          ),
          
          home: const WelcomePage(),
        );
      },
    );
  }
}
