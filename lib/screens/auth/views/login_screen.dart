import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../routes/app_routes.dart';
import '../controllers/auth_controller.dart';

class LoginScreen extends GetView<AuthController> {
  const LoginScreen({super.key});

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
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10.h),

              // 1. App Icon Badge (Terracotta Home)
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
                      Icons.home_rounded,
                      color: Colors.white,
                      size: 20.r,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24.h),

              // 2. Title & Subtitle
              Text(
                'login_title'.tr,
                style: TextStyle(
                  fontSize: 26.sp,
                  fontWeight: FontWeight.w900,
                  color: textColor,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                'login_subtitle'.tr,
                style: TextStyle(
                  fontSize: 13.5.sp,
                  fontWeight: FontWeight.w500,
                  color: subtitleColor,
                ),
              ),
              SizedBox(height: 28.h),

              // 3. Field: Phone / Email
              Text(
                'phone_or_email'.tr,
                style: TextStyle(
                  fontSize: 12.5.sp,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
              ),
              SizedBox(height: 8.h),
              Container(
                height: 52.h,
                padding: EdgeInsets.symmetric(horizontal: 14.w),
                decoration: BoxDecoration(
                  color: inputBg,
                  borderRadius: BorderRadius.circular(16.r),
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
                        controller: controller.loginPhoneOrEmailController,
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
              SizedBox(height: 18.h),

              // 4. Field: Password
              Text(
                'password'.tr,
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
                      Icon(
                        Icons.lock_outline_rounded,
                        size: 18.r,
                        color: subtitleColor,
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: TextField(
                          controller: controller.loginPasswordController,
                          obscureText: controller.isLoginPasswordHidden.value,
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
                        onTap: () {
                          controller.isLoginPasswordHidden.value =
                              !controller.isLoginPasswordHidden.value;
                        },
                        child: Icon(
                          controller.isLoginPasswordHidden.value
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

              // 5. Forgot Password
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () => Get.toNamed(Routes.FORGOT_PASSWORD),
                  child: Text(
                    'forgot_password'.tr,
                    style: TextStyle(
                      fontSize: 12.5.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24.h),

              // 6. Log In Button
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  height: 52.h,
                  child: ElevatedButton(
                    onPressed:
                        controller.isLoggingIn.value ? null : controller.login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(26.r),
                      ),
                      elevation: 0,
                    ),
                    child: controller.isLoggingIn.value
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
                            'log_in_btn'.tr,
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ),
              SizedBox(height: 28.h),

              // 7. OR CONTINUE WITH Divider
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: isDark
                          ? const Color(0xFF2D3748)
                          : const Color(0xFFE2E8F0),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: Text(
                      'or_continue_with'.tr,
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                        color: subtitleColor,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: isDark
                          ? const Color(0xFF2D3748)
                          : const Color(0xFFE2E8F0),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),

              // 8. Social Login Buttons (Google & Apple)
              Row(
                children: [
                  // Google
                  Expanded(
                    child: _buildSocialButton(
                      context,
                      icon: Container(
                        width: 18.r,
                        height: 18.r,
                        alignment: Alignment.center,
                        child: Text(
                          'G',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w900,
                            color: const Color(0xFF4285F4),
                          ),
                        ),
                      ),
                      label: 'google'.tr,
                      onTap: () => controller.socialLogin('Google'),
                      isDark: isDark,
                    ),
                  ),
                  SizedBox(width: 14.w),

                  // Apple
                  Expanded(
                    child: _buildSocialButton(
                      context,
                      icon: Icon(
                        Icons.apple,
                        size: 20.r,
                        color: textColor,
                      ),
                      label: 'apple'.tr,
                      onTap: () => controller.socialLogin('Apple'),
                      isDark: isDark,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 36.h),

              // 9. Sign Up Navigation Link
              Center(
                child: GestureDetector(
                  onTap: () => Get.toNamed(Routes.REGISTER),
                  child: RichText(
                    text: TextSpan(
                      text: 'dont_have_account'.tr,
                      style: TextStyle(
                        fontSize: 13.5.sp,
                        fontWeight: FontWeight.w500,
                        color: subtitleColor,
                      ),
                      children: [
                        TextSpan(
                          text: 'sign_up'.tr,
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
              SizedBox(height: 16.h),

              // 10. Footnote Security
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
                      'auth_security_note'.tr,
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
        ),
      ),
    );
  }

  Widget _buildSocialButton(
    BuildContext context, {
    required Widget icon,
    required String label,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return Material(
      color: isDark ? const Color(0xFF1E2228) : Colors.white,
      borderRadius: BorderRadius.circular(16.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          height: 48.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: isDark
                  ? const Color(0xFF2D3748)
                  : const Color(0xFFE2E8F0),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              SizedBox(width: 8.w),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13.5.sp,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : const Color(0xFF1E232A),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
