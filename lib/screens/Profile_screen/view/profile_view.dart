import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:to_let_app_abandon/widgets/nav/nav_controller.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedNavIndex = 3;
  bool _isDarkMode = false;
  
  // Accordion Expand States
  bool _isSettingsExpanded = false;
  bool _isHelpSupportExpanded = false;



  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark || _isDarkMode;
        final navController = Get.find<NavController>();


    return Scaffold(
      bottomNavigationBar: navController.bottomNavBar,
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, isDark),
            Expanded(
              child: SingleChildScrollView(
                
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 600.w),
                    child: Column(
                      children: [
                        _buildProfileCard(isDark),
                        SizedBox(height: 16.h),
                        _buildMenuSection(isDark),
                        SizedBox(height: 16.h),
                        _buildLogoutButton(isDark),
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

  // --- Header ---
  Widget _buildHeader(BuildContext context, bool isDark) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppStrings.profile,
            style: TextStyle(
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              fontWeight: FontWeight.bold,
              fontSize: 16.sp,
            ),
          ),
        ],
      ),
    );
  }

  // --- Profile Card ---
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
      child: Row(
        children: [
          Container(
            width: 64.r,
            height: 64.r,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(20.r),
            ),
            alignment: Alignment.center,
            child: Text(
              AppStrings.userName[0],
              style: TextStyle(
                color: Colors.white,
                fontSize: 26.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.userName,
                  style: TextStyle(
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.sp,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  AppStrings.userEmail,
                  style: TextStyle(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    fontSize: 12.sp,
                  ),
                ),
                SizedBox(height: 8.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.backgroundDark : AppColors.scaffoldBg,
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
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
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
          Container(
            width: 32.r,
            height: 32.r,
            decoration: BoxDecoration(
              color: isDark ? AppColors.backgroundDark : AppColors.scaffoldBg,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.settings_outlined,
              size: 18.r,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
          ),
        ],
      ),
    );
  }

  // --- Main Menu Section ---
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
          ),
          _buildDivider(isDark),
          _buildMenuItem(
            icon: Icons.language_outlined,
            title: AppStrings.language,
            trailingWidget: Row(
              children: [
                Text(
                  AppStrings.english,
                  style: TextStyle(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    fontSize: 13.sp,
                  ),
                ),
                SizedBox(width: 4.w),
                Icon(
                  Icons.arrow_drop_down,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  size: 18.r,
                ),
              ],
            ),
            isDark: isDark,
          ),
          _buildDivider(isDark),
          _buildMenuItem(
            icon: Icons.wb_sunny_outlined,
            title: AppStrings.darkMode,
            trailingWidget: Switch(
              value: _isDarkMode,
              onChanged: (val) => setState(() => _isDarkMode = val),
              activeColor: AppColors.primary,
            ),
            isDark: isDark,
          ),
          _buildDivider(isDark),

          // Animated Settings Dropdown
          _buildExpandableSettings(isDark),

          _buildDivider(isDark),

          // Animated Help & Support Dropdown
          _buildExpandableHelpSupport(isDark),
        ],
      ),
    );
  }

  // --- Settings Dropdown ---
  Widget _buildExpandableSettings(bool isDark) {
    return Column(
      children: [
        InkWell(
          onTap: () => setState(() => _isSettingsExpanded = !_isSettingsExpanded),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
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
                    Icons.settings_outlined,
                    size: 18.r,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                ),
                SizedBox(width: 12.w),
                Text(
                  AppStrings.settings,
                  style: TextStyle(
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                AnimatedRotation(
                  turns: _isSettingsExpanded ? 0.25 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: Icon(
                    Icons.chevron_right,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    size: 18.r,
                  ),
                ),
              ],
            ),
          ),
        ),
        AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: Container(
            padding: EdgeInsets.only(left: 48.w, right: 16.w, bottom: 8.h),
            child: Column(
              children: [
                _buildSubMenuItem(
                  icon: Icons.info_outline,
                  title: AppStrings.appVersion,
                  isDark: isDark,
                  trailingText: AppStrings.version,
                ),
                _buildSubMenuItem(icon: Icons.share_outlined, title: AppStrings.shareApp, isDark: isDark),
                _buildSubMenuItem(icon: Icons.star_border_outlined, title: AppStrings.rateApp, isDark: isDark),
                _buildSubMenuItem(icon: Icons.quiz_outlined, title: AppStrings.helpFaq, isDark: isDark),
                _buildSubMenuItem(icon: Icons.security_outlined, title: AppStrings.twoFactorAuth, isDark: isDark),
              ],
            ),
          ),
          crossFadeState: _isSettingsExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 300),
        ),
      ],
    );
  }

  // --- Help & Support Animated Dropdown ---
  Widget _buildExpandableHelpSupport(bool isDark) {
    return Column(
      children: [
        InkWell(
          onTap: () => setState(() => _isHelpSupportExpanded = !_isHelpSupportExpanded),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
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
                    Icons.help_outline,
                    size: 18.r,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                ),
                SizedBox(width: 12.w),
                Text(
                  AppStrings.helpSupport,
                  style: TextStyle(
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                AnimatedRotation(
                  turns: _isHelpSupportExpanded ? 0.25 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: Icon(
                    Icons.chevron_right,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    size: 18.r,
                  ),
                ),
              ],
            ),
          ),
        ),
        AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: Container(
            padding: EdgeInsets.all(12.r),
            margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: isDark ? AppColors.backgroundDark : AppColors.scaffoldBg,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Search & Title Header
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.howCanWeHelp,
                            style: TextStyle(
                              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            AppStrings.searchHelpSubtitle,
                            style: TextStyle(
                              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                              fontSize: 11.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    CircleAvatar(
                      radius: 14.r,
                      backgroundColor: Colors.red.withOpacity(0.08),
                      child: Icon(Icons.help_outline, size: 14.r, color: AppColors.primary),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),

                // Search Field
                TextField(
                  decoration: InputDecoration(
                    hintText: AppStrings.searchHelpHint,
                    hintStyle: TextStyle(
                      fontSize: 12.sp,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                    prefixIcon: Icon(Icons.search, size: 18.r, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                    contentPadding: EdgeInsets.symmetric(vertical: 0.h),
                    filled: true,
                    fillColor: isDark ? AppColors.surfaceDark : Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.r),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 16.h),

                // SECTION 1: CONTACT US
                _buildSectionHeader(AppStrings.contactUs, isDark),
                SizedBox(height: 8.h),
                _buildHelpItem(
                  icon: Icons.chat_bubble_outline,
                  title: AppStrings.chatWithSupport,
                  isDark: isDark,
                  badge: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 5.r,
                          height: 5.r,
                          decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                        ),
                        SizedBox(width: 4.w),
                        Text(AppStrings.online, style: TextStyle(color: Colors.green, fontSize: 10.sp, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
                _buildHelpItem(icon: Icons.phone_outlined, title: AppStrings.callUsNumber, isDark: isDark),
                _buildHelpItem(icon: Icons.email_outlined, title: AppStrings.emailSupport, isDark: isDark),
                _buildHelpItem(icon: Icons.messenger_outline, title: AppStrings.whatsAppSupport, isDark: isDark),

                SizedBox(height: 14.h),

                // SECTION 2: HELP TOPICS
                _buildSectionHeader(AppStrings.helpTopics, isDark),
                SizedBox(height: 8.h),
                _buildHelpItem(
                  icon: Icons.help_outline,
                  title: AppStrings.faqs,
                  subtitle: AppStrings.faqsCount,
                  isDark: isDark,
                ),
                _buildHelpItem(icon: Icons.assignment_outlined, title: AppStrings.howToPostListing, isDark: isDark),
                _buildHelpItem(icon: Icons.person_outline, title: AppStrings.howToContactOwner, isDark: isDark),
                _buildHelpItem(icon: Icons.credit_card_outlined, title: AppStrings.paymentAndFees, isDark: isDark),
                _buildHelpItem(icon: Icons.shield_outlined, title: AppStrings.safetyTips, isDark: isDark),

                SizedBox(height: 14.h),

                // SECTION 3: FEEDBACK & ISSUES
                _buildSectionHeader(AppStrings.feedbackIssues, isDark),
                SizedBox(height: 8.h),
                _buildHelpItem(icon: Icons.flag_outlined, title: AppStrings.reportAProblem, isDark: isDark),
                _buildHelpItem(icon: Icons.warning_amber_outlined, title: AppStrings.reportAListing, isDark: isDark),
                _buildHelpItem(icon: Icons.lightbulb_outline, title: AppStrings.requestAFeature, isDark: isDark),

                SizedBox(height: 14.h),

                // SECTION 4: LEGAL
                _buildSectionHeader(AppStrings.legal, isDark),
                SizedBox(height: 8.h),
                _buildHelpItem(icon: Icons.description_outlined, title: AppStrings.termsOfService, isDark: isDark),
                _buildHelpItem(icon: Icons.lock_outline, title: AppStrings.privacyPolicy, isDark: isDark),
                _buildHelpItem(icon: Icons.group_outlined, title: AppStrings.communityGuidelines, isDark: isDark),

                SizedBox(height: 16.h),

                // Footer Version Text
                Center(
                  child: Column(
                    children: [
                      Container(width: 30.w, height: 2.h, color: isDark ? AppColors.dividerDark : Colors.grey.shade300),
                      SizedBox(height: 6.h),
                      Text(
                        "App Version ${AppStrings.version}",
                        style: TextStyle(
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                          fontSize: 10.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          crossFadeState: _isHelpSupportExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 300),
        ),
      ],
    );
  }

  // Helper Widget for Section Headers
  Widget _buildSectionHeader(String title, bool isDark) {
    return Text(
      title,
      style: TextStyle(
        color: isDark ? AppColors.textSecondaryDark : Colors.grey.shade600,
        fontSize: 10.sp,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.8,
      ),
    );
  }

  // Helper Widget for Help Support List Item
  Widget _buildHelpItem({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? badge,
    required bool isDark,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 6.h),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 14.r,
            backgroundColor: Colors.red.withOpacity(0.06),
            child: Icon(icon, size: 14.r, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (subtitle != null) ...[
                  SizedBox(height: 1.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      fontSize: 10.sp,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (badge != null) ...[
            badge,
            SizedBox(width: 6.w),
          ],
          Icon(
            Icons.chevron_right,
            size: 14.r,
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
        ],
      ),
    );
  }

  // Helper Widget for Sub Settings Menu Item
  Widget _buildSubMenuItem({
    required IconData icon,
    required String title,
    required bool isDark,
    String? trailingText,
  }) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Row(
          children: [
            Icon(
              icon,
              size: 16.r,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textPrimaryLight,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (trailingText != null)
              Text(
                trailingText,
                style: TextStyle(
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.bold,
                ),
              )
            else
              Icon(
                Icons.chevron_right,
                size: 14.r,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    String? badgeText,
    Widget? trailingWidget,
    required bool isDark,
  }) {
    return Padding(
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
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
          ),
          SizedBox(width: 12.w),
          Text(
            title,
            style: TextStyle(
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          if (badgeText != null) ...[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: isDark ? AppColors.backgroundDark : AppColors.scaffoldBg,
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(
                  color: isDark ? AppColors.dividerDark : AppColors.borderSubtle,
                ),
              ),
              child: Text(
                badgeText,
                style: TextStyle(
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(width: 8.w),
          ],
          if (trailingWidget != null)
            trailingWidget
          else
            Icon(
              Icons.chevron_right,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              size: 18.r,
            ),
        ],
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

  Widget _buildLogoutButton(bool isDark) {
    return Container(
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
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            size: 18.r,
          ),
          SizedBox(width: 8.w),
          Text(
            AppStrings.logout,
            style: TextStyle(
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  




}