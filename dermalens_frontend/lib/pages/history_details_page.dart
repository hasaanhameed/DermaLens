import 'dart:io';
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
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: (scanData["imageUrl"] != null && scanData["imageUrl"]!.isNotEmpty)
                      ? (scanData["imageUrl"]!.startsWith('http')
                          ? Image.network(
                              scanData["imageUrl"]!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Icon(
                                  Icons.broken_image,
                                  color: textColor.withValues(alpha: 0.5),
                                  size: 64),
                            )
                          : Image.file(
                              File(scanData["imageUrl"]!),
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Icon(
                                  Icons.broken_image,
                                  color: textColor.withValues(alpha: 0.5),
                                  size: 64),
                            ))
                      : Icon(Icons.broken_image,
                          color: textColor.withValues(alpha: 0.5), size: 64),
                ),
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
              scanData["ai_recommendation"] ??
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
