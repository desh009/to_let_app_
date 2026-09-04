import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/notification_model.dart';
import '../controllers/notifications_controller.dart';

class NotificationsScreen extends GetView<NotificationsController> {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Ensure controller is registered
    final ctrl = NotificationsController.to;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: _buildAppBar(context, isDark, ctrl),
      body: Obx(() {
        if (ctrl.notifications.isEmpty) {
          return _buildEmptyState(isDark);
        }

        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          itemCount: ctrl.notifications.length,
          itemBuilder: (context, index) {
            final notification = ctrl.notifications[index];
            return _buildNotificationTile(context, notification, isDark, ctrl);
          },
        );
      }),
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    bool isDark,
    NotificationsController ctrl,
  ) {
    return AppBar(
      elevation: 0,
      backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
      centerTitle: false,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_new_rounded,
          size: 20.r,
          color: isDark ? AppColors.textPrimaryDark : const Color(0xFF1E232A),
        ),
        onPressed: () => Get.back(),
      ),
      title: Row(
        children: [
          Text(
            'Notifications',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.textPrimaryDark : const Color(0xFF1E232A),
            ),
          ),
          SizedBox(width: 8.w),
          Obx(() {
            final count = ctrl.unreadCount;
            if (count == 0) return const SizedBox.shrink();
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                '$count',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            );
          }),
        ],
      ),
      actions: [
        Obx(() {
          if (ctrl.unreadCount == 0) return const SizedBox.shrink();
          return TextButton(
            onPressed: ctrl.markAllAsRead,
            child: Text(
              'Mark all as read',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildNotificationTile(
    BuildContext context,
    AppNotificationModel notification,
    bool isDark,
    NotificationsController ctrl,
  ) {
    IconData typeIcon = Icons.notifications_active_rounded;
    Color iconColor = AppColors.primary;

    if (notification.type == 'price') {
      typeIcon = Icons.local_offer_rounded;
      iconColor = const Color(0xFFE53E3E);
    } else if (notification.type == 'listing') {
      typeIcon = Icons.home_work_rounded;
      iconColor = AppColors.primary;
    }

    final String timeAgo = _formatTimeAgo(notification.timestamp);

    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => ctrl.deleteNotification(notification.id),
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20.w),
        margin: EdgeInsets.only(bottom: 12.h),
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Icon(Icons.delete_outline_rounded, color: Colors.white, size: 24.r),
      ),
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        decoration: BoxDecoration(
          color: notification.isRead
              ? (isDark ? AppColors.surfaceDark.withAlpha(160) : Colors.white)
              : (isDark ? const Color(0xFF2C323B) : const Color(0xFFF0F6FF)),
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(
            color: notification.isRead
                ? (isDark ? AppColors.dividerDark : AppColors.borderSubtle)
                : AppColors.primary.withAlpha(80),
            width: notification.isRead ? 1 : 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(isDark ? 20 : 8),
              blurRadius: 8.r,
              offset: Offset(0, 2.h),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(18.r),
            onTap: () => ctrl.onNotificationTap(notification),
            child: Padding(
              padding: EdgeInsets.all(14.r),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon badge
                  Container(
                    width: 44.r,
                    height: 44.r,
                    decoration: BoxDecoration(
                      color: iconColor.withAlpha(30),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(typeIcon, color: iconColor, size: 22.r),
                  ),
                  SizedBox(width: 12.w),

                  // Notification Title, Body, Timestamp
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                notification.title,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: notification.isRead
                                      ? FontWeight.w600
                                      : FontWeight.w800,
                                  color: isDark
                                      ? AppColors.textPrimaryDark
                                      : const Color(0xFF1E232A),
                                ),
                              ),
                            ),
                            if (!notification.isRead)
                              Container(
                                width: 8.r,
                                height: 8.r,
                                margin: EdgeInsets.only(left: 6.w),
                                decoration: const BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          notification.body,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12.sp,
                            height: 1.35,
                            color: isDark
                                ? AppColors.textSecondaryDark
                                : const Color(0xFF5A6A7D),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time_rounded,
                              size: 12.r,
                              color: isDark ? Colors.white38 : Colors.black38,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              timeAgo,
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: isDark ? Colors.white38 : Colors.black38,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              'Tap to view details ›',
                              style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 90.r,
            height: 90.r,
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(20),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications_off_outlined,
              size: 44.r,
              color: AppColors.primary,
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            'No notifications yet',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.textPrimaryDark : const Color(0xFF1E232A),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'We will notify you when new properties in Khulna\nare posted or price drops occur.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13.sp,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}
