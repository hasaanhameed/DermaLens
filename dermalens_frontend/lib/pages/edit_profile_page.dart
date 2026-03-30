import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  bool _showPasswordFields = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            fontFamily: 'Raleway',
            fontSize: 20,
            color: AppColors.sand,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.surface,
        iconTheme: const IconThemeData(color: AppColors.sand),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            _buildEditField('Name', 'Hasaan', Icons.person_outline),
            const SizedBox(height: 16),
            _buildEditField(
              'Email',
              'hasaan@example.com',
              Icons.email_outlined,
            ),
            const SizedBox(height: 24),

            // Password Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.elevated,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.warmGold.withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.shield_outlined, color: AppColors.warmGold),
                      SizedBox(width: 12),
                      Text(
                        'Security',
                        style: TextStyle(
                          fontFamily: 'Raleway',
                          color: AppColors.warmGold,
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
                          side: const BorderSide(color: AppColors.warmGold),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text(
                          'Change Password',
                          style: TextStyle(
                            fontFamily: 'Raleway',
                            color: AppColors.warmGold,
                          ),
                        ),
                      ),
                    )
                  else ...[
                    _buildEditField(
                      'Current Password',
                      '********',
                      Icons.lock_outline,
                      obscureText: true,
                      fillColor: AppColors.surface,
                      borderColor: AppColors.surface,
                    ),
                    const SizedBox(height: 12),
                    _buildEditField(
                      'New Password',
                      '********',
                      Icons.lock_reset_outlined,
                      obscureText: true,
                      fillColor: AppColors.surface,
                      borderColor: AppColors.surface,
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
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            fontFamily: 'Raleway',
                            color: AppColors.sand,
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
                  backgroundColor: AppColors.warmGold,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Save Changes',
                  style: TextStyle(
                    fontFamily: 'Raleway',
                    color: AppColors.surface,
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
    bool obscureText = false,
    Color fillColor = AppColors.elevated,
    Color borderColor = AppColors.elevated,
  }) {
    return TextField(
      obscureText: obscureText,
      style: const TextStyle(fontFamily: 'Raleway', color: AppColors.blush),
      decoration: InputDecoration(
        labelText: 'Edit $label',
        hintText: placeholder,
        hintStyle: TextStyle(
          fontFamily: 'Raleway',
          color: AppColors.sand.withValues(alpha: 0.5),
        ),
        labelStyle: const TextStyle(
          fontFamily: 'Raleway',
          color: AppColors.sand,
        ),
        prefixIcon: Icon(icon, color: AppColors.sand),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.warmGold),
        ),
        filled: true,
        fillColor: fillColor,
      ),
    );
  }
}
