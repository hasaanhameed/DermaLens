import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/scan_service.dart';
import '../pages/history_details_page.dart';

class HomeNotifier extends ChangeNotifier {
  final ScanService _scanService = ScanService();
  final ImagePicker _picker = ImagePicker();

  Future<void> pickAndScan(BuildContext context, ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image == null) return;

    if (!context.mounted) return;

    _showLoading(context);

    try {
      final data = await _scanService.analyzeScan(image);
      final result = _formatResult(data, image.path);

      if (context.mounted) {
        Navigator.pop(context); 
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HistoryDetailsPage(scanData: result)),
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context); 
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Analysis failed: $e')),
        );
      }
    }
  }

  void _showLoading(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 24),
              const Text(
                'Analyzing Image...',
                style: TextStyle(fontFamily: 'Raleway', fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Map<String, String> _formatResult(Map<String, dynamic> data, String imagePath) {
    final now = DateTime.now();
    final formattedDate = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    
    return {
      "date": formattedDate,
      "condition": (data["condition"] ?? "Unknown").toString(),
      "severity": (data["severity"] ?? "Unknown").toString(),
      "imageUrl": imagePath,
      "ai_recommendation": (data["ai_recommendation"] ?? "").toString(),
    };
  }
}
