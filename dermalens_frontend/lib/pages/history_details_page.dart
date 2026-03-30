import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class HistoryDetailsPage extends StatelessWidget {
  final Map<String, String> scanData;

  const HistoryDetailsPage({super.key, required this.scanData});

  @override
  Widget build(BuildContext context) {
    // 1. Grab Current Theme Variables!
    final theme = Theme.of(context);
        

    final bgColor = theme.scaffoldBackgroundColor;
    final cardColor = theme.cardColor;
    final textColor = theme.colorScheme.onSurface;
        final accentColor = theme.colorScheme.primary; // Mapped to gold in dark, black in light!
        final highlightColor = theme.brightness == Brightness.light ? AppColors.sand : cardColor;
        final popupBgColor = theme.brightness == Brightness.light ? AppColors.cream : cardColor;


    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          'Analysis Results',
          style: TextStyle(
            fontFamily: 'Raleway',
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: textColor, // <--- Dynamic text
          ),
        ),
        backgroundColor: bgColor, // <--- Dynamic bg
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: textColor), // <--- Dynamic back arrow color
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Image Preview Box
            Center(
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  color: cardColor, // <--- Dynamic inner box
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: accentColor.withValues(alpha: 0.5), width: 1),
                ),
                child: Icon(Icons.broken_image, color: textColor.withValues(alpha: 0.5), size: 64),
              ),
            ),
            
            const SizedBox(height: 32),

            // 2. The Analysis Data
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: cardColor, // <--- Dynamic Card
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: textColor.withValues(alpha: 0.1), width: 1), 
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Diagnosis',
                        style: TextStyle(
                          fontFamily: 'Raleway',
                          color: accentColor, // Gold fixed
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        scanData["date"]!.toUpperCase(),
                        style: TextStyle(
                          fontFamily: 'Raleway',
                          color: textColor.withValues(alpha: 0.7), // <--- Dynamic
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    scanData["condition"]!,
                    style: TextStyle(
                      fontFamily: 'Raleway',
                      color: textColor, // <--- Dynamic
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Severity Row
                  Row(
                    children: [
                      Icon(Icons.shield_outlined, color: accentColor, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Severity: ',
                        style: TextStyle(
                          fontFamily: 'Raleway',
                          color: textColor, // <--- Dynamic
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        scanData["severity"]!,
                        style: TextStyle(
                          fontFamily: 'Raleway',
                          color: accentColor, // Keep Gold fixed
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Model Prediction row
                  Row(
                    children: [
                      Icon(Icons.analytics_outlined, color: accentColor, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'AI Prediction Confidence: ',
                        style: TextStyle(
                          fontFamily: 'Raleway',
                          color: textColor, // <--- Dynamic
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        scanData["Model Prediction Accuracy"] ?? "N/A",
                        style: const TextStyle(
                          fontFamily: 'Raleway',
                          color: AppColors.severityLow, // Keep Green fixed
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),
                  
                  // Interactive Breakdown Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: highlightColor, // <--- Highlighted button background
                        side: BorderSide(color: accentColor.withValues(alpha: 0.5)),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      icon: Icon(Icons.bar_chart, color: accentColor),
                      label: Text(
                        'Deep Learning Breakdown',
                        style: TextStyle(
                          fontFamily: 'Raleway', 
                          color: accentColor, 
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      onPressed: () {
                        // This opens the pop-up window
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              backgroundColor: popupBgColor, // <--- Cream Dialog background in light mode
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(color: accentColor.withValues(alpha: 0.5)),
                              ),
                              title: Text(
                                'Softmax Probabilities',
                                style: TextStyle(fontFamily: 'Raleway', color: accentColor, fontWeight: FontWeight.bold),
                              ),
                              content: Column(
                                mainAxisSize: MainAxisSize.min, // Hugs to the content
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Top 3 Model Activations:',
                                    style: TextStyle(fontFamily: 'Raleway', color: textColor, fontSize: 13), // <--- Dynamic
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    '1. ${scanData["top1"] ?? "Unknown"}', 
                                    style: const TextStyle(fontFamily: 'Raleway', color: AppColors.severityLow, fontSize: 16, fontWeight: FontWeight.bold)
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    '2. ${scanData["top2"] ?? "Unknown"}', 
                                    style: TextStyle(fontFamily: 'Raleway', color: textColor.withValues(alpha: 0.8), fontSize: 15) // <--- Dynamic
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    '3. ${scanData["top3"] ?? "Unknown"}', 
                                    style: TextStyle(fontFamily: 'Raleway', color: textColor.withValues(alpha: 0.5), fontSize: 15) // <--- Dynamic
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text('Close', style: TextStyle(color: textColor, fontFamily: 'Raleway')), // <--- Dynamic
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // AI Recommendation text
            Text(
              'Diagnosis and Recommendations:',
              style: TextStyle(
                fontFamily: 'Raleway',
                color: textColor, // <--- Dynamic
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'No significant issues detected. Continue to monitor the area for any changes in color and consult a doctor in case of pain or unease.',
              style: TextStyle(
                fontFamily: 'Raleway',
                color: textColor.withValues(alpha: 0.8), // <--- Dynamic
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
