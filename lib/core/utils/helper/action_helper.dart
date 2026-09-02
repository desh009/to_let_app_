import 'package:flutter/foundation.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

/// Central place for app-level actions: Share App & Rate App.
/// Replace the package IDs / iOS App Store ID with your real ones.
class AppActionsHelper {
  AppActionsHelper._();

  // TODO: replace with your actual Android package name (applicationId in build.gradle)
  static const String _androidPackageName = 'com.yourcompany.tolet_app';

  // TODO: replace with your actual App Store numeric ID (only the digits)
  static const String _iosAppStoreId = '0000000000';

  static String get _playStoreUrl =>
      'https://play.google.com/store/apps/details?id=$_androidPackageName';

  static String get _appStoreUrl =>
      'https://apps.apple.com/app/id$_iosAppStoreId';

  /// Opens the phone's native share sheet with the app link.
  static Future<void> shareApp() async {
    try {
      final String link = defaultTargetPlatform == TargetPlatform.iOS
          ? _appStoreUrl
          : _playStoreUrl;

      await Share.share(
        'Check out this app for finding rentals in Dhaka!\n$link',
        subject: 'To-Let App',
      );
    } catch (e) {
      debugPrint('shareApp() failed: $e');
    }
  }

  /// Tries to show the native in-app rating popup (Android/iOS).
  /// Falls back to opening the store page directly if in-app review
  /// isn't available or throws (common on emulators without Play Store,
  /// or debug builds where the review flow isn't backed by a real store).
  static Future<void> rateApp() async {
    final InAppReview inAppReview = InAppReview.instance;

    try {
      final bool available = await inAppReview.isAvailable();
      if (available) {
        await inAppReview.requestReview();
        return;
      }
    } catch (e) {
      debugPrint('in_app_review failed, falling back to store page: $e');
    }

    // Fallback: always safe, works on emulators and debug builds too.
    await openStorePage();
  }

  /// Opens the store listing directly (used as fallback, or you can
  /// wire this to a "Rate on Play Store" text button too).
  static Future<void> openStorePage() async {
    try {
      final String url = defaultTargetPlatform == TargetPlatform.iOS
          ? _appStoreUrl
          : _playStoreUrl;
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('openStorePage() failed: $e');
    }
  }
}