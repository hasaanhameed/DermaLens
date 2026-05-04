import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/profile_service.dart';
import '../services/scan_service.dart';
import '../pages/welcome_page.dart';
import '../services/pdf_service.dart';

class ProfileNotifier extends ChangeNotifier {
  final ProfileService _profileService = ProfileService();
  final ScanService _scanService = ScanService();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();

  Map<String, dynamic>? userData;
  int scanCount = 0;
  bool isLoading = false;
  bool isSaving = false;
  bool showPasswordFields = false;

  void togglePasswordFields() {
    showPasswordFields = !showPasswordFields;
    notifyListeners();
  }

  Future<void> loadProfile(BuildContext context) async {
    try {
      final results = await Future.wait([
        _profileService.getUserProfile(),
        _scanService.getScanHistory(),
      ]);

      userData = results[0] as Map<String, dynamic>;
      scanCount = (results[1] as List).length;
      
      // Populate controllers for editing
      nameController.text = userData?['name'] ?? '';
      emailController.text = userData?['email'] ?? '';
      
      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      notifyListeners();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load profile: $e')),
        );
      }
    }
  }

  Future<void> saveChanges(BuildContext context) async {
    isSaving = true;
    notifyListeners();
    
    try {
      // 1. Update Name & Email
      await _profileService.updateProfile(
        nameController.text.trim(),
        emailController.text.trim(),
      );

      // 2. Update Password if field is shown
      if (showPasswordFields && newPasswordController.text.isNotEmpty) {
        await _profileService.updatePassword(newPasswordController.text);
      }

      // Refresh local data
      await loadProfile(context);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }

  Future<void> signOut(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const WelcomePage()),
        (route) => false,
      );
    }
  }

  Future<void> deleteAccount(BuildContext context) async {
    final confirm = await _showDeleteConfirmation(context);
    if (confirm == true) {
      try {
        await _profileService.deleteAccount();
        if (context.mounted) await signOut(context);
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error deleting account: $e')),
          );
        }
      }
    }
  }

  Future<void> exportReport(BuildContext context) async {
    try {
      final pdfService = PdfService();
      await pdfService.exportScanHistory();
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error exporting report: $e')),
        );
      }
    }
  }

  Future<bool?> _showDeleteConfirmation(BuildContext context) {
    return showDialog<bool>(
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
  }
}
