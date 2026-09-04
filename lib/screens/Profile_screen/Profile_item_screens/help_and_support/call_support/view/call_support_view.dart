import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:to_let_app_abandon/core/constants/app_colors.dart';
import 'package:to_let_app_abandon/core/constants/app_strings.dart';
import 'package:to_let_app_abandon/screens/Profile_screen/Profile_item_screens/help_and_support/call_support/controller/call_support_controller.dart';


class CallUsScreen extends GetView<CallUsController> {
  const CallUsScreen({super.key});

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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 16.h),


                        Container(
                          width: 100.r,
                          height: 100.r,
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.06),
                            borderRadius: BorderRadius.circular(28.r),
                          ),
                          child: Icon(
                            Icons.phone_outlined,
                            size: 40.r,
                            color: AppColors.primary,
                          ),
                        ),
                        SizedBox(height: 24.h),


                        Text(
                          AppStrings.wereHereToHelp,
                          style: TextStyle(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          AppStrings.talkToSupportSubtext,
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                            height: 1.4,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 28.h),


                        _buildHelplineCard(),
                        SizedBox(height: 20.h),


                        Obx(
                          () => SizedBox(
                            width: double.infinity,
                            height: 52.h,
                            child: ElevatedButton(
                              onPressed: controller.isDialing.value
                                  ? null
                                  : () => controller.dialNumber(AppStrings.helplineNumber),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                disabledBackgroundColor: AppColors.primary.withOpacity(0.6),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(26.r),
                                ),
                                elevation: 0,
                              ),
                              child: controller.isDialing.value
                                  ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      ),
                                    )
                                  : Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.phone_outlined,
                                          color: Colors.white,
                                          size: 20.r,
                                        ),
                                        SizedBox(width: 8.w),
                                        Text(
                                          AppStrings.callNow,
                                          style: TextStyle(
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                        ),
                        SizedBox(height: 24.h),


                        _buildScheduleCard(isDark),
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
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
            ),
          ),
          Text(
            AppStrings.callUs,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
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


  Widget _buildHelplineCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        children: [
          Text(
            AppStrings.helplineNumberTitle,
            style: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 11.sp,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            AppStrings.helplineNumber,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: 14.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 14.r,
                height: 14.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF00E676), width: 1.5),
                ),
                child: Center(
                  child: Container(
                    width: 5.r,
                    height: 5.r,
                    decoration: const BoxDecoration(
                      color: Color(0xFF00E676),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 6.w),
              Text(
                "${AppStrings.availableNow} • ${AppStrings.availableTime}",
                style: TextStyle(
                  color: const Color(0xFF00E676),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


  Widget _buildScheduleCard(bool isDark) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.grey.shade50.withOpacity(0.8),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark ? AppColors.dividerDark : Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.access_time,
                size: 16.r,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              ),
              SizedBox(width: 8.w),
              Text(
                AppStrings.callSchedule,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          _buildScheduleRow(AppStrings.everyday, AppStrings.everydayTime, isDark),
          SizedBox(height: 8.h),
          _buildScheduleRow(AppStrings.friday, AppStrings.fridayTime, isDark),
        ],
      ),
    );
  }

  Widget _buildScheduleRow(String day, String time, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          day,
          style: TextStyle(
            fontSize: 12.sp,
            color: isDark ? AppColors.textSecondaryDark : Colors.grey.shade600,
          ),
        ),
        Text(
          time,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
      ],
    );
  }
}