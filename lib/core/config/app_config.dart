import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  // Environment
  static bool get isDevelopment => !kReleaseMode;
  static bool get isProduction => kReleaseMode;

  // API Configuration
  static String get apiBaseUrl => dotenv.env['API_BASE_URL'] ?? 'http://10.0.2.2:3000';
  static String get geminiApiKey => dotenv.env['GEMINI_API_KEY'] ?? '';

  // Firebase Configuration (if needed)
  static String get firebaseApiKey => dotenv.env['FIREBASE_API_KEY'] ?? '';

  // App Configuration
  static const String appName = 'To Let App';
  static const String appVersion = '1.0.0';

  // Debug settings
  static bool get enableLogging => isDevelopment;

  // Print configuration (for debugging)
  static void printConfig() {
    if (isDevelopment) {
      debugPrint('=== App Configuration ===');
      debugPrint('Environment: ${isDevelopment ? 'Development' : 'Production'}');
      debugPrint('API Base URL: $apiBaseUrl');
      debugPrint('Gemini API Key: ${geminiApiKey.isNotEmpty ? '***configured***' : '***not configured***'}');
      debugPrint('Enable Logging: $enableLogging');
      debugPrint('========================');
    }
  }
}
