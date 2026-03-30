import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'history_details_page.dart';

class HistoryPage extends StatelessWidget {
  HistoryPage({super.key});

  final List<Map<String, String>> hardcodedScans = [
    {
      "date": "Oct 24, 2026",
      "condition": "Discoloured Spots",
      "severity": "Low Risk",
      "Model Prediction Accuracy": "95%",
      "imageUrl": "https://via.placeholder.com/150",
      "top1": "Discoloured Spots (95%)",
      "top2": "Benign Nevus (3.5%)",
      "top3": "Skin Cancer (1.5%)",
    },
    {
      "date": "Oct 10, 2026",
      "condition": "Rash",
      "severity": "Medium",
      "Model Prediction Accuracy": "89%",
      "imageUrl": "https://via.placeholder.com/150",
      "top1": "Contact Dermatitis / Rash (89%)",
      "top2": "Eczema (8%)",
      "top3": "Fungal Infection (3%)",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        toolbarHeight: 90,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Padding(
          padding: EdgeInsets.only(top: 26.0, bottom: 10.0),
          child: Text(
            'Diagnostic History',
            style: TextStyle(
              fontFamily: 'Raleway',
              fontSize: 28,
              fontWeight: FontWeight.w500,
              color: AppColors.sand,
            ),
          ),
        ),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),

      body: ListView.builder(
        itemCount: hardcodedScans.length,
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        itemBuilder: (context, index) {
          final scan = hardcodedScans[index];

          // Determine color and icon based on severity

          Color severityColor = AppColors.sand;
          IconData severityIcon = Icons.info;

          if (scan["severity"] == "Low Risk") {
            severityColor = AppColors.severityLow;
            severityIcon = Icons.check_circle;
          } else if (scan["severity"] == "Requires Monitor" ||
              scan["severity"] == "Medium") {
            severityColor = AppColors.severityMedium;
            severityIcon = Icons.warning_rounded;
          } else if (scan["severity"]!.contains("High")) {
            severityColor = AppColors.severityHigh;
            severityIcon = Icons.error_rounded;
          }

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HistoryDetailsPage(scanData: scan),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 16.0),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.elevated,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.warmGold.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.broken_image,
                      color: AppColors.sand,
                    ),
                  ),

                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          scan["condition"]!,
                          style: const TextStyle(
                            fontFamily: 'Raleway',
                            color: AppColors.warmGold,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              scan["date"]!,
                              style: const TextStyle(
                                fontFamily: 'Raleway',
                                color: AppColors.sand,
                                fontSize: 13,
                              ),
                            ),
                            Row(
                              children: [
                                Icon(
                                  severityIcon,
                                  color: severityColor,
                                  size: 14,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  scan["severity"]!,
                                  style: TextStyle(
                                    fontFamily: 'Raleway',
                                    color: severityColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: AppColors.sand,
                    size: 16,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
