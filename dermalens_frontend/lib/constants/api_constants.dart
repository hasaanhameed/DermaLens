import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class ApiConstants {
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:8000';
    } else if (Platform.isAndroid) {
      return 'http://10.0.2.2:8000'; // For Emulator
    } else {
      return 'http://127.0.0.1:8000'; // For iOS/Desktop
    }
  }
}
