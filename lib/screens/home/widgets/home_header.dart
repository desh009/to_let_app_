import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../controllers/home_controller.dart';
import 'storage_demo_dialog.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Greeting & Headline
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () => Text(
                    'Good morning, ${controller.savedUserName.value}',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: isDark ? AppColors.textSecondaryDark : const Color(0xFF7D7A75),
                    ),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Find your next place',
                  style: TextStyle(
                    fontSize: 26.sp,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                    color: isDark ? AppColors.textPrimaryDark : const Color(0xFF1E232A),
                  ),
                ),
              ],
            ),
          ),

          // Notification Bell Button
          Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(isDark ? 30 : 12),
                  blurRadius: 10.r,
                  offset: Offset(0, 3.h),
                ),
              ],
            ),
            child: IconButton(
              icon: Icon(
                Icons.notifications_none_rounded,
                size: 22.r,
                color: const Color(0xFF1E232A),
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => const StorageDemoDialog(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
