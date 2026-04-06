import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dermalens/pages/welcome_page.dart';
import '../theme/app_colors.dart';
import '../notifiers/theme_notifier.dart';
import '../services/auth_service.dart';
import 'edit_profile_page.dart';
import 'terms_page.dart';
import '../services/scan_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthService _authService = AuthService();
  final ScanService _scanService = ScanService(); // <--- Paste here
  Map<String, dynamic>? _userData;
  int _scanCount = 0; // <--- Paste here
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  // REPLACE your old _loadProfile() with this one:
  Future<void> _loadProfile() async {
    try {
      final results = await Future.wait([
        _authService.getUserProfile(),
        _scanService.getScanHistory(),
      ]);

      setState(() {
        _userData = results[0] as Map<String, dynamic>;
        _scanCount = (results[1] as List).length;
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to load profile: $e')));
      }
    }
  }

  Future<void> _handleSignOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const WelcomePage()),
        (route) => false,
      );
    }
  }

  Future<void> _handleDeleteAccount() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account?'),
        content: const Text('This action is permanent and cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _authService.deleteAccount();
        await _handleSignOut();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error deleting account: $e')));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = theme.scaffoldBackgroundColor;
    final cardColor = theme.cardColor;
    final textColor = theme.colorScheme.onSurface;
    final accentColor = theme.colorScheme.primary;

    if (_isLoading) {
      return Scaffold(
        backgroundColor: bgColor,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: bgColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
        child: Column(
          children: [
            Text(
              _userData?['name'] ?? 'User',
              style: TextStyle(
                fontFamily: 'Raleway',
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _userData?['email'] ?? 'No email found',
              style: TextStyle(
                fontFamily: 'Raleway',
                fontSize: 16,
                color: textColor.withOpacity(0.8),
              ),
            ),

            const SizedBox(height: 24),

            // Top Stats Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: accentColor.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    '$_scanCount', // <--- Displays the real count
                    style: TextStyle(
                      fontFamily: 'Raleway',
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: accentColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Total Scans', // <--- Changed from 'Active Account'
                    style: TextStyle(
                      fontFamily: 'Raleway',
                      fontSize: 14,
                      color: textColor.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            _buildSectionHeader('Preferences'),

            _buildListTile(
              context: context,
              icon: ThemeNotifier().isLightMode
                  ? Icons.light_mode_outlined
                  : Icons.dark_mode_outlined,
              title: ThemeNotifier().isLightMode ? 'Light Mode' : 'Dark Mode',
              trailing: Switch(
                value: !ThemeNotifier().isLightMode,
                onChanged: (val) => ThemeNotifier().toggleTheme(),
                activeColor: accentColor,
                activeTrackColor: accentColor.withOpacity(0.3),
                inactiveThumbColor: textColor,
                inactiveTrackColor: cardColor,
              ),
            ),

            _buildListTile(
              context: context,
              icon: Icons.edit_outlined,
              title: 'Edit Profile',
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const EditProfilePage()),
                );
                _loadProfile(); // Refresh when coming back
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
                onPressed: _handleSignOut,
                icon: Icon(Icons.logout, color: bgColor),
                label: Text(
                  'Sign Out',
                  style: TextStyle(
                    fontFamily: 'Raleway',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: bgColor,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: textColor,
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
                onPressed: _handleDeleteAccount,
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
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.warmGold.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        leading: Icon(icon, color: textColor),
        title: Text(
          title,
          style: TextStyle(
            fontFamily: 'Raleway',
            fontSize: 16,
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing:
            trailing ??
            Icon(Icons.arrow_forward_ios, color: textColor, size: 16),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
