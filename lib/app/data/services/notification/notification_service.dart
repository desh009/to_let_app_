import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import '../../../../core/services/fcm_service.dart';

class NotificationApiService {
  // আপনার Vercel এ deploy করা backend API base URL
  static const String _baseUrl = 'https://fcm-notification-api-ten.vercel.app';

  /// Trigger notification when a new property listing is posted
  static Future<void> notifyNewListing({
    required String listingTitle,
    required String listingId,
  }) async {
    try {
      log(
        'Sending new listing notification for: $listingTitle (ID: $listingId)',
      );

      // ১. Backend API কল করুন — এটা সব ইউজারের ডিভাইসে push notification পাঠাবে
      final response = await http.post(
        Uri.parse('$_baseUrl/api/sendNotification'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'title': 'New Property Listed! 🏠',
          'body': 'Check out "$listingTitle" now on To-Let!',
          'topic': 'all_users', // ⚠️ backend যদি topic-based হয়
          'data': {'listingId': listingId, 'type': 'new_listing'},
        }),
      );

      if (response.statusCode == 200) {
        log('✅ Notification API call successful: ${response.body}');
      } else {
        log(
          '❌ Notification API failed: ${response.statusCode} - ${response.body}',
        );
      }

      // ২. (Optional) নিজের ডিভাইসেও সাথে সাথে local notification দেখাতে চাইলে
      if (Get.isRegistered<FcmService>()) {
        final flutterLocalNotifications = FlutterLocalNotificationsPlugin();
        const androidDetails = AndroidNotificationDetails(
          'high_importance_channel',
          'High Importance Notifications',
          channelDescription:
              'This channel is used for important notifications.',
          importance: Importance.max,
          priority: Priority.high,
        );
        const notificationDetails = NotificationDetails(
          android: androidDetails,
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        );

        await flutterLocalNotifications.show(
          id: listingId.hashCode,
          title: 'New Property Listed! 🏠',
          body: 'Check out "$listingTitle" now on To-Let!',
          notificationDetails: notificationDetails,
          payload: listingId,
        );
      }
    } catch (e) {
      log('Error triggering new listing notification: $e');
    }
  }
}
