import 'package:flutter/material.dart';
import 'package:dermalens/theme/app_colors.dart';
import 'package:dermalens/pages/welcome_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DermaLens',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.warmGold),
        useMaterial3: true,
      ),
      home: const WelcomePage(),
    );
  }
}
