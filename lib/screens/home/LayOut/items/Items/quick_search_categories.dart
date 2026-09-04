import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_colors.dart';
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
        'id': 'Family',
        'title': 'Family',
        'icon': Icons.groups_rounded,
      },
      {
        'id': 'Bachelor',
        'title': 'Bachelor Male',
        'icon': Icons.person_rounded,
      },
      {
        'id': 'Bachelor Female',
        'title': 'Bachelor Female',
        'icon': Icons.person_2_rounded,
      },
      {
        'id': 'Sublet',
        'title': 'Sublet',
        'icon': Icons.meeting_room_rounded,
      },
      {
        'id': 'Seat',
        'title': 'Seat',
        'icon': Icons.bed_rounded,
      },
    ];

    return SizedBox(
      height: 44.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          final id = cat['id'] as String;
          final title = cat['title'] as String;
          final icon = cat['icon'] as IconData;

          return Obx(() {
            final selectedCat = controller.selectedCategory.value;
            final isSelected = selectedCat.toLowerCase() == id.toLowerCase();

            return Padding(
              padding: EdgeInsets.only(right: 10.w),
              child: GestureDetector(
                onTap: () {
                  controller.selectCategory(id);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary
                        : (isDark ? AppColors.surfaceDark : Colors.white),
                    borderRadius: BorderRadius.circular(30.r),
                    border: isSelected
                        ? null
                        : Border.all(
                            color: isDark
                                ? AppColors.dividerDark
                                : const Color(0xFFE2E8F0),
                            width: 1,
                          ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppColors.primary.withAlpha(80),
                              blurRadius: 8.r,
                              offset: Offset(0, 3.h),
                            )
                          ]
                        : [
                            BoxShadow(
                              color: Colors.black.withAlpha(isDark ? 10 : 4),
                              blurRadius: 4.r,
                              offset: Offset(0, 2.h),
                            ),
                          ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        icon,
                        size: 16.r,
                        color: isSelected
                            ? Colors.white
                            : (isDark
                                ? AppColors.textSecondaryDark
                                : const Color(0xFF555555)),
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                          color: isSelected
                              ? Colors.white
                              : (isDark
                                  ? AppColors.textPrimaryDark
                                  : const Color(0xFF1E232A)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
        },
      ),
    );
  }
}
