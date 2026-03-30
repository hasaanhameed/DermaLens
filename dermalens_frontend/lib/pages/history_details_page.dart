import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class HistoryDetailsPage extends StatelessWidget {
  final Map<String, String> scanData;

  const HistoryDetailsPage({super.key, required this.scanData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text(
          'Analysis Results',
          style: TextStyle(
            fontFamily: 'Raleway',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.sand,
          ),
        ),
        backgroundColor: AppColors.surface,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.sand), // Makes back button sand colored
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // The Image
            Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  image: NetworkImage(scanData["imageUrl"]!),
                  fit: BoxFit.cover,
                ),
                border: Border.all(color: AppColors.warmGold, width: 0.5),
              ),
            ),
            const SizedBox(height: 32),
            
            // The Analysis Data
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.elevated,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    scanData["date"]!.toUpperCase(),
                    style: TextStyle(
                      fontFamily: 'Raleway',
                      color: AppColors.sand.withOpacity(0.7),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    scanData["condition"]!,
                    style: const TextStyle(
                      fontFamily: 'Raleway',
                      color: AppColors.warmGold,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.info_outline, color: AppColors.sand, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Severity: ${scanData["severity"]}',
                        style: const TextStyle(
                          fontFamily: 'Raleway',
                          color: AppColors.sand,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                                    const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.analytics_outlined, color: AppColors.warmGold, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'AI Prediction Confidence: ',
                        style: const TextStyle(
                          fontFamily: 'Raleway',
                          color: AppColors.sand,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        scanData["Model Prediction Accuracy"] ?? "N/A",
                        style: const TextStyle(
                          fontFamily: 'Raleway',
                          color: AppColors.severityLow,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // AI Recommendation text
            const Text(
              'AI Recommendation',
              style: TextStyle(
                fontFamily: 'Raleway',
                color: AppColors.sand,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'No significant irregularities detected by the deep learning model. Continue to monitor the area for any changes in color or borders over the next 30 days.',
              style: TextStyle(
                fontFamily: 'Raleway',
                color: AppColors.sand,
                fontSize: 15,
                height: 1.5,
              ),
            ),
          ],
        ),
        


      ),
    );
  }
}

