import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widget_tree.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
        child: Column(
          children: [
            const Text(
              'Hasaan',
              style: TextStyle(
                fontFamily: 'Raleway',
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.sand,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'hasaan@example.com',
              style: TextStyle(
                fontFamily: 'Raleway',
                fontSize: 16,
                color: AppColors.sand,
              ),
            ),

            const SizedBox(height: 24),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.elevated,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.warmGold.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: const Column(
                children: [
                  Text(
                    '14',
                    style: TextStyle(
                      fontFamily: 'Raleway',
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.warmGold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Total Scans',
                    style: TextStyle(
                      fontFamily: 'Raleway',
                      fontSize: 14,
                      color: AppColors.sand,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            _buildSectionHeader('Preferences'),
            _buildListTile(
              icon: Icons.dark_mode_outlined,
              title: 'Dark Mode',
              trailing: Switch(
                value: true,
                onChanged: (val) {},
                activeColor: AppColors.warmGold,
                activeTrackColor: AppColors.warmGold.withValues(alpha: 0.3),
                inactiveThumbColor: AppColors.sand,
                inactiveTrackColor: AppColors.surface,
              ),
            ),
            _buildListTile(
              icon: Icons.edit_outlined,
              title: 'Edit Profile',
              onTap: () {},
            ),

            const SizedBox(height: 24),

            _buildSectionHeader('Data & Privacy'),
            _buildListTile(
              icon: Icons.download_outlined,
              title: 'Export My Data',
              onTap: () {},
            ),
            _buildListTile(
              icon: Icons.privacy_tip_outlined,
              title: 'Privacy Policy and Terms',
              onTap: () {},
            ),

            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Navigate back to home page (Tab 0 resets)
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const WidgetTree()),
                    (route) => false,
                  );
                },
                icon: const Icon(Icons.logout, color: AppColors.surface),
                label: const Text(
                  'Sign Out',
                  style: TextStyle(
                    fontFamily: 'Raleway',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.surface,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.sand,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
              ),
            ),
            const SizedBox(height: 16),
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
                    color: AppColors.severityHigh,
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
            color: AppColors.warmGold,
          ),
        ),
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.elevated,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.warmGold.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        leading: Icon(icon, color: AppColors.sand),
        title: Text(
          title,
          style: const TextStyle(
            fontFamily: 'Raleway',
            fontSize: 16,
            color: AppColors.sand,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing:
            trailing ??
            const Icon(
              Icons.arrow_forward_ios,
              color: AppColors.sand,
              size: 16,
            ),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
