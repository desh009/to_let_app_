import 'package:get/get.dart';
import '../../../data/models/notification_model.dart';
import '../../../data/models/tolet_model.dart';
import '../../../domain/entities/tolet_item.dart';
import '../../../routes/app_routes.dart';

class NotificationsController extends GetxController {
  static NotificationsController get to {
    if (!Get.isRegistered<NotificationsController>()) {
      return Get.put(NotificationsController(), permanent: true);
    }
    return Get.find<NotificationsController>();
  }

  final RxList<AppNotificationModel> notifications = <AppNotificationModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadSampleNotifications();
  }

  void _loadSampleNotifications() {
    final samples = ToLetModel.sampleData;
    if (samples.isEmpty) return;

    notifications.assignAll([
      AppNotificationModel(
        id: '1',
        title: '🏠 New Family Flat in Sonadanga',
        body: 'A 3 BHK Luxury Apartment is now available for rent in Sonadanga, Khulna.',
        timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
        isRead: false,
        propertyId: samples[0].id,
        property: samples[0],
        type: 'listing',
      ),
      AppNotificationModel(
        id: '2',
        title: '🔥 Price Drop in Khalishpur!',
        body: 'Rent reduced to ৳18,000/month for Modern Family House in Khalishpur.',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        isRead: false,
        propertyId: samples.length > 1 ? samples[1].id : samples[0].id,
        property: samples.length > 1 ? samples[1] : samples[0],
        type: 'price',
      ),
      AppNotificationModel(
        id: '3',
        title: '👤 New Bachelor Room near Boyra',
        body: 'Single seat available for student/jobholder near Boyra Main Road.',
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        isRead: true,
        propertyId: samples.length > 2 ? samples[2].id : samples[0].id,
        property: samples.length > 2 ? samples[2] : samples[0],
        type: 'listing',
      ),
      AppNotificationModel(
        id: '4',
        title: '✨ Exclusive Sublet in Nirala',
        body: '1 Room Sublet available from next month in Nirala Residential Area.',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        isRead: true,
        propertyId: samples.length > 3 ? samples[3].id : samples[0].id,
        property: samples.length > 3 ? samples[3] : samples[0],
        type: 'listing',
      ),
    ]);
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
      property: property ?? (ToLetModel.sampleData.isNotEmpty ? ToLetModel.sampleData.first : null),
      type: type,
    );
    notifications.insert(0, newNotif);
  }

  void markAsRead(String id) {
    final index = notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      notifications[index].isRead = true;
      notifications.refresh();
    }
  }

  void markAllAsRead() {
    for (var n in notifications) {
      n.isRead = true;
    }
    notifications.refresh();
  }

  void deleteNotification(String id) {
    notifications.removeWhere((n) => n.id == id);
  }

  void onNotificationTap(AppNotificationModel item) {
    markAsRead(item.id);


    ToLetItem? targetItem = item.property;
    if (targetItem == null && item.propertyId != null) {
      targetItem = ToLetModel.sampleData.firstWhereOrNull((p) => p.id == item.propertyId);
    }
    targetItem ??= ToLetModel.sampleData.isNotEmpty ? ToLetModel.sampleData.first : null;

    if (targetItem != null) {
      Get.toNamed(Routes.DETAILS, arguments: targetItem);
    }
  }

  int get unreadCount => notifications.where((n) => !n.isRead).length;
}
