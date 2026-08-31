import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constants/app_colors.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final navItems = [
      {
        'label': 'Home',
        'icon': Icons.home_rounded,
        'unselectedIcon': Icons.home_outlined,
      },
      {
        'label': 'Saved',
        'icon': Icons.favorite_rounded,
        'unselectedIcon': Icons.favorite_border_rounded,
      },
      {
        'label': 'Messages',
        'icon': Icons.chat_bubble_rounded,
        'unselectedIcon': Icons.chat_bubble_outline_rounded,
      },
      {
        'label': 'Profile',
        'icon': Icons.person_rounded,
        'unselectedIcon': Icons.person_outline_rounded,
      },
    ];

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 40 : 10),
            blurRadius: 20.r,
            offset: Offset(0, -4.h),
          ),
        ],
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.dividerDark : AppColors.borderSubtle,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(navItems.length, (index) {
              final isSelected = currentIndex == index;
              final item = navItems[index];

              return InkWell(
                onTap: () => onTap(index),
                borderRadius: BorderRadius.circular(24.r),
                splashColor: AppColors.primary.withAlpha(20),
                highlightColor: Colors.transparent,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOutCubic,
                  padding: EdgeInsets.symmetric(
                    horizontal: isSelected ? 18.w : 12.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? (isDark
                            ? AppColors.primary.withAlpha(50)
                            : AppColors.primaryLight)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(24.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedScale(
                        scale: isSelected ? 1.15 : 1.0,
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeOutBack,
                        child: Icon(
                          isSelected
                              ? (item['icon'] as IconData)
                              : (item['unselectedIcon'] as IconData),
                          size: 22.r,
                          color: isSelected
                              ? AppColors.primary
                              : (isDark
                                  ? AppColors.textSecondaryDark
                                  : const Color(0xFF8A8784)),
                        ),
                      ),
                      AnimatedSize(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOutCubic,
                        child: isSelected
                            ? Padding(
                                padding: EdgeInsets.only(left: 8.w),
                                child: Text(
                                  item['label'] as String,
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.2,
                                  ),
                                ),
                              )
                            : const SizedBox.shrink(),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
