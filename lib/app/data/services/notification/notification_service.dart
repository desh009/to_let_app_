import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import '../../../../core/services/fcm_service.dart';

class NotificationApiService {

  static const String _baseUrl = 'https://fcm-notification-api-ten.vercel.app';


  static Future<void> notifyNewListing({
    required String listingTitle,
    required String listingId,
  }) async {
    try {
      log(
        'Sending new listing notification for: $listingTitle (ID: $listingId)',
      );

      final response = await http.post(
        Uri.parse('$_baseUrl/api/sendNotification'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'title': 'New Property Listed! 🏠',
          'body': 'Check out "$listingTitle" now on To-Let!',
          'topic': 'all_users',
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
    } catch (e) {
      log('Error triggering new listing notification: $e');
    }
  }
}
