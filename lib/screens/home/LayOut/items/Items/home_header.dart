import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:to_let_app_abandon/routes/app_routes.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../controllers/home_controller.dart';

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
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : const Color(0xFF7D7A75),
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
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : const Color(0xFF1E232A),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: 12.w),
          GestureDetector(
            onTap: () => Get.toNamed(Routes.NOTIFICATIONS),
            child: Container(
              width: 44.r,
              height: 44.r,
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF2C2C2C)
                    : const Color(0xFFF5F2EC),
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDark
                      ? const Color(0xFF383838)
                      : const Color(0xFFEBE6DD),
                  width: 1,
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    Icons.notifications_none_rounded,
                    size: 22.r,
                    color: isDark ? Colors.white : const Color(0xFF1E232A),
                  ),
                  Positioned(
                    top: 10.h,
                    right: 11.w,
                    child: Container(
                      width: 8.r,
                      height: 8.r,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFF4D4F),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
