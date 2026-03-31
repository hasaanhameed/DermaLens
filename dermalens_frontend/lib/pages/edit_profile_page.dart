import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../notifiers/theme_notifier.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  bool _showPasswordFields = false;

  @override
  Widget build(BuildContext context) {
    // 1. Grab Current Theme Variables!
    final theme = Theme.of(context);
    final bgColor = theme.scaffoldBackgroundColor;
    final cardColor = theme.cardColor;
    final textColor = theme.colorScheme.onSurface;
    final accentColor = theme.colorScheme.primary;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          'Edit Profile',
          style: TextStyle(
            fontFamily: 'Raleway',
            fontSize: 20,
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: bgColor,
        iconTheme: IconThemeData(color: textColor),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Theme Switcher for Edit Page too
            Container(
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: accentColor.withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                leading: Icon(
                  ThemeNotifier().isLightMode ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                  color: textColor,
                ),
                title: Text(
                  ThemeNotifier().isLightMode ? 'Light Mode' : 'Dark Mode',
                  style: TextStyle(
                    fontFamily: 'Raleway',
                    fontSize: 16,
                    color: textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: Switch(
                  value: !ThemeNotifier().isLightMode,
                  onChanged: (val) {
                    ThemeNotifier().toggleTheme();
                  },
                  activeColor: accentColor,
                  activeTrackColor: accentColor.withValues(alpha: 0.3),
                  inactiveThumbColor: textColor,
                  inactiveTrackColor: cardColor,
                ),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),

            _buildEditField(
              'Name', 'Hasaan', Icons.person_outline, 
              textColor: textColor, cardColor: cardColor, accentColor: accentColor,
            ),
            const SizedBox(height: 16),
            _buildEditField(
              'Email', 'hasaan@example.com', Icons.email_outlined,
              textColor: textColor, cardColor: cardColor, accentColor: accentColor,
            ),
            const SizedBox(height: 24),

            // Password Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: accentColor.withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.shield_outlined, color: accentColor),
                      const SizedBox(width: 12),
                      Text(
                        'Security',
                        style: TextStyle(
                          fontFamily: 'Raleway',
                          color: accentColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  if (!_showPasswordFields)
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            _showPasswordFields = true;
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: accentColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: Text(
                          'Change Password',
                          style: TextStyle(
                            fontFamily: 'Raleway',
                            color: accentColor,
                          ),
                        ),
                      ),
                    )
                  else ...[
                    _buildEditField(
                      'Current Password',
                      '********',
                      Icons.lock_outline,
                      labelPrefix: 'Enter ', // Fixing specific text
                      obscureText: true,
                      fillColor: bgColor,
                      borderColor: bgColor,
                      textColor: textColor, cardColor: cardColor, accentColor: accentColor,
                    ),
                    const SizedBox(height: 12),
                    _buildEditField(
                      'New Password',
                      '********',
                      Icons.lock_reset_outlined,
                      labelPrefix: 'Enter ', // Fixing specific text
                      obscureText: true,
                      fillColor: bgColor,
                      borderColor: bgColor,
                      textColor: textColor, cardColor: cardColor, accentColor: accentColor,
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            _showPasswordFields = false;
                          });
                        },
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            fontFamily: 'Raleway',
                            color: textColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  'Save Changes',
                  style: TextStyle(
                    fontFamily: 'Raleway',
                    color: bgColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditField(
    String label,
    String placeholder,
    IconData icon, {
    String labelPrefix = 'Edit ',
    bool obscureText = false,
    Color? fillColor,
    Color? borderColor,
    required Color textColor,
    required Color cardColor,
    required Color accentColor,
  }) {
    return TextField(
      obscureText: obscureText,
      style: TextStyle(fontFamily: 'Raleway', color: textColor),
      decoration: InputDecoration(
        labelText: '$labelPrefix$label',
        hintText: placeholder,
        hintStyle: TextStyle(
          fontFamily: 'Raleway',
          color: textColor.withValues(alpha: 0.5),
        ),
        labelStyle: TextStyle(
          fontFamily: 'Raleway',
          color: textColor,
        ),
        prefixIcon: Icon(icon, color: textColor.withValues(alpha: 0.8)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderColor ?? cardColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: accentColor),
        ),
        filled: true,
        fillColor: fillColor ?? cardColor,
      ),
    );
  }
}
