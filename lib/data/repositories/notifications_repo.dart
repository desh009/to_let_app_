import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../core/config/urls.dart';
import '../../core/network/network_response.dart';
import '../../core/services/network_service.dart';
import '../models/notification_model.dart';

class NotificationsRepo {
  final NetworkService _networkService = Get.find<NetworkService>();

  /// Fetch user notifications
  Future<NetworkResponse> getNotifications({
    int offset = 0,
    int limit = 30,
  }) async {
    return await _networkService.get(
      Urls.notifications,
      queryParams: {'offset': offset, 'limit': limit},
    );
  }

  /// Parse notifications list from response
  List<AppNotificationModel> parseNotifications(NetworkResponse response) {
    if (response.isSuccess && response.responseData != null) {
      try {
        final list = response.responseData!['data'] as List<dynamic>? ?? [];
        return list
            .map((item) => AppNotificationModel.fromJson(item as Map<String, dynamic>))
            .toList();
      } catch (e) {
        debugPrint('Error parsing notifications response: $e');
      }
    }
    return [];
  }

  /// Mark single notification as read
  Future<NetworkResponse> markAsRead(String id) async {
    return await _networkService.patch(Urls.notificationRead(id));
  }

  /// Mark all notifications as read
  Future<NetworkResponse> markAllAsRead() async {
    return await _networkService.patch(Urls.notificationsReadAll);
  }
}
