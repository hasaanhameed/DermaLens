import 'package:flutter/material.dart';
import '../notifiers/navigation_notifier.dart';
import '../theme/app_colors.dart';
import '../widgets/header_widget.dart';
import '../widgets/footer_widget.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  final _navigationNotifier = NavigationNotifier();

  @override
  void dispose() {
    _navigationNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(child: const HeaderWidget()),
      bottomNavigationBar: FooterWidget(
        navigationNotifier: _navigationNotifier,
      ),
    );
  }
}
