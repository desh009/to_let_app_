import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../controllers/auth_controller.dart';

class ResetPasswordScreen extends GetView<AuthController> {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final inputBg = isDark ? const Color(0xFF1E2228) : const Color(0xFFF7F8FA);
    final textColor = isDark ? Colors.white : const Color(0xFF1E232A);
    final subtitleColor =
        isDark ? const Color(0xFFA0AEC0) : const Color(0xFF7E8B9B);

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.backgroundDark : const Color(0xFFFAF8F5),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10.h),

              // Back button
              GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  width: 40.r,
                  height: 40.r,
                  decoration: BoxDecoration(
                    color: inputBg,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 16.r,
                    color: textColor,
                  ),
                ),
              ),
              SizedBox(height: 24.h),

              // Icon
              Container(
                width: 48.r,
                height: 48.r,
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF1C2B1F)
                      : const Color(0xFFEDF7ED),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: Colors.green.withAlpha(80),
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child: Container(
                    width: 32.r,
                    height: 32.r,
                    decoration: BoxDecoration(
                      color: Colors.green.shade500,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Icon(
                      Icons.lock_reset_rounded,
                      color: Colors.white,
                      size: 20.r,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24.h),

              // Title
              Text(
                'Create New Password',
                style: TextStyle(
                  fontSize: 26.sp,
                  fontWeight: FontWeight.w900,
                  color: textColor,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                'Your new password must be different\nfrom previous passwords',
                style: TextStyle(
                  fontSize: 13.5.sp,
                  fontWeight: FontWeight.w500,
                  color: subtitleColor,
                ),
              ),
              SizedBox(height: 40.h),

              // New Password
              Text(
                'New Password',
                style: TextStyle(
                  fontSize: 12.5.sp,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
              ),
              SizedBox(height: 8.h),
              Obx(
                () => Container(
                  height: 52.h,
                  padding: EdgeInsets.symmetric(horizontal: 14.w),
                  decoration: BoxDecoration(
                    color: inputBg,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: isDark
                          ? const Color(0xFF2D3748)
                          : const Color(0xFFE2E8F0),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.lock_outline_rounded,
                          size: 18.r, color: subtitleColor),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: TextField(
                          controller: controller.forgotNewPasswordController,
                          obscureText:
                              controller.isForgotNewPasswordHidden.value,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            isDense: true,
                            hintText: 'Enter new password',
                            hintStyle: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: subtitleColor.withAlpha(120),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () =>
                            controller.isForgotNewPasswordHidden.value =
                                !controller.isForgotNewPasswordHidden.value,
                        child: Icon(
                          controller.isForgotNewPasswordHidden.value
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          size: 18.r,
                          color: subtitleColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 18.h),

              // Confirm Password
              Text(
                'Confirm Password',
                style: TextStyle(
                  fontSize: 12.5.sp,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
              ),
              SizedBox(height: 8.h),
              Obx(
                () => Container(
                  height: 52.h,
                  padding: EdgeInsets.symmetric(horizontal: 14.w),
                  decoration: BoxDecoration(
                    color: inputBg,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: isDark
                          ? const Color(0xFF2D3748)
                          : const Color(0xFFE2E8F0),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.lock_outline_rounded,
                          size: 18.r, color: subtitleColor),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: TextField(
                          controller: controller.forgotConfirmPasswordController,
                          obscureText:
                              controller.isForgotConfirmPasswordHidden.value,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            isDense: true,
                            hintText: 'Re-enter password',
                            hintStyle: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: subtitleColor.withAlpha(120),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => controller
                                .isForgotConfirmPasswordHidden.value =
                            !controller.isForgotConfirmPasswordHidden.value,
                        child: Icon(
                          controller.isForgotConfirmPasswordHidden.value
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          size: 18.r,
                          color: subtitleColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 12.h),

              // Password requirements
              Container(
                padding: EdgeInsets.all(14.w),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF1A1F25)
                      : const Color(0xFFF0F4F8),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Password must contain:',
                      style: TextStyle(
                        fontSize: 11.5.sp,
                        fontWeight: FontWeight.w700,
                        color: textColor,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    _buildRequirement('At least 6 characters', subtitleColor),
                    SizedBox(height: 4.h),
                    _buildRequirement(
                        'A mix of letters and numbers', subtitleColor),
                  ],
                ),
              ),
              SizedBox(height: 40.h),

              // Reset Password Button
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  height: 52.h,
                  child: ElevatedButton(
                    onPressed: controller.isResettingPassword.value
                        ? null
                        : controller.resetPassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(26.r),
                      ),
                      elevation: 0,
                      disabledBackgroundColor: AppColors.primary.withAlpha(120),
                    ),
                    child: controller.isResettingPassword.value
                        ? SizedBox(
                            width: 22.r,
                            height: 22.r,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(
                            'Reset Password',
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w800,
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
    );
  }

  Widget _buildRequirement(String text, Color color) {
    return Row(
      children: [
        Icon(
          Icons.check_circle_outline_rounded,
          size: 14.r,
          color: color,
        ),
        SizedBox(width: 8.w),
        Text(
          text,
          style: TextStyle(
            fontSize: 11.sp,
            fontWeight: FontWeight.w500,
            color: color,
          ),
        ),
      ],
    );
  }
}
