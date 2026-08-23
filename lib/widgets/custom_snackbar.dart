import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../core/constants/app_colors.dart';

enum SnackbarType { success, error, info, warning }

class CustomSnackbar {
  CustomSnackbar._();

  static void showSuccess({
    required String title,
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    show(
      title: title,
      message: message,
      type: SnackbarType.success,
      duration: duration,
    );
  }

  static void showError({
    required String title,
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    show(
      title: title,
      message: message,
      type: SnackbarType.error,
      duration: duration,
    );
  }

  static void showInfo({
    required String title,
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    show(
      title: title,
      message: message,
      type: SnackbarType.info,
      duration: duration,
    );
  }

  static void showWarning({
    required String title,
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    show(
      title: title,
      message: message,
      type: SnackbarType.warning,
      duration: duration,
    );
  }

  static void show({
    required String title,
    required String message,
    SnackbarType type = SnackbarType.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    // Close any previous snackbar
    if (Get.isSnackbarOpen) {
      Get.closeCurrentSnackbar();
    }

    final config = _getSnackbarConfig(type);

    Get.rawSnackbar(
      titleText: const SizedBox.shrink(),
      messageText: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: config.bgColor,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: config.borderColor, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(20),
              blurRadius: 16.r,
              offset: Offset(0, 8.h),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Left Circle Icon Container
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: config.iconBgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                config.icon,
                color: config.iconColor,
                size: 22.r,
              ),
            ),
            SizedBox(width: 12.w),

            // Content (Title + Message)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: config.titleColor,
                      letterSpacing: -0.2,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    message,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: config.messageColor,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.transparent,
      margin: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
      padding: EdgeInsets.zero,
      borderRadius: 16.r,
      duration: duration,
      snackStyle: SnackStyle.FLOATING,
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeInCubic,
      animationDuration: const Duration(milliseconds: 400),
      isDismissible: true,
      overlayBlur: 0,
    );
  }

  static _SnackbarStyle _getSnackbarConfig(SnackbarType type) {
    final isDark = Get.isDarkMode;

    switch (type) {
      case SnackbarType.success:
        return _SnackbarStyle(
          bgColor: isDark ? const Color(0xFF1B2E21) : const Color(0xFFF2F9F4),
          borderColor: isDark ? const Color(0xFF2E7D32) : const Color(0xFFC8E6C9),
          iconBgColor: const Color(0xFFE2F4E9),
          iconColor: const Color(0xFF2E7D32),
          icon: Icons.check_circle_rounded,
          titleColor: isDark ? Colors.white : const Color(0xFF1E232A),
          messageColor: isDark ? Colors.white70 : const Color(0xFF555555),
        );
      case SnackbarType.error:
        return _SnackbarStyle(
          bgColor: isDark ? const Color(0xFF331D1D) : const Color(0xFFFDF2F2),
          borderColor: isDark ? const Color(0xFFC62828) : const Color(0xFFFFCDD2),
          iconBgColor: const Color(0xFFFFEBEE),
          iconColor: const Color(0xFFE53935),
          icon: Icons.error_rounded,
          titleColor: isDark ? Colors.white : const Color(0xFF1E232A),
          messageColor: isDark ? Colors.white70 : const Color(0xFF555555),
        );
      case SnackbarType.warning:
        return _SnackbarStyle(
          bgColor: isDark ? const Color(0xFF332A1A) : const Color(0xFFFFFBEA),
          borderColor: isDark ? const Color(0xFFF57F17) : const Color(0xFFFFE082),
          iconBgColor: const Color(0xFFFFF8E1),
          iconColor: const Color(0xFFFFA000),
          icon: Icons.warning_amber_rounded,
          titleColor: isDark ? Colors.white : const Color(0xFF1E232A),
          messageColor: isDark ? Colors.white70 : const Color(0xFF555555),
        );
      case SnackbarType.info:
        return _SnackbarStyle(
          bgColor: isDark ? const Color(0xFF2E221E) : const Color(0xFFFAF4F2),
          borderColor: isDark ? AppColors.primary : AppColors.primaryLight,
          iconBgColor: AppColors.primaryLight,
          iconColor: AppColors.primary,
          icon: Icons.info_outline_rounded,
          titleColor: isDark ? Colors.white : const Color(0xFF1E232A),
          messageColor: isDark ? Colors.white70 : const Color(0xFF555555),
        );
    }
  }
}

class _SnackbarStyle {
  final Color bgColor;
  final Color borderColor;
  final Color iconBgColor;
  final Color iconColor;
  final IconData icon;
  final Color titleColor;
  final Color messageColor;

  _SnackbarStyle({
    required this.bgColor,
    required this.borderColor,
    required this.iconBgColor,
    required this.iconColor,
    required this.icon,
    required this.titleColor,
    required this.messageColor,
  });
}
