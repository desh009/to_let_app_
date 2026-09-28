import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:to_let_app_abandon/data/models/listing_model.dart';
import 'package:to_let_app_abandon/data/repositories/listings_repo.dart';
import '../../../data/models/notification_model.dart';
import '../../../data/repositories/notifications_repo.dart';
import '../../../domain/entities/tolet_item.dart';
import '../../../routes/app_routes.dart';

class NotificationsController extends GetxController {
  static NotificationsController get to {
    if (!Get.isRegistered<NotificationsController>()) {
      return Get.put(NotificationsController(), permanent: true);
    }
    return Get.find<NotificationsController>();
  }

  late final NotificationsRepo _notificationsRepo;
  final RxList<AppNotificationModel> notifications = <AppNotificationModel>[].obs;
  final RxBool isLoading = false.obs;

  NotificationsController({NotificationsRepo? notificationsRepo}) {
    _notificationsRepo = notificationsRepo ??
        (Get.isRegistered<NotificationsRepo>()
            ? Get.find<NotificationsRepo>()
            : NotificationsRepo());
  }

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    try {
      isLoading.value = true;
      final response = await _notificationsRepo.getNotifications();
      if (response.isSuccess) {
        final list = _notificationsRepo.parseNotifications(response);
        if (list.isNotEmpty) {
          notifications.assignAll(list);
          return;
        }
      }
    } catch (e) {
      debugPrint('Error loading notifications: $e');
    } finally {
      isLoading.value = false;
    }
  }

 
  void addNotification({
    required String title,
    required String body,
    String? propertyId,
    ToLetItem? property,
    String type = 'listing',
  }) {
    final newNotif = AppNotificationModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      body: body,
      timestamp: DateTime.now(),
      isRead: false,
      propertyId: propertyId,
      property: property,
      type: type,
    );
    notifications.insert(0, newNotif);
  }

  void markAsRead(String id) {
    final index = notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      notifications[index].isRead = true;
      notifications.refresh();
      _notificationsRepo.markAsRead(id);
    }
  }

  void markAllAsRead() {
    for (var n in notifications) {
      n.isRead = true;
    }
    notifications.refresh();
    _notificationsRepo.markAllAsRead();
  }

  void deleteNotification(String id) {
    notifications.removeWhere((n) => n.id == id);
  }

  void onNotificationTap(AppNotificationModel item) async {
    markAsRead(item.id);

    if (item.property != null) {
      Get.toNamed(Routes.DETAILS, arguments: item.property);
      return;
    }

    if (item.propertyId != null) {
      // Fetch the real property from API
      try {
        final listingsRepo = Get.isRegistered<ListingsRepo>() 
            ? Get.find<ListingsRepo>() 
            : ListingsRepo();
        
        final response = await listingsRepo.getListingDetails(item.propertyId!);
        if (response.isSuccess && response.responseData?['data'] != null) {
          final listingModel = ListingModel.fromJson(response.responseData!['data']);
          final toLetItem = listingModel.toToLetItem();
          Get.toNamed(Routes.DETAILS, arguments: toLetItem);
        } else {
          Get.snackbar('Error', 'Property details not found');
        }
      } catch (e) {
        debugPrint('Error fetching notification property: $e');
      }
    }
  }

  int get unreadCount => notifications.where((n) => !n.isRead).length;
}
