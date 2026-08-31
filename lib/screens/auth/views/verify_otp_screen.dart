import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../controllers/auth_controller.dart';
import '../widgets/custom_numpad.dart';

class VerifyOtpScreen extends GetView<AuthController> {
  const VerifyOtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final textColor = isDark ? Colors.white : const Color(0xFF1E232A);
    final subtitleColor =
        isDark ? const Color(0xFFA0AEC0) : const Color(0xFF7E8B9B);

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : const Color(0xFFFAF8F5),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Back Button
              GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  width: 38.r,
                  height: 38.r,
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E2228) : Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDark
                          ? const Color(0xFF2D3748)
                          : const Color(0xFFE8ECEF),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    Icons.arrow_back_rounded,
                    size: 20.r,
                    color: textColor,
                  ),
                ),
              ),
              SizedBox(height: 18.h),

              // 2. Mobile Phone Icon Badge
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
                      color: isDark
                          ? const Color(0xFF3B2824)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Icon(
                      Icons.smartphone_rounded,
                      color: const Color(0xFF4A5568),
                      size: 20.r,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.h),

              // 3. Title & Subtitle
              Text(
                'verify_number_title'.tr,
                style: TextStyle(
                  fontSize: 26.sp,
                  fontWeight: FontWeight.w900,
                  color: textColor,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                'we_sent_code'.tr,
                style: TextStyle(
                  fontSize: 13.5.sp,
                  fontWeight: FontWeight.w500,
                  color: subtitleColor,
                ),
              ),
              SizedBox(height: 6.h),

              // 4. Phone Number & Sent Badge Row
              Row(
                children: [
                  Obx(
                    () => Text(
                      controller.formattedMaskedPhone,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w800,
                        color: textColor,
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 3.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE2F4E9),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      'sent_status'.tr,
                      style: TextStyle(
                        fontSize: 10.5.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF2E7D32),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),

              // 5. 6 OTP Digit Boxes
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(6, (index) {
                    final isCurrent =
                        index == controller.currentOtpIndex.value;
                    final digit = controller.otpDigits[index];

                    return GestureDetector(
                      onTap: () => controller.selectOtpBox(index),
                      child: Container(
                        width: 44.w,
                        height: 52.h,
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF1E2228)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(14.r),
                          border: Border.all(
                            color: isCurrent
                                ? AppColors.primary
                                : (digit.isNotEmpty
                                    ? (isDark
                                        ? const Color(0xFF4A5568)
                                        : const Color(0xFFE2E8F0))
                                    : (isDark
                                        ? const Color(0xFF2D3748)
                                        : const Color(0xFFEBEFF4))),
                            width: isCurrent ? 1.8 : 1.2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(isDark ? 30 : 6),
                              blurRadius: 8.r,
                              offset: Offset(0, 2.h),
                            ),
                          ],
                        ),
                        child: Center(
                          child: digit.isNotEmpty
                              ? Text(
                                  digit,
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w800,
                                    color: textColor,
                                  ),
                                )
                              : (isCurrent
                                  ? Container(
                                      width: 2,
                                      height: 18.h,
                                      color: AppColors.primary,
                                    )
                                  : Text(
                                      '-',
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w700,
                                        color: subtitleColor.withAlpha(120),
                                      ),
                                    )),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              SizedBox(height: 18.h),

              // 6. Resend Timer Row
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${'resend_code_in'.tr}${controller.formattedTimer}',
                      style: TextStyle(
                        fontSize: 12.5.sp,
                        fontWeight: FontWeight.w600,
                        color: subtitleColor,
                      ),
                    ),
                    GestureDetector(
                      onTap: controller.canResend.value
                          ? controller.resendOtp
                          : null,
                      child: Text(
                        'resend'.tr,
                        style: TextStyle(
                          fontSize: 12.5.sp,
                          fontWeight: FontWeight.w700,
                          color: controller.canResend.value
                              ? AppColors.primary
                              : AppColors.primary.withAlpha(140),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),

              // 7. Verify & Continue Button
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  height: 52.h,
                  child: ElevatedButton(
                    onPressed: controller.isVerifyingOtp.value
                        ? null
                        : controller.verifyOtp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(26.r),
                      ),
                      elevation: 0,
                    ),
                    child: controller.isVerifyingOtp.value
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
                            'verify_continue_btn'.tr,
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

              // 8. Custom In-App Numpad
              CustomNumpad(
                onDigitTap: controller.inputOtpDigit,
                onDeleteTap: controller.deleteOtpDigit,
              ),
              SizedBox(height: 18.h),

              // 9. Footnote Security
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
                      'otp_security_note'.tr,
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w500,
                        color: subtitleColor,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12.h),
            ],
          ),
        ),
      ),
    );
  }
}
