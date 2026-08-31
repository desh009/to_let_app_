import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../controllers/auth_controller.dart';

class RegisterScreen extends GetView<AuthController> {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final inputBg = isDark ? const Color(0xFF1E2228) : const Color(0xFFF7F8FA);
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
              // 1. Top Back Button
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

              // 2. Title & Subtitle
              Text(
                'create_account_title'.tr,
                style: TextStyle(
                  fontSize: 26.sp,
                  fontWeight: FontWeight.w900,
                  color: textColor,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                'create_account_subtitle'.tr,
                style: TextStyle(
                  fontSize: 13.5.sp,
                  fontWeight: FontWeight.w500,
                  color: subtitleColor,
                ),
              ),
              SizedBox(height: 22.h),

              // 3. Field 1: Full Name
              _buildLabel('full_name'.tr, textColor),
              SizedBox(height: 8.h),
              _buildInputField(
                controller: controller.regFullNameController,
                inputBg: inputBg,
                textColor: textColor,
                subtitleColor: subtitleColor,
                hintText: 'full_name_hint'.tr,
                prefixIcon: Icon(
                  Icons.person_outline_rounded,
                  size: 18.r,
                  color: subtitleColor,
                ),
              ),
              SizedBox(height: 16.h),

              // 4. Field 2: Phone number (Active Terracotta Border)
              _buildLabel('phone_number'.tr, textColor),
              SizedBox(height: 8.h),
              Container(
                height: 52.h,
                padding: EdgeInsets.symmetric(horizontal: 14.w),
                decoration: BoxDecoration(
                  color: inputBg,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: AppColors.primary,
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      '+880',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: textColor,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Icon(
                      Icons.phone_android_rounded,
                      size: 18.r,
                      color: subtitleColor,
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: TextField(
                        controller: controller.regPhoneController,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          hintText: '1XXX XXX XXX',
                          hintStyle: TextStyle(
                            fontSize: 14.sp,
                            color: subtitleColor.withAlpha(150),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),

              // 5. Field 3: Email address
              _buildLabel('email_address'.tr, textColor),
              SizedBox(height: 8.h),
              _buildInputField(
                controller: controller.regEmailController,
                inputBg: inputBg,
                textColor: textColor,
                subtitleColor: subtitleColor,
                hintText: 'email_hint'.tr,
                prefixIcon: Icon(
                  Icons.mail_outline_rounded,
                  size: 18.r,
                  color: subtitleColor,
                ),
              ),
              SizedBox(height: 16.h),

              // 6. Field 4: Password & Strength Indicators
              _buildLabel('password'.tr, textColor),
              SizedBox(height: 8.h),
              _buildInputField(
                controller: controller.regPasswordController,
                inputBg: inputBg,
                textColor: textColor,
                subtitleColor: subtitleColor,
                hintText: 'password_min_chars'.tr,
                isPassword: true,
                prefixIcon: Icon(
                  Icons.lock_outline_rounded,
                  size: 18.r,
                  color: subtitleColor,
                ),
              ),
              SizedBox(height: 8.h),

              // Password Strength 4 Horizontal Bars
              Obx(
                () => Row(
                  children: List.generate(4, (index) {
                    final isFilled =
                        index < controller.passwordStrength.value;
                    return Expanded(
                      child: Container(
                        height: 3.5.h,
                        margin: EdgeInsets.only(right: index < 3 ? 6.w : 0),
                        decoration: BoxDecoration(
                          color: isFilled
                              ? AppColors.primary
                              : (isDark
                                  ? const Color(0xFF2D3748)
                                  : const Color(0xFFE2E8F0)),
                          borderRadius: BorderRadius.circular(2.r),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              SizedBox(height: 16.h),

              // 7. Field 5: Confirm Password
              _buildLabel('confirm_password'.tr, textColor),
              SizedBox(height: 8.h),
              _buildInputField(
                controller: controller.regConfirmPasswordController,
                inputBg: inputBg,
                textColor: textColor,
                subtitleColor: subtitleColor,
                hintText: 'reenter_password'.tr,
                isPassword: true,
                prefixIcon: Icon(
                  Icons.lock_outline_rounded,
                  size: 18.r,
                  color: subtitleColor,
                ),
              ),
              SizedBox(height: 18.h),

              // 8. Terms Checkbox & No Brokerage Badge
              Row(
                children: [
                  Obx(
                    () => GestureDetector(
                      onTap: () {
                        controller.isTermsAgreed.value =
                            !controller.isTermsAgreed.value;
                      },
                      child: Container(
                        width: 20.r,
                        height: 20.r,
                        decoration: BoxDecoration(
                          color: controller.isTermsAgreed.value
                              ? AppColors.primary
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(6.r),
                          border: Border.all(
                            color: controller.isTermsAgreed.value
                                ? AppColors.primary
                                : (isDark
                                    ? const Color(0xFF4A5568)
                                    : const Color(0xFFCBD5E0)),
                            width: 1.5,
                          ),
                        ),
                        child: controller.isTermsAgreed.value
                            ? Icon(
                                Icons.check_rounded,
                                size: 14.r,
                                color: Colors.white,
                              )
                            : null,
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'agree_terms'.tr,
                    style: TextStyle(
                      fontSize: 12.5.sp,
                      fontWeight: FontWeight.w500,
                      color: subtitleColor,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      'terms_privacy'.tr,
                      style: TextStyle(
                        fontSize: 12.5.sp,
                        fontWeight: FontWeight.w700,
                        decoration: TextDecoration.underline,
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
                      'No brokerage',
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

              // 9. CTA: Create Account Button
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  height: 52.h,
                  child: ElevatedButton(
                    onPressed: controller.isRegistering.value
                        ? null
                        : controller.register,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(26.r),
                      ),
                      elevation: 0,
                    ),
                    child: controller.isRegistering.value
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
                            'create_account_btn'.tr,
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ),
              SizedBox(height: 22.h),

              // 10. Footer: Already have an account? Log In
              Center(
                child: GestureDetector(
                  onTap: () => Get.back(),
                  child: RichText(
                    text: TextSpan(
                      text: 'already_have_account'.tr,
                      style: TextStyle(
                        fontSize: 13.5.sp,
                        fontWeight: FontWeight.w500,
                        color: subtitleColor,
                      ),
                      children: [
                        TextSpan(
                          text: 'log_in_btn'.tr,
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text, Color textColor) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 12.5.sp,
        fontWeight: FontWeight.w700,
        color: textColor,
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required Color inputBg,
    required Color textColor,
    required Color subtitleColor,
    required String hintText,
    Widget? prefixIcon,
    bool isPassword = false,
  }) {
    return Container(
      height: 52.h,
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      decoration: BoxDecoration(
        color: inputBg,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          if (prefixIcon != null) ...[
            prefixIcon,
            SizedBox(width: 10.w),
          ],
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: isPassword,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                isDense: true,
                hintText: hintText,
                hintStyle: TextStyle(
                  fontSize: 14.sp,
                  color: subtitleColor.withAlpha(150),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
