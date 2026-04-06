import 'package:flutter/material.dart';
import '../notifiers/theme_notifier.dart';
import '../services/auth_service.dart'; // <--- Added this

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final AuthService _authService = AuthService();

  // 1. Added Controllers to capture what you type!
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  bool _showPasswordFields = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  // 2. Fetch the current data so the boxes aren't empty when you open the page
  Future<void> _loadInitialData() async {
    try {
      final data = await _authService.getUserProfile();
      setState(() {
        _nameController.text = data['name'] ?? '';
        _emailController.text = data['email'] ?? '';
      });
    } catch (e) {
      debugPrint("Error loading profile data: $e");
    }
  }

  // 3. The "Brain" of the Save Button
  Future<void> _saveChanges() async {
    setState(() => _isSaving = true);
    try {
      // 1. Update Name & Email
      await _authService.updateProfile(
        _nameController.text.trim(),
        _emailController.text.trim(),
      );

      // 2. If you typed a new password, save that too
      if (_showPasswordFields && _newPasswordController.text.isNotEmpty) {
        await _authService.updatePassword(_newPasswordController.text);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        // IMPROVED: This will now show the EXACT reason (e.g., "Email already exists" or "Invalid format")
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
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
            // Theme Switcher (Keeping your exactly as it was)
            Container(
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: accentColor.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 4,
                ),
                leading: Icon(
                  ThemeNotifier().isLightMode
                      ? Icons.light_mode_outlined
                      : Icons.dark_mode_outlined,
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
                  onChanged: (val) => ThemeNotifier().toggleTheme(),
                  activeColor: accentColor,
                  activeTrackColor: accentColor.withOpacity(0.3),
                  inactiveThumbColor: textColor,
                  inactiveTrackColor: cardColor,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),

            // Name Field
            _buildEditField(
              'Name',
              _nameController, // <--- Using the controller
              Icons.person_outline,
              textColor: textColor,
              cardColor: cardColor,
              accentColor: accentColor,
            ),
            const SizedBox(height: 16),

            // Email Field
            _buildEditField(
              'Email',
              _emailController, // <--- Using the controller
              Icons.email_outlined,
              textColor: textColor,
              cardColor: cardColor,
              accentColor: accentColor,
            ),
            const SizedBox(height: 24),

            // Password Section (Linked to AuthService)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: accentColor.withOpacity(0.1),
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
                        onPressed: () =>
                            setState(() => _showPasswordFields = true),
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
                      'New Password',
                      _newPasswordController, // <--- Only need new password for this flow
                      Icons.lock_reset_outlined,
                      labelPrefix: 'Enter ',
                      obscureText: true,
                      fillColor: bgColor,
                      borderColor: bgColor,
                      textColor: textColor,
                      cardColor: cardColor,
                      accentColor: accentColor,
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () =>
                            setState(() => _showPasswordFields = false),
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

            // Save Button
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _saveChanges,
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: _isSaving
                    ? CircularProgressIndicator(color: bgColor)
                    : Text(
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

  // Refactored helper to use Controllers!
  Widget _buildEditField(
    String label,
    TextEditingController controller,
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
      controller: controller, // <--- This holds the value
      obscureText: obscureText,
      style: TextStyle(fontFamily: 'Raleway', color: textColor),
      decoration: InputDecoration(
        labelText: '$labelPrefix$label',
        labelStyle: TextStyle(fontFamily: 'Raleway', color: textColor),
        prefixIcon: Icon(icon, color: textColor.withOpacity(0.8)),
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
