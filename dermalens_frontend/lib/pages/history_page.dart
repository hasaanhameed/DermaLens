import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../services/scan_service.dart'; // <--- New Import
import 'history_details_page.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final ScanService _scanService = ScanService();
  late Future<List<dynamic>> _historyFuture;

  @override
  void initState() {
    super.initState();
    _historyFuture = _scanService.getScanHistory();
  }

  // Pull to refresh function
  Future<void> _refreshHistory() async {
    setState(() {
      _historyFuture = _scanService.getScanHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    // 1. Grab Current Theme Variables! (Exactly as you had them)
    final theme = Theme.of(context);
    final bgColor = theme.scaffoldBackgroundColor;
    final cardColor = theme.cardColor;
    final textColor = theme.colorScheme.onSurface;
    final accentColor = theme.colorScheme.primary;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        toolbarHeight: 90,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.only(top: 26.0, bottom: 10.0),
          child: Text(
            'Diagnostic History',
            style: TextStyle(
              fontFamily: 'Raleway',
              fontSize: 28,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
        ),
        backgroundColor: bgColor,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshHistory,
        color: accentColor,
        child: FutureBuilder<List<dynamic>>(
          future: _historyFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error loading history", style: TextStyle(color: textColor)));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text(
                  "No diagnostic history found.",
                  style: TextStyle(fontFamily: 'Raleway', color: textColor.withOpacity(0.5)),
                ),
              );
            }

            final scans = snapshot.data!;

            return ListView.builder(
              itemCount: scans.length,
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              itemBuilder: (context, index) {
                final scan = scans[index];

                // Formatting the database date
                final rawDate = scan["created_at"]?.toString().split('T')[0] ?? "Unknown Date";

                // Determine color and icon based on severity (Your exact logic)
                Color severityColor = textColor;
                IconData severityIcon = Icons.info;

                if (scan["severity"] == "Low Risk") {
                  severityColor = AppColors.severityLow;
                  severityIcon = Icons.check_circle;
                } else if (scan["severity"] == "Requires Monitor" ||
                    scan["severity"] == "Medium Risk" || 
                    scan["severity"] == "Medium") {
                  severityColor = AppColors.severityMedium;
                  severityIcon = Icons.warning_rounded;
                } else if (scan["severity"].toString().contains("High")) {
                  severityColor = AppColors.severityHigh;
                  severityIcon = Icons.error_rounded;
                }

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HistoryDetailsPage(
                          scanData: {
                            "date": rawDate,
                            "condition": scan["condition"] ?? "Unknown",
                            "severity": scan["severity"] ?? "Unknown",
                            "imageUrl": scan["image_url"] ?? "",
                            "ai_recommendation": scan["ai_recommendation"] ?? "",
                          },
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16.0),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: accentColor.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        // Dynamic Image Thumbnail
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: bgColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: scan["image_url"] != null
                                ? Image.network(scan["image_url"], fit: BoxFit.cover)
                                : Icon(Icons.broken_image, color: textColor),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                scan["condition"] ?? "Unnamed",
                                style: TextStyle(
                                  fontFamily: 'Raleway',
                                  color: accentColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    rawDate,
                                    style: TextStyle(
                                      fontFamily: 'Raleway',
                                      color: textColor,
                                      fontSize: 13,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Icon(severityIcon, color: severityColor, size: 14),
                                      const SizedBox(width: 4),
                                      Text(
                                        scan["severity"] ?? "Unknown",
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
                        Icon(
                          Icons.arrow_forward_ios,
                          color: textColor.withOpacity(0.4),
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
