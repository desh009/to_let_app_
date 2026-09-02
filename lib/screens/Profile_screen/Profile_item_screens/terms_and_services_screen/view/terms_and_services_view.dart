import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:to_let_app_abandon/core/constants/app_colors.dart';
import 'package:to_let_app_abandon/core/constants/app_strings.dart';
import 'package:to_let_app_abandon/screens/Profile_screen/Profile_item_screens/terms_and_services_screen/controller/terms_and_services_controller.dart';


class TermsOfServiceScreen extends GetView<TermsOfServiceController> {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.scaffoldBg,
      floatingActionButton: Obx(
        () => AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: controller.showScrollToTop.value ? 1 : 0,
          child: IgnorePointer(
            ignoring: !controller.showScrollToTop.value,
            child: FloatingActionButton.small(
              onPressed: controller.scrollToTop,
              backgroundColor: AppColors.primary,
              elevation: 2,
              child: Icon(
                Icons.arrow_upward_rounded,
                size: 18.r,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(isDark),
            Expanded(
              child: SingleChildScrollView(
                controller: controller.scrollController,
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 500.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10.h),

                        // সব সেকশন
                        ...controller.sections.map(
                          (section) => _buildSection(section, isDark),
                        ),

                        SizedBox(height: 4.h),

                        // Footer Questions/Legal Notice Box
                        _buildFooterNoticeCard(isDark),
                        SizedBox(height: 20.h),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // এক একটা সেকশন রেন্ডার
  Widget _buildSection(TermsSection section, bool isDark) {
    return Padding(
      padding: EdgeInsets.only(bottom: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(section.title, isDark),
          SizedBox(height: section.hasBullets ? 12.h : 8.h),
          if (section.body != null) _buildBodyText(section.body!, isDark),
          if (section.hasBullets)
            ...List.generate(section.bullets.length, (index) {
              return Padding(
                padding: EdgeInsets.only(
                  bottom: index == section.bullets.length - 1 ? 0 : 8.h,
                ),
                child: _buildBulletPoint(section.bullets[index], isDark),
              );
            }),
        ],
      ),
    );
  }

  // Header App Bar
  Widget _buildAppBar(bool isDark) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: controller.handleBack,
            child: Container(
              width: 36.r,
              height: 36.r,
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_back,
                size: 18.r,
                color: isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimaryLight,
              ),
            ),
          ),
          Text(
            AppStrings.termsOfServiceTitle,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(10.r),
            ),
     
          ),
        ],
      ),
    );
  }

  // Section Title
  Widget _buildSectionHeader(String title, bool isDark) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 15.sp,
        fontWeight: FontWeight.bold,
        color: isDark ? AppColors.textPrimaryDark : const Color(0xFF1E293B),
      ),
    );
  }

  // General Text Paragraph
  Widget _buildBodyText(String text, bool isDark) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 13.sp,
        color: isDark ? AppColors.textSecondaryDark : Colors.grey.shade700,
        height: 1.5,
      ),
    );
  }

  // Bullet Point Item
  Widget _buildBulletPoint(String text, bool isDark) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 6.h, right: 10.w),
          child: Container(
            width: 5.r,
            height: 5.r,
            decoration: BoxDecoration(
              color: isDark ? AppColors.textSecondaryDark : Colors.grey.shade700,
              shape: BoxShape.circle,
            ),
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13.sp,
              color: isDark ? AppColors.textSecondaryDark : Colors.grey.shade700,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  // Bottom Grey Container Card
  Widget _buildFooterNoticeCard(bool isDark) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceDark
            : Colors.grey.shade100.withOpacity(0.8),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Text(
        AppStrings.termsContactNotice,
        style: TextStyle(
          fontSize: 12.sp,
          color: isDark ? AppColors.textSecondaryDark : Colors.grey.shade700,
          height: 1.4,
        ),
      ),
    );
  }
}