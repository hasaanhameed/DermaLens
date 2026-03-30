import 'package:flutter/material.dart';
import '../notifiers/navigation_notifier.dart';
import '../theme/app_colors.dart';
import '../widgets/footer_widget.dart';
import '../pages/history_page.dart';
import '../pages/home_page.dart';
import '../widgets/header_widget.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  final _navigationNotifier = NavigationNotifier();

  // 2. We create a list of pages for the bottom navigation bar.
  // The first is HomePage. The other two are temporary placeholders.
  final List<Widget> _pages = [
    const HomePage(),
    HistoryPage(),
    const Center(
      child: Text(
        "Profile Page (Coming Soon)",
        style: TextStyle(color: AppColors.sand, fontFamily: 'Raleway'),
      ),
    ),
  ];

  @override
  void dispose() {
    _navigationNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,

      // 3. The body now listens to the navigation bar.
      // If you click tab 0, it shows _pages[0] (HomePage).
      body: SafeArea(
        child: Column(
          children: [
            const HeaderWidget(),
            Expanded(
              child: ListenableBuilder(
                listenable: _navigationNotifier,
                builder: (context, _) {
                  return _pages[_navigationNotifier.currentIndex];
                },
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: FooterWidget(
        navigationNotifier: _navigationNotifier,
      ),
    );
  }
}
