// screens/profile/views/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:to_let_app_abandon/screens/Profile_screen/controller/profile-controller.dart';
import 'package:to_let_app_abandon/widgets/nav/nav_controller.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final navController = Get.find<NavController>();

    return Scaffold(
      bottomNavigationBar: navController.bottomNavBar,
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            // Header Bar
            _buildHeader(isDark),

            // Main Profile Body
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 600.w),
                    child: Column(
                      children: [
                        // User Info Card + Stats
                        Obx(() => _buildProfileCard(isDark)),
                        SizedBox(height: 16.h),

                        // Menu Options List
                        _buildMenuSection(isDark),
                        SizedBox(height: 16.h),

                        // Logout Button
                        _buildLogoutButton(isDark),
                        SizedBox(height: 20.h),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Bottom Navigation Bar
          ],
        ),
      ),
    );
  }

  // --- Header Bar ---
  Widget _buildHeader(bool isDark) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Text(
                AppStrings.profile,
                style: TextStyle(
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                ),
              ),
              SizedBox(width: 6.w),
            ],
          ),
        ],
      ),
    );
  }

  // --- Profile Summary & Stats Card ---
  Widget _buildProfileCard(bool isDark) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: isDark ? AppColors.dividerDark : AppColors.borderSubtle,
        ),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              Container(
                width: 64.r,
                height: 64.r,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                alignment: Alignment.center,
                child: Text(
                  controller.userName.value.isNotEmpty
                      ? controller.userName.value[0].toUpperCase()
                      : 'D',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: 14.w),

              // Name, Email & Verified Badge
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.userName.value,
                      style: TextStyle(
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.sp,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      controller.userEmail.value,
                      style: TextStyle(
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                        fontSize: 12.sp,
                      ),
                    ),
                    SizedBox(height: 8.h),

                    // Verified Chip
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.backgroundDark
                            : AppColors.scaffoldBg,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6.r,
                            height: 6.r,
                            decoration: const BoxDecoration(
                              color: AppColors.success,
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            AppStrings.verifiedDhaka,
                            style: TextStyle(
                              color: isDark
                                  ? AppColors.textPrimaryDark
                                  : AppColors.textPrimaryLight,
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Settings Gear
              GestureDetector(
                onTap: controller.navigateToSettings,
                child: Container(
                  width: 32.r,
                  height: 32.r,
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.backgroundDark
                        : AppColors.scaffoldBg,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.settings_outlined,
                    size: 18.r,
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          // 3 Stat Boxes
          Row(
            children: [
              Expanded(
                child: _buildStatBox(
                  controller.savedCount.value.toString(),
                  AppStrings.saved,
                  isDark,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: _buildStatBox(
                  controller.listingCount.value.toString(),
                  AppStrings.listing,
                  isDark,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: _buildStatBox(
                  controller.visitsCount.value.toString(),
                  AppStrings.visits,
                  isDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatBox(String count, String label, bool isDark) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.backgroundDark : AppColors.scaffoldBg,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark ? AppColors.dividerDark : AppColors.borderSubtle,
        ),
      ),
      child: Column(
        children: [
          Text(
            count,
            style: TextStyle(
              color: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
              fontWeight: FontWeight.bold,
              fontSize: 18.sp,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            label,
            style: TextStyle(
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
              fontSize: 10.sp,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  // --- Menu Section ---
  Widget _buildMenuSection(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: isDark ? AppColors.dividerDark : AppColors.borderSubtle,
        ),
      ),
      child: Column(
        children: [
          _buildMenuItem(
            icon: Icons.apartment_outlined,
            title: AppStrings.myListings,
            badgeText: AppStrings.oneActive,
            isDark: isDark,
            onTap: controller.navigateToMyListings,
          ),
          _buildDivider(isDark),
          _buildMenuItem(
            icon: Icons.calendar_today_outlined,
            title: AppStrings.scheduledVisits,
            badgeText: AppStrings.tomorrowTime,
            isDark: isDark,
            onTap: controller.navigateToScheduledVisits,
          ),
          _buildDivider(isDark),
          _buildMenuItem(
            icon: Icons.credit_card_outlined,
            title: AppStrings.payments,
            isDark: isDark,
            onTap: controller.navigateToPayments,
          ),
          _buildDivider(isDark),
          _buildMenuItem(
            icon: Icons.settings_outlined,
            title: AppStrings.settings,
            isDark: isDark,
            onTap: controller.navigateToSettings,
          ),
          _buildDivider(isDark),
          _buildMenuItem(
            icon: Icons.help_outline,
            title: AppStrings.helpSupport,
            isDark: isDark,
            onTap: controller.navigateToHelpSupport,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    String? badgeText,
    required bool isDark,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Row(
          children: [
            Container(
              width: 36.r,
              height: 36.r,
              decoration: BoxDecoration(
                color: isDark ? AppColors.backgroundDark : AppColors.scaffoldBg,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 18.r,
                color: isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimaryLight,
              ),
            ),
            SizedBox(width: 12.w),
            Text(
              title,
              style: TextStyle(
                color: isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimaryLight,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            if (badgeText != null) ...[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.backgroundDark
                      : AppColors.scaffoldBg,
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(
                    color: isDark
                        ? AppColors.dividerDark
                        : AppColors.borderSubtle,
                  ),
                ),
                child: Text(
                  badgeText,
                  style: TextStyle(
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
            ],
            Icon(
              Icons.chevron_right,
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
              size: 18.r,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider(bool isDark) {
    return Divider(
      height: 1,
      thickness: 1,
      indent: 16.w,
      endIndent: 16.w,
      color: isDark ? AppColors.dividerDark : AppColors.borderSubtle,
    );
  }

  // --- Logout Button ---
  Widget _buildLogoutButton(bool isDark) {
    return GestureDetector(
      onTap: controller.logout,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 14.h),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isDark ? AppColors.dividerDark : AppColors.borderSubtle,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.logout,
              color: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
              size: 18.r,
            ),
            SizedBox(width: 8.w),
            Text(
              AppStrings.logout,
              style: TextStyle(
                color: isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimaryLight,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Bottom Navigation Bar ---
}
