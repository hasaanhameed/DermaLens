import 'package:flutter/material.dart';
import '../notifiers/navigation_notifier.dart';
import '../theme/app_colors.dart';

class FooterWidget extends StatelessWidget {
  final NavigationNotifier navigationNotifier;

  const FooterWidget({super.key, required this.navigationNotifier});

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    return ListenableBuilder(
      listenable: navigationNotifier,
      builder: (context, _) {
        return BottomNavigationBar(
          currentIndex: navigationNotifier.currentIndex,
          onTap: navigationNotifier.setIndex,
          // Light mode: warm gold bar with dark icons
          // Dark mode: keep existing dark surface with gold icons
          backgroundColor: isLight ? AppColors.sand : AppColors.elevated,
          selectedItemColor: isLight ? AppColors.deepVoid : AppColors.warmGold,
          unselectedItemColor: isLight ? AppColors.deepVoid.withOpacity(0.5) : AppColors.sand,
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
