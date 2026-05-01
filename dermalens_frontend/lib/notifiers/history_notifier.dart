import 'package:flutter/material.dart';
import '../services/scan_service.dart';

class HistoryNotifier extends ChangeNotifier {
  final ScanService _scanService = ScanService();
  
  List<dynamic> scans = [];
  bool isLoading = true;

  Future<void> loadHistory(BuildContext context) async {
    isLoading = true;
    notifyListeners();

    try {
      final results = await _scanService.getScanHistory();
      
      // Pre-cache images for smooth scrolling
      if (context.mounted && results.isNotEmpty) {
        await Future.wait(results.map((scan) {
          if (scan["image_url"] != null) {
            return precacheImage(NetworkImage(scan["image_url"]), context);
          }
          return Future.value();
        }));
      }

      scans = results;
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load history: $e')),
        );
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshHistory(BuildContext context) async {
    await loadHistory(context);
  }
}
