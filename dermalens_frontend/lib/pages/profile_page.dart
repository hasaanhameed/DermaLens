import 'package:flutter/material.dart';
import 'package:dermalens/pages/welcome_page.dart';
import '../theme/app_colors.dart';
import '../notifiers/theme_notifier.dart'; // <--- We import the radio station!
import 'edit_profile_page.dart';
import 'terms_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Grab Current Theme Variables!
    final theme = Theme.of(context);

    final bgColor = theme.scaffoldBackgroundColor;
    final cardColor = theme.cardColor;
    final textColor = theme.colorScheme.onSurface;
    final accentColor = theme.colorScheme.primary; // Mapped to gold in dark, black in light!


    return Scaffold(
      backgroundColor: bgColor, // <--- Dynamic Background
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
        child: Column(
          children: [
            Text(
              'Hasaan',
              style: TextStyle(
                fontFamily: 'Raleway',
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: textColor, // <--- Dynamic Text
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'hasaan@example.com',
              style: TextStyle(
                fontFamily: 'Raleway',
                fontSize: 16,
                color: textColor.withValues(alpha: 0.8), // <--- Dynamic Text
              ),
            ),

            const SizedBox(height: 24),

            // Top Stats Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardColor, // <--- Dynamic Card
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: accentColor.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    '14',
                    style: TextStyle(
                      fontFamily: 'Raleway',
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: accentColor, // Gold stays gold
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Total Scans',
                    style: TextStyle(
                      fontFamily: 'Raleway',
                      fontSize: 14,
                      color: textColor.withValues(alpha: 0.9), // <--- Dynamic Text
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            _buildSectionHeader('Preferences'),
            
            // THE MAGICAL DARK MODE SWITCH
            _buildListTile(
              context: context,
              icon: ThemeNotifier().isLightMode ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
              title: ThemeNotifier().isLightMode ? 'Light Mode' : 'Dark Mode',
              trailing: Switch(
                // True if theme is NOT light mode
                value: !ThemeNotifier().isLightMode, 
                onChanged: (val) {
                  // Pressing the button toggles the global theme instantly!
                  ThemeNotifier().toggleTheme(); 
                },
                activeColor: accentColor,
                activeTrackColor: accentColor.withValues(alpha: 0.3),
                inactiveThumbColor: textColor,
                inactiveTrackColor: cardColor,
              ),
            ),
            
            _buildListTile(
              context: context,
              icon: Icons.edit_outlined,
              title: 'Edit Profile',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const EditProfilePage()),
                );
              },
            ),

            const SizedBox(height: 24),

            _buildSectionHeader('Data & Privacy'),
            _buildListTile(
              context: context,
              icon: Icons.download_outlined,
              title: 'Export My Data',
              onTap: () {},
            ),
            _buildListTile(
              context: context,
              icon: Icons.privacy_tip_outlined,
              title: 'Privacy Policy and Terms',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TermsPage()),
                );
              },
            ),

            const SizedBox(height: 32),

            // Logout Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WelcomePage(),
                    ),
                  );
                },
                icon: Icon(Icons.logout, color: bgColor), // <--- Inverted for contrast
                label: Text(
                  'Sign Out',
                  style: TextStyle(
                    fontFamily: 'Raleway',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: bgColor, // <--- Inverted for contrast
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: textColor, // <--- Dynamic inverted
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Delete Account Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(
                  Icons.delete_forever,
                  color: AppColors.severityHigh,
                ),
                label: const Text(
                  'Delete Account',
                  style: TextStyle(
                    fontFamily: 'Raleway',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.severityHigh, // Red stays red
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(
                    color: AppColors.severityHigh,
                    width: 1,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  // Helper method now accepts Context to pull the Theme!
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, left: 4.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title.toUpperCase(),
          style: const TextStyle(
            fontFamily: 'Raleway',
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: AppColors.warmGold, // Keep Gold fixed
          ),
        ),
      ),
    );
  }

  // Helper method now accepts Context to pull the Theme dynamically for the tiles!
  Widget _buildListTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);
    final cardColor = theme.cardColor;
    final textColor = theme.colorScheme.onSurface;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: cardColor, // <--- Dynamic Card
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.warmGold.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        leading: Icon(icon, color: textColor), // <--- Dynamic Icon
        title: Text(
          title,
          style: TextStyle(
            fontFamily: 'Raleway',
            fontSize: 16,
            color: textColor, // <--- Dynamic Text
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: trailing ?? Icon(
          Icons.arrow_forward_ios,
          color: textColor, // <--- Dynamic Arrow
          size: 16,
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
