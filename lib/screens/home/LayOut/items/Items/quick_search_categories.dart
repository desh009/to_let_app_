import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../routes/app_routes.dart';
import '../../../controllers/home_controller.dart';

class QuickSearchCategories extends StatelessWidget {
  const QuickSearchCategories({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final categories = [
      {
        'title': 'Family'.tr,
        'icon': Icons.family_restroom_rounded,
        'bgColor': isDark ? const Color(0xFF352420) : AppColors.catFamilyBg,
        'iconColor': AppColors.catFamilyIcon,
      },
      {
        'title': 'Bachelor'.tr,
        'icon': Icons.group_outlined,
        'bgColor': isDark ? const Color(0xFF1E2D32) : AppColors.catBachelorBg,
        'iconColor': isDark ? Colors.cyan.shade300 : AppColors.catBachelorIcon,
      },
      
      {
        'title': 'Sublet'.tr,
        'icon': Icons.meeting_room_outlined,
        'bgColor': isDark ? const Color(0xFF332F20) : AppColors.catSubletBg,
        'iconColor': isDark ? Colors.amber.shade300 : AppColors.catSubletIcon,
      },
      {
        'title': 'Seat'.tr,
        'icon': Icons.single_bed_outlined,
        'bgColor': isDark ? const Color(0xFF2A2926) : AppColors.catSeatBg,
        'iconColor': isDark ? Colors.white70 : AppColors.catSeatIcon,
      },
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title & See all
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Quick search'.tr,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w800,
                  color: isDark ? AppColors.textPrimaryDark : const Color(0xFF1E232A),
                ),
              ),
              InkWell(
                onTap: () {
                  if (controller.selectedCategory.value.isNotEmpty) {
                    controller.selectCategory('');
                  } else {
                    Get.toNamed(Routes.FILTER_RESULTS);
                  }
                },
                child: Text(
                  'See all'.tr,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Categories Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: categories.map((cat) {
              final title = cat['title'] as String;
              final icon = cat['icon'] as IconData;
              final bgColor = cat['bgColor'] as Color;
              final iconColor = cat['iconColor'] as Color;

              return Obx(() {
                final isSelected = controller.selectedCategory.value.toLowerCase() == title.toLowerCase();

                return InkWell(
                  borderRadius: BorderRadius.circular(20.r),
                  onTap: () => controller.selectCategory(title),
                  child: Column(
                    children: [
                      Container(
                        width: 68.w,
                        height: 68.w,
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: BorderRadius.circular(20.r),
                          border: isSelected
                              ? Border.all(color: AppColors.primary, width: 2)
                              : null,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(isDark ? 15 : 6),
                              blurRadius: 6.r,
                              offset: Offset(0, 2.h),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Icon(
                            icon,
                            color: isSelected ? AppColors.primary : iconColor,
                            size: 28.r,
                          ),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected
                              ? AppColors.primary
                              : (isDark ? AppColors.textPrimaryDark : const Color(0xFF1E232A)),
                        ),
                      ),
                    ],
                  ),
                );
              });
            }).toList(),
          ),
        ],
      ),
    );
  }
}
