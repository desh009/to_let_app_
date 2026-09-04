import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:to_let_app_abandon/app/two_factor_contoller_addtion/two_factor_controller_addition.dart';
import 'package:to_let_app_abandon/screens/auth/controllers/auth_controller.dart';
import '../../../core/constants/app_colors.dart';

class TwoFactorAuthScreen extends GetView<AuthController> {
  const TwoFactorAuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final inputBg = isDark ? const Color(0xFF1E2228) : const Color(0xFFF7F8FA);
    final textColor = isDark ? Colors.white : const Color(0xFF1E232A);
    final subtitleColor =
        isDark ? const Color(0xFFA0AEC0) : const Color(0xFF7E8B9B);


    controller.fetchTwoFactorStatus();

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.backgroundDark : const Color(0xFFFAF8F5),
      body: SafeArea(
        child: Obx(
          () => controller.isTwoFactorSetupStep2.value
              ? _buildOtpStep(context, isDark, textColor, subtitleColor, inputBg)
              : _buildToggleStep(context, isDark, textColor, subtitleColor, inputBg),
        ),
      ),
    );
  }


  Widget _buildToggleStep(
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


          Container(
            width: 48.r,
            height: 48.r,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1C2B1F) : const Color(0xFFEDF7ED),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: Colors.green.withAlpha(80), width: 1.5),
            ),
            child: Center(
              child: Container(
                width: 32.r,
                height: 32.r,
                decoration: BoxDecoration(
                  color: Colors.green.shade500,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(Icons.security_rounded, color: Colors.white, size: 20.r),
              ),
            ),
          ),
          SizedBox(height: 24.h),

          Text(
            'Two-Factor Authentication',
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.w900,
              color: textColor,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'Add an extra layer of security to your account. '
            'We\'ll ask for a one-time code sent to your phone or email '
            'whenever you log in from a new device.',
            style: TextStyle(
              fontSize: 13.5.sp,
              fontWeight: FontWeight.w500,
              color: subtitleColor,
              height: 1.5,
            ),
          ),
          SizedBox(height: 28.h),


          Obx(
            () => Container(
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: inputBg,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Row(
                children: [
                  Icon(
                    controller.isTwoFactorEnabled.value
                        ? Icons.verified_user_rounded
                        : Icons.gpp_maybe_outlined,
                    color: controller.isTwoFactorEnabled.value
                        ? Colors.green
                        : subtitleColor,
                    size: 22.r,
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.isTwoFactorEnabled.value
                              ? 'Enabled'
                              : 'Disabled',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            color: textColor,
                          ),
                        ),
                        Text(
                          controller.isTwoFactorEnabled.value
                              ? 'Your account is protected.'
                              : 'Turn on for better protection.',
                          style: TextStyle(fontSize: 11.5.sp, color: subtitleColor),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: controller.isTwoFactorEnabled.value,
                    activeColor: AppColors.primary,
                    onChanged: (val) {
                      if (val) {
                        controller.sendTwoFactorOtp();
                      } else {
                        _confirmDisable(context, isDark, textColor, subtitleColor);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20.h),


          Obx(
            () => controller.isTwoFactorEnabled.value
                ? const SizedBox.shrink()
                : SizedBox(
                    width: double.infinity,
                    height: 52.h,
                    child: ElevatedButton(
                      onPressed: controller.isSendingTwoFactorOtp.value
                          ? null
                          : controller.sendTwoFactorOtp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(26.r),
                        ),
                        elevation: 0,
                      ),
                      child: controller.isSendingTwoFactorOtp.value
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
                              'Enable Two-Factor Authentication',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  void _confirmDisable(
    BuildContext context,
    bool isDark,
    Color textColor,
    Color subtitleColor,
  ) {
    Get.dialog(
      AlertDialog(
        backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        title: Text('Disable 2FA?', style: TextStyle(color: textColor)),
        content: Text(
          'Your account will be less secure without two-factor authentication. Continue?',
          style: TextStyle(color: subtitleColor, fontSize: 13.sp),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.disableTwoFactor();
            },
            child: const Text('Disable', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }


  Widget _buildOtpStep(
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

          GestureDetector(
            onTap: () => controller.isTwoFactorSetupStep2.value = false,
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

          Text(
            'Verify It\'s You',
            style: TextStyle(
              fontSize: 26.sp,
              fontWeight: FontWeight.w900,
              color: textColor,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'Enter the 6-digit code we sent to confirm and turn on '
            'two-factor authentication.',
            style: TextStyle(
              fontSize: 13.5.sp,
              fontWeight: FontWeight.w500,
              color: subtitleColor,
            ),
          ),
          SizedBox(height: 32.h),


          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(6, (i) {
                final filled = i < controller.twoFactorOtpDigits.length &&
                    controller.twoFactorOtpDigits[i].isNotEmpty;
                final isActive = i == controller.currentTwoFactorOtpIndex.value;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 44.r,
                  height: 52.r,
                  decoration: BoxDecoration(
                    color: isActive ? AppColors.primary.withAlpha(15) : inputBg,
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
                          ? Container(width: 2, height: 22.h, color: AppColors.primary)
                          : const SizedBox.shrink()),
                );
              }),
            ),
          ),
          SizedBox(height: 28.h),

          _buildNumpad(textColor, subtitleColor, inputBg),
          SizedBox(height: 20.h),

          Obx(
            () => Center(
              child: controller.canResendTwoFactorOtp.value
                  ? GestureDetector(
                      onTap: controller.resendTwoFactorOtp,
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
                        style: TextStyle(fontSize: 13.sp, color: subtitleColor),
                        children: [
                          TextSpan(
                            text: controller.formattedTwoFactorTimer,
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
          SizedBox(height: 20.h),

          Obx(
            () => controller.isVerifyingTwoFactorOtp.value
                ? Center(
                    child: SizedBox(
                      width: 22.r,
                      height: 22.r,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(AppColors.primary),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
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
                    onTap: controller.deleteTwoFactorOtpDigit,
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
                  onTap: () => controller.inputTwoFactorOtpDigit(key),
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