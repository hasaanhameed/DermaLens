import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_colors.dart';
import '../notifiers/home_notifier.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _userName = "...";

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('user_name') ?? "Guest";
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = theme.scaffoldBackgroundColor;
    final textColor = theme.colorScheme.onSurface;
    final accentColor = theme.colorScheme.primary;

    // 1. Grab our Notifier
    final homeNotifier = Provider.of<HomeNotifier>(context, listen: false);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. GREETING & PROFILE SECTION
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    'Welcome, $_userName!',
                    style: TextStyle(
                      fontFamily: 'Raleway',
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Ready to start your skincare journey?',
                    style: TextStyle(
                      fontFamily: 'Raleway',
                      fontSize: 17,
                      color: textColor,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 36),
              const SizedBox(height: 16),
              const SizedBox(height: 16),

              Row(
                children: [
                  // --- BUTTON 1: CAMERA ---
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => homeNotifier.pickAndScan(context, ImageSource.camera),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentColor.withOpacity(0.1),
                        padding: const EdgeInsets.symmetric(
                          vertical: 24,
                          horizontal: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 0,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.camera_alt_outlined, color: accentColor, size: 48),
                          const SizedBox(height: 12),
                          Text(
                            'Take Photo',
                            style: TextStyle(
                              fontFamily: 'Raleway',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: accentColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  // --- BUTTON 2: GALLERY ---
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => homeNotifier.pickAndScan(context, ImageSource.gallery),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentColor.withOpacity(0.1),
                        padding: const EdgeInsets.symmetric(
                          vertical: 24,
                          horizontal: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 0,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.photo_library_outlined, color: accentColor, size: 48),
                          const SizedBox(height: 12),
                          Text(
                            'Upload',
                            style: TextStyle(
                              fontFamily: 'Raleway',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: accentColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // INSTRUCTIONS BOX
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: bgColor.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: textColor.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'How to use DermaLens:',
                      style: TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: accentColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '1. Tap the Scan Image button above.\n'
                      '2. Take or upload a clear, well-lit photo of the affected area.\n'
                      '3. Wait while DermaLens identifies the condition.\n'
                      '4. Review your personalized results and severity.\n'
                      '5. Use the Dive Deep with AI feature to ask any questions.',
                      style: TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 14,
                        height: 1.6,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
