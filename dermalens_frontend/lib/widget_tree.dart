import 'package:flutter/material.dart';
import '../notifiers/navigation_notifier.dart';
import '../theme/app_colors.dart';
import '../widgets/footer_widget.dart';
import '../pages/history_page.dart';
import '../pages/home_page.dart';
import '../pages/profile_page.dart';
import '../widgets/header_widget.dart';
import 'package:provider/provider.dart';
import '../notifiers/profile_notifier.dart';
import '../notifiers/history_notifier.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  final _navigationNotifier = NavigationNotifier();

  final List<Widget> _pages = [HomePage(), HistoryPage(), ProfilePage()];

  @override
  void initState() {
    super.initState();
    _navigationNotifier.addListener(_handleTabChange);
  }

  void _handleTabChange() {
    final index = _navigationNotifier.currentIndex;
    if (index == 1) {
      // Refresh History
      Provider.of<HistoryNotifier>(context, listen: false).loadHistory(context);
    } else if (index == 2) {
      // Refresh Profile
      Provider.of<ProfileNotifier>(context, listen: false).loadProfile(context);
    }
  }

  @override
  void dispose() {
    _navigationNotifier.removeListener(_handleTabChange);
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
