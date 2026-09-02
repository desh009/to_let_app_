import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:to_let_app_abandon/core/constants/app_colors.dart';
import 'package:to_let_app_abandon/core/constants/app_strings.dart';
import 'package:to_let_app_abandon/screens/Profile_screen/Profile_item_screens/report_problem_screen/controller/report_problem_controller.dart';


class ReportProblemScreen extends GetView<ReportProblemController> {
  const ReportProblemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(isDark),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 500.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 6.h),

                        // Red Alert Banner
                        _buildNoticeBanner(isDark),
                        SizedBox(height: 20.h),
                        SizedBox(height: 24.h),

                        // Description Field Title
                        Text(
                          AppStrings.description,
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? AppColors.textSecondaryDark
                                : Colors.grey.shade600,
                            letterSpacing: 0.8,
                          ),
                        ),
                        SizedBox(height: 8.h),

                        // Description TextField Input
                        Container(
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.surfaceDark : Colors.white,
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(
                              color: isDark
                                  ? AppColors.dividerDark
                                  : Colors.grey.shade300,
                            ),
                          ),
                          child: TextField(
                            controller: controller.descriptionController,
                            maxLines: 4,
                            textInputAction: TextInputAction.newline,
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: isDark
                                  ? AppColors.textPrimaryDark
                                  : AppColors.textPrimaryLight,
                            ),
                            decoration: InputDecoration(
                              hintText: AppStrings.reportHintText,
                              hintStyle: TextStyle(
                                fontSize: 13.sp,
                                color: isDark
                                    ? AppColors.textSecondaryDark
                                    : Colors.grey.shade400,
                              ),
                              contentPadding: EdgeInsets.all(16.r),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        SizedBox(height: 24.h),

                        // Submit Button
                        Obx(
                          () => SizedBox(
                            width: double.infinity,
                            height: 52.h,
                            child: ElevatedButton(
                              onPressed: controller.isSubmitting.value
                                  ? null
                                  : controller.submitReport,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                disabledBackgroundColor:
                                    AppColors.primary.withOpacity(0.5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(26.r),
                                ),
                                elevation: 0,
                              ),
                              child: controller.isSubmitting.value
                                  ? SizedBox(
                                      width: 20.r,
                                      height: 20.r,
                                      child: const CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Text(
                                      AppStrings.submitReport,
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          ),
                        ),
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

  // Header Navigation Bar
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
            AppStrings.reportAProblemTitle,
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

  // Top Anonymous Notice Box
  Widget _buildNoticeBanner(bool isDark) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEBEE).withOpacity(isDark ? 0.15 : 0.7),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: const Color(0xFFFFCDD2).withOpacity(isDark ? 0.3 : 0.6),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: const Color(0xFFE53935),
            size: 20.r,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              AppStrings.reportAnonymousNotice,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.red.shade200 : const Color(0xFFD32F2F),
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Custom Radio Option Card
  Widget _buildOptionCard({
    required ProblemOption option,
    required bool isSelected,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? const Color(0xFF1E1E1E) : const Color(0xFF121212))
              : (isDark ? AppColors.surfaceDark : Colors.white),
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(
            color: isSelected
                ? (isDark ? AppColors.primary : Colors.transparent)
                : (isDark ? AppColors.dividerDark : Colors.grey.shade200),
          ),
        ),
        child: Row(
          children: [
            // Custom Radio Indicator Icon
            Container(
              width: 22.r,
              height: 22.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? Colors.white : Colors.grey.shade400,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 10.r,
                        height: 10.r,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    option.title,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? Colors.white
                          : (isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimaryLight),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    option.subtitle,
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: isSelected
                          ? Colors.grey.shade400
                          : (isDark
                              ? AppColors.textSecondaryDark
                              : Colors.grey.shade600),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}