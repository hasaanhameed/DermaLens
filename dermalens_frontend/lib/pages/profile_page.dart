import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../notifiers/profile_notifier.dart';
import '../theme/app_colors.dart';
import '../notifiers/theme_notifier.dart';
import 'edit_profile_page.dart';
import 'terms_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = theme.scaffoldBackgroundColor;
    final cardColor = theme.cardColor;
    final textColor = theme.colorScheme.onSurface;
    final accentColor = theme.colorScheme.primary;

    return Consumer<ProfileNotifier>(
      builder: (context, notifier, child) {
        // Initial load logic
        if (notifier.userData == null && notifier.isLoading) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
             notifier.loadProfile(context);
          });
        }

        if (notifier.isLoading) {
          return Scaffold(
            backgroundColor: bgColor,
            body: Center(child: CircularProgressIndicator(color: accentColor)),
          );
        }

        final user = notifier.userData;

        return Scaffold(
          backgroundColor: bgColor,
          body: SingleChildScrollView(
            child: Column(
              children: [
                _buildHeader(context, user, accentColor, textColor),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      _buildStatSection(notifier.scanCount, accentColor, cardColor, textColor),
                      const SizedBox(height: 32),
                      _buildMenuSection(context, notifier, cardColor, textColor, accentColor),
                      const SizedBox(height: 40),
                      Text(
                        'DermaLens v1.0.0',
                        style: TextStyle(
                          fontFamily: 'Raleway',
                          color: textColor.withOpacity(0.5),
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, Map<String, dynamic>? user, Color accentColor, Color textColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 60, bottom: 40, left: 24, right: 24),
      decoration: BoxDecoration(
        color: accentColor.withOpacity(0.1),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: accentColor,
            child: Text(
              (user?['name'] ?? 'U')[0].toUpperCase(),
              style: const TextStyle(fontSize: 40, color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            user?['name'] ?? 'User Name',
            style: TextStyle(fontFamily: 'Raleway', fontSize: 24, fontWeight: FontWeight.bold, color: textColor),
          ),
          Text(
            user?['email'] ?? 'email@example.com',
            style: TextStyle(fontFamily: 'Raleway', fontSize: 16, color: textColor.withOpacity(0.7)),
          ),
        ],
      ),
    );
  }

  Widget _buildStatSection(int scanCount, Color accentColor, Color cardColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('Total Scans', scanCount.toString(), accentColor, textColor),
          Container(width: 1, height: 40, color: textColor.withOpacity(0.1)),
          _buildStatItem('Health Score', 'Good', Colors.green, textColor),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color valueColor, Color textColor) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontFamily: 'Raleway', fontSize: 22, fontWeight: FontWeight.bold, color: valueColor)),
        Text(label, style: TextStyle(fontFamily: 'Raleway', fontSize: 12, color: textColor.withOpacity(0.5))),
      ],
    );
  }

  Widget _buildMenuSection(BuildContext context, ProfileNotifier notifier, Color cardColor, Color textColor, Color accentColor) {
    return Column(
      children: [
        _buildMenuItem(
          icon: Icons.person_outline,
          title: 'Edit Profile',
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const EditProfilePage())),
          cardColor: cardColor,
          textColor: textColor,
        ),
        _buildMenuItem(
          icon: Icons.description_outlined,
          title: 'Terms & Conditions',
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const TermsPage())),
          cardColor: cardColor,
          textColor: textColor,
        ),
        _buildThemeToggle(context, cardColor, textColor, accentColor),
        const SizedBox(height: 16),
        _buildMenuItem(
          icon: Icons.logout,
          title: 'Sign Out',
          onTap: () => notifier.signOut(context),
          isDestructive: true,
          cardColor: cardColor,
          textColor: textColor,
        ),
        _buildMenuItem(
          icon: Icons.delete_forever_outlined,
          title: 'Delete Account',
          onTap: () => notifier.deleteAccount(context),
          isDestructive: true,
          cardColor: cardColor,
          textColor: textColor,
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
    required Color cardColor,
    required Color textColor,
  }) {
    final color = isDestructive ? Colors.redAccent : textColor;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: color),
        title: Text(title, style: TextStyle(fontFamily: 'Raleway', fontWeight: FontWeight.w600, color: color)),
        trailing: Icon(Icons.chevron_right, color: color.withOpacity(0.3)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        tileColor: cardColor,
      ),
    );
  }

  Widget _buildThemeToggle(BuildContext context, Color cardColor, Color textColor, Color accentColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(16)),
      child: ListenableBuilder(
        listenable: ThemeNotifier(),
        builder: (context, child) {
          final isLight = ThemeNotifier().isLightMode;
          return ListTile(
            leading: Icon(isLight ? Icons.light_mode : Icons.dark_mode, color: accentColor),
            title: const Text('Theme Mode', style: TextStyle(fontFamily: 'Raleway', fontWeight: FontWeight.w600)),
            subtitle: Text(isLight ? 'Light Mode' : 'Dark Mode', style: const TextStyle(fontSize: 12)),
            trailing: Switch(
              value: isLight,
              onChanged: (val) => ThemeNotifier().toggleTheme(),
              activeColor: AppColors.warmGold,
            ),
          );
        },
      ),
    );
  }
}
