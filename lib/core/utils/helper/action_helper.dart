import 'package:flutter/foundation.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';


class AppActionsHelper {
  AppActionsHelper._();


  static const String _androidPackageName = 'com.yourcompany.tolet_app';


  static const String _iosAppStoreId = '0000000000';

  static String get _playStoreUrl =>
      'https://play.google.com/store/apps/details?id=$_androidPackageName';

  static String get _appStoreUrl =>
      'https://apps.apple.com/app/id$_iosAppStoreId';


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


    await openStorePage();
  }


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