import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../controllers/auth_controller.dart';

class ForgotPasswordScreen extends GetView<AuthController> {
  const ForgotPasswordScreen({super.key});

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
        child: Obx(
          () => controller.isForgotPasswordStep2.value
              ? _buildStep2OtpView(context, isDark, textColor, subtitleColor, inputBg)
              : _buildStep1View(context, isDark, textColor, subtitleColor, inputBg),
        ),
      ),
    );
  }


  Widget _buildStep1View(
    BuildContext context,
    bool isDark,
    Color textColor,
    Color subtitleColor,
    Color inputBg,
  ) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10.h),

          // Back Button
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

          // App Icon Badge
          Container(
            width: 48.r,
            height: 48.r,
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF2B1F1C)
                  : const Color(0xFFFDF0ED),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: AppColors.primary.withAlpha(60),
                width: 1.5,
              ),
            ),
            child: Center(
              child: Container(
                width: 32.r,
                height: 32.r,
                decoration: BoxDecoration(
                  color: AppColors.primary,
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

          // Title & Subtitle
          Text(
            'Forgot Password?',
            style: TextStyle(
              fontSize: 26.sp,
              fontWeight: FontWeight.w900,
              color: textColor,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'Enter your registered phone number or email.\nWe\'ll send a 6-digit OTP to reset your password.',
            style: TextStyle(
              fontSize: 13.5.sp,
              fontWeight: FontWeight.w500,
              color: subtitleColor,
            ),
          ),
          SizedBox(height: 32.h),

          // Phone / Email Field Label
          Text(
            'Phone or Email',
            style: TextStyle(
              fontSize: 12.5.sp,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
          SizedBox(height: 8.h),

          // Input Field
          Container(
            height: 52.h,
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            decoration: BoxDecoration(
              color: inputBg,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.person_outline_rounded,
                  size: 18.r,
                  color: subtitleColor,
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: TextField(
                    controller: controller.forgotPasswordInputController,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 28.h),

          // Send OTP Button
          Obx(
            () => SizedBox(
              width: double.infinity,
              height: 52.h,
              child: ElevatedButton(
                onPressed: controller.isSendingForgotOtp.value
                    ? null
                    : controller.sendForgotPasswordOtp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(26.r),
                  ),
                  elevation: 0,
                ),
                child: controller.isSendingForgotOtp.value
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
                        'Send OTP',
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ),
          SizedBox(height: 32.h),

          // Back to Login
          Center(
            child: GestureDetector(
              onTap: () => Get.back(),
              child: RichText(
                text: TextSpan(
                  text: 'Remember your password? ',
                  style: TextStyle(
                    fontSize: 13.5.sp,
                    fontWeight: FontWeight.w500,
                    color: subtitleColor,
                  ),
                  children: [
                    TextSpan(
                      text: 'Log In',
                      style: TextStyle(
                        fontSize: 13.5.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 20.h),

          // Security note
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.verified_user_outlined,
                  size: 14.r,
                  color: subtitleColor,
                ),
                SizedBox(width: 5.w),
                Text(
                  'Your data is safe & encrypted',
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                    color: subtitleColor,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }

  // ── STEP 2: OTP + New Password ───────────────────────────────────────────
  Widget _buildStep2OtpView(
    BuildContext context,
    bool isDark,
    Color textColor,
    Color subtitleColor,
    Color inputBg,
  ) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10.h),

          // Back Button (go back to step 1)
          GestureDetector(
            onTap: () => controller.isForgotPasswordStep2.value = false,
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
                  Icons.mark_email_read_rounded,
                  color: Colors.white,
                  size: 20.r,
                ),
              ),
            ),
          ),
          SizedBox(height: 24.h),

          // Title
          Text(
            'Check Your Phone',
            style: TextStyle(
              fontSize: 26.sp,
              fontWeight: FontWeight.w900,
              color: textColor,
            ),
          ),
          SizedBox(height: 6.h),
          Obx(
            () => Text(
              'We\'ve sent a 6-digit OTP to\n${controller.forgotPasswordInputController.text.trim()}',
              style: TextStyle(
                fontSize: 13.5.sp,
                fontWeight: FontWeight.w500,
                color: subtitleColor,
              ),
            ),
          ),
          SizedBox(height: 32.h),

          // OTP Boxes
          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(6, (i) {
                final filled = i < controller.forgotOtpDigits.length &&
                    controller.forgotOtpDigits[i].isNotEmpty;
                final isActive = i == controller.currentForgotOtpIndex.value;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 44.r,
                  height: 52.r,
                  decoration: BoxDecoration(
                    color: isActive
                        ? AppColors.primary.withAlpha(15)
                        : inputBg,
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(
                      color: isActive
                          ? AppColors.primary
                          : filled
                              ? AppColors.primary.withAlpha(100)
                              : (isDark
                                  ? const Color(0xFF2D3748)
                                  : const Color(0xFFE2E8F0)),
                      width: isActive ? 2 : 1.5,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: filled
                      ? Text(
                          '•',
                          style: TextStyle(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w900,
                            color: AppColors.primary,
                          ),
                        )
                      : (isActive
                          ? Container(
                              width: 2,
                              height: 22.h,
                              color: AppColors.primary,
                            )
                          : const SizedBox.shrink()),
                );
              }),
            ),
          ),
          SizedBox(height: 28.h),

          // Numpad
          _buildNumpad(textColor, subtitleColor, inputBg),
          SizedBox(height: 20.h),

          // Resend timer
          Obx(
            () => Center(
              child: controller.canResendForgotOtp.value
                  ? GestureDetector(
                      onTap: controller.resendForgotOtp,
                      child: Text(
                        'Resend OTP',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    )
                  : RichText(
                      text: TextSpan(
                        text: 'Resend OTP in ',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: subtitleColor,
                          fontWeight: FontWeight.w500,
                        ),
                        children: [
                          TextSpan(
                            text: controller.formattedForgotTimer,
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ),
          SizedBox(height: 28.h),

          // Divider
          Divider(
            color: isDark
                ? const Color(0xFF2D3748)
                : const Color(0xFFE2E8F0),
          ),
          SizedBox(height: 20.h),

          // New Password Label
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
              ),
              child: Row(
                children: [
                  Icon(Icons.lock_outline_rounded, size: 18.r, color: subtitleColor),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: TextField(
                      controller: controller.forgotNewPasswordController,
                      obscureText: controller.isForgotNewPasswordHidden.value,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => controller.isForgotNewPasswordHidden.value =
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
          SizedBox(height: 14.h),

          // Confirm Password Label
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
              ),
              child: Row(
                children: [
                  Icon(Icons.lock_outline_rounded, size: 18.r, color: subtitleColor),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: TextField(
                      controller: controller.forgotConfirmPasswordController,
                      obscureText: controller.isForgotConfirmPasswordHidden.value,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () =>
                        controller.isForgotConfirmPasswordHidden.value =
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
          SizedBox(height: 28.h),

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
    );
  }

  Widget _buildNumpad(Color textColor, Color subtitleColor, Color inputBg) {
    final keys = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
      ['', '0', 'del'],
    ];

    return Column(
      children: keys.map((row) {
        return Padding(
          padding: EdgeInsets.only(bottom: 10.h),
          child: Row(
            children: row.map((key) {
              if (key.isEmpty) {
                return Expanded(child: SizedBox(height: 52.h));
              }
              if (key == 'del') {
                return Expanded(
                  child: GestureDetector(
                    onTap: controller.deleteForgotOtpDigit,
                    child: Container(
                      height: 52.h,
                      margin: EdgeInsets.symmetric(horizontal: 4.w),
                      decoration: BoxDecoration(
                        color: inputBg,
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      child: Icon(
                        Icons.backspace_outlined,
                        size: 20.r,
                        color: subtitleColor,
                      ),
                    ),
                  ),
                );
              }
              return Expanded(
                child: GestureDetector(
                  onTap: () => controller.inputForgotOtpDigit(key),
                  child: Container(
                    height: 52.h,
                    margin: EdgeInsets.symmetric(horizontal: 4.w),
                    decoration: BoxDecoration(
                      color: inputBg,
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      key,
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                        color: textColor,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      }).toList(),
    );
  }
}
