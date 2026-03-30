import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

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
            _buildEditField('Email', 'hasaan@example.com', Icons.email_outlined),
            const SizedBox(height: 16),
            _buildEditField('Password', '********', Icons.lock_outline, obscureText: true),
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
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
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
            )
          ],
        ),
      ),
    );
  }

  Widget _buildEditField(String label, String placeholder, IconData icon, {bool obscureText = false}) {
    return TextField(
      obscureText: obscureText,
      style: const TextStyle(fontFamily: 'Raleway', color: AppColors.blush),
      decoration: InputDecoration(
        labelText: 'Edit $label',
        hintText: placeholder,
        hintStyle: TextStyle(fontFamily: 'Raleway', color: AppColors.sand.withValues(alpha: 0.5)),
        labelStyle: const TextStyle(fontFamily: 'Raleway', color: AppColors.sand),
        prefixIcon: Icon(icon, color: AppColors.sand),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.elevated),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.warmGold),
        ),
        filled: true,
        fillColor: AppColors.elevated,
      ),
    );
  }
}
