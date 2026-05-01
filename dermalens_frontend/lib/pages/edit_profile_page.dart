import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../notifiers/profile_notifier.dart';
import '../theme/app_colors.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = theme.scaffoldBackgroundColor;
    final cardColor = theme.cardColor;
    final textColor = theme.colorScheme.onSurface;
    final accentColor = theme.colorScheme.primary;
    final isLight = theme.brightness == Brightness.light;

    return Consumer<ProfileNotifier>(
      builder: (context, notifier, child) {
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
            backgroundColor: isLight ? AppColors.sand : bgColor,
            elevation: 0,
            iconTheme: IconThemeData(color: textColor),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('Personal Information', textColor),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: notifier.nameController,
                  label: 'Full Name',
                  icon: Icons.person_outline,
                  textColor: textColor,
                  cardColor: cardColor,
                  accentColor: accentColor,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: notifier.emailController,
                  label: 'Email Address',
                  icon: Icons.email_outlined,
                  textColor: textColor,
                  cardColor: cardColor,
                  accentColor: accentColor,
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildSectionTitle('Security', textColor),
                    Switch(
                      value: notifier.showPasswordFields,
                      onChanged: (_) => notifier.togglePasswordFields(),
                      activeColor: accentColor,
                    ),
                  ],
                ),
                if (notifier.showPasswordFields) ...[
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: notifier.newPasswordController,
                    label: 'New Password',
                    icon: Icons.lock_outline,
                    isPassword: true,
                    textColor: textColor,
                    cardColor: cardColor,
                    accentColor: accentColor,
                  ),
                ],
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: notifier.isSaving ? null : () => notifier.saveChanges(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentColor,
                      foregroundColor: isLight ? Colors.white : AppColors.deepVoid,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: notifier.isSaving
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Save Changes',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Raleway',
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title, Color textColor) {
    return Text(
      title,
      style: TextStyle(
        fontFamily: 'Raleway',
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    required Color textColor,
    required Color cardColor,
    required Color accentColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Raleway',
            fontSize: 14,
            color: textColor.withOpacity(0.6),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: textColor.withOpacity(0.1)),
          ),
          child: TextField(
            controller: controller,
            obscureText: isPassword,
            style: TextStyle(fontFamily: 'Raleway', color: textColor),
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: accentColor),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ),
      ],
    );
  }
}
