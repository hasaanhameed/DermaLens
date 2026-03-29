import 'package:flutter/material.dart';
import '../notifiers/navigation_notifier.dart';
import '../theme/app_colors.dart';

class FooterWidget extends StatelessWidget {
  final NavigationNotifier navigationNotifier;

  const FooterWidget({super.key, required this.navigationNotifier});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: navigationNotifier,
      builder: (context, _) {
        return BottomNavigationBar(
          currentIndex: navigationNotifier.currentIndex,
          onTap: navigationNotifier.setIndex,
          backgroundColor: AppColors.elevated,
          selectedItemColor: AppColors.warmGold,
          unselectedItemColor: AppColors.sand,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'History',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        );
      },
    );
  }
}
