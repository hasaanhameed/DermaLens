import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_colors.dart';
import '../notifiers/history_notifier.dart';
import 'history_details_page.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = theme.scaffoldBackgroundColor;
    final textColor = theme.colorScheme.onSurface;
    final accentColor = theme.colorScheme.primary;
    final isLight = theme.brightness == Brightness.light;

    return Consumer<HistoryNotifier>(
      builder: (context, notifier, child) {
        // Trigger load if empty AND NOT already loading
        if (notifier.scans.isEmpty && !notifier.isLoading) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            notifier.loadHistory(context);
          });
        }

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
                  color: isLight ? AppColors.deepVoid : textColor,
                ),
              ),
            ),
            backgroundColor: isLight ? AppColors.sand : bgColor,
            elevation: 0,
          ),
          body: RefreshIndicator(
            onRefresh: () => notifier.refreshHistory(context),
            color: accentColor,
            child: notifier.isLoading && notifier.scans.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : notifier.scans.isEmpty
                    ? _buildEmptyState(textColor)
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        itemCount: notifier.scans.length,
                        itemBuilder: (context, index) {
                          final scan = notifier.scans[index];
                          return _buildHistoryCard(context, scan, textColor, isLight);
                        },
                      ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(Color textColor) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history_outlined, size: 64, color: textColor.withOpacity(0.2)),
          const SizedBox(height: 16),
          Text(
            'No diagnostic history found.',
            style: TextStyle(
              fontFamily: 'Raleway',
              fontSize: 18,
              color: textColor.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryCard(BuildContext context, dynamic scan, Color textColor, bool isLight) {
    final dateStr = scan['created_at'] != null 
        ? scan['created_at'].toString().split('T')[0] 
        : 'Unknown Date';
    
    final prob = scan['probability'] ?? 0.0;
    final probText = (prob * 100).toStringAsFixed(1);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HistoryDetailsPage(scanData: Map<String, dynamic>.from(scan)),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isLight ? AppColors.sand : AppColors.elevated,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: scan['image_url'] != null
                  ? Image.network(
                      scan['image_url'],
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey.withOpacity(0.2),
                      child: const Icon(Icons.image_not_supported),
                    ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    scan['condition'] ?? 'Unknown Condition',
                    style: TextStyle(
                      fontFamily: 'Raleway',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isLight ? AppColors.deepVoid : textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Probability: $probText%',
                    style: TextStyle(
                      fontFamily: 'Raleway',
                      fontSize: 14,
                      color: isLight ? AppColors.deepVoid.withOpacity(0.7) : textColor.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    dateStr,
                    style: TextStyle(
                      fontFamily: 'Raleway',
                      fontSize: 12,
                      color: isLight ? AppColors.deepVoid.withOpacity(0.5) : textColor.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: isLight ? AppColors.deepVoid.withOpacity(0.3) : textColor.withOpacity(0.3),
            ),
          ],
        ),
      ),
    );
  }
}
