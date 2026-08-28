import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:to_let_app_abandon/core/constants/app_colors.dart';
import 'package:to_let_app_abandon/core/constants/app_strings.dart';
import 'package:to_let_app_abandon/screens/masaage/controller/massage_controller.dart';


class ChatDetailScreen extends StatelessWidget {
  final MessageTileData message;

  const ChatDetailScreen({super.key, required this.message});

  void _handleBack(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            _buildHeader(context, isDark),
            
            // Main Chat Area
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 600.w), // Tablet responsiveness
                    child: Column(
                      children: [
                        SizedBox(height: 12.h),
                        
                        // Property Info Card
                        _buildPropertyCard(isDark),
                        
                        SizedBox(height: 16.h),
                        
                        // Date Divider
                        _buildDateDivider(isDark),
                        
                        SizedBox(height: 16.h),
                        
                        // Chat Messages
                        _buildReceivedBubble(
                          message: message.message,
                          time: message.time,
                          isDark: isDark,
                        ),
                        SizedBox(height: 12.h),
                        
                        _buildSentBubble(
                          message: "Hello, is it available for tomorrow? I'd love to check it out.",
                          time: "10:26 AM",
                          isDark: isDark,
                        ),
                        SizedBox(height: 12.h),
                        
                        _buildReceivedBubble(
                          message: "Yes, available for visit tomorrow? Let me know time that works for you.",
                          time: "",
                          isDark: isDark,
                        ),
                        SizedBox(height: 16.h),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Bottom Input Field
            _buildBottomInputArea(isDark),
          ],
        ),
      ),
    );
  }

  // --- Header Bar ---
  Widget _buildHeader(BuildContext context, bool isDark) {
    final displayName = message.isSystem ? message.title : message.title;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      color: isDark ? AppColors.surfaceDark : Colors.transparent,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () => _handleBack(context),
                constraints: const BoxConstraints(),
                padding: EdgeInsets.zero,
                icon: Container(
                  width: 36.r,
                  height: 36.r,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDark ? AppColors.dividerDark : AppColors.borderSubtle,
                  ),
                  child: Icon(
                    Icons.arrow_back,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    size: 20.r,
                  ),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    displayName,
                    style: TextStyle(
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: AppColors.darkCharcoal,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      AppStrings.version,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              CircleAvatar(
                radius: 18.r,
                backgroundColor: isDark ? AppColors.dividerDark : AppColors.borderSubtle,
                child: Icon(
                  Icons.more_horiz,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  size: 20.r,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),

          // Receiver Info
          Row(
            children: [
              CircleAvatar(
                radius: 20.r,
                backgroundColor: isDark ? AppColors.dividerDark : AppColors.borderSubtle,
                backgroundImage: message.avatar != null
                    ? NetworkImage(message.avatar!)
                    : null,
                child: message.avatar == null
                    ? Icon(
                        message.isSystem ? Icons.check : Icons.person,
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                        size: 20.r,
                      )
                    : null,
              ),
              SizedBox(width: 10.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayName,
                    style: TextStyle(
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      fontWeight: FontWeight.bold,
                      fontSize: 15.sp,
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        width: 6.r,
                        height: 6.r,
                        decoration: const BoxDecoration(
                          color: AppColors.success,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        AppStrings.ownerOnline,
                        style: TextStyle(
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              CircleAvatar(
                radius: 18.r,
                backgroundColor: isDark ? AppColors.dividerDark : AppColors.borderSubtle,
                child: Icon(
                  Icons.phone_outlined,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  size: 18.r,
                ),
              ),
              SizedBox(width: 8.w),
              CircleAvatar(
                radius: 18.r,
                backgroundColor: isDark ? AppColors.dividerDark : AppColors.borderSubtle,
                child: Icon(
                  Icons.more_horiz,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  size: 18.r,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- Property Card ---
  Widget _buildPropertyCard(bool isDark) {
    return Container(
      padding: EdgeInsets.all(10.r),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.cardBg,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark ? AppColors.dividerDark : AppColors.borderSubtle,
        ),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: Image.network(
              'https://picsum.photos/200/200',
              width: 54.r,
              height: 54.r,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message.tag,
                  style: TextStyle(
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    fontWeight: FontWeight.bold,
                    fontSize: 13.sp,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2.h),
                Text(
                  AppStrings.defaultPropertySpecs,
                  style: TextStyle(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    fontSize: 11.sp,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  AppStrings.defaultPropertyPrice,
                  style: TextStyle(
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    fontWeight: FontWeight.bold,
                    fontSize: 13.sp,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.darkCharcoal,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
            ),
            child: Text(
              AppStrings.view,
              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  // --- Date Divider ---
  Widget _buildDateDivider(bool isDark) {
    return Center(
      child: Text(
        "${AppStrings.today} • ${message.time.isNotEmpty ? message.time : '10:24 AM'}",
        style: TextStyle(
          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          fontSize: 11.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  // --- Received Bubble ---
  Widget _buildReceivedBubble({
    required String message,
    required String time,
    required bool isDark,
  }) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(maxWidth: 0.75.sw),
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.r),
            topRight: Radius.circular(16.r),
            bottomRight: Radius.circular(16.r),
            bottomLeft: Radius.circular(4.r),
          ),
          border: Border.all(
            color: isDark ? AppColors.dividerDark : AppColors.borderSubtle,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message,
              style: TextStyle(
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                fontSize: 13.sp,
              ),
            ),
            if (time.isNotEmpty) ...[
              SizedBox(height: 4.h),
              Text(
                time,
                style: TextStyle(
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  fontSize: 10.sp,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // --- Sent Bubble ---
  Widget _buildSentBubble({
    required String message,
    required String time,
    required bool isDark,
  }) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        constraints: BoxConstraints(maxWidth: 0.75.sw),
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.r),
            topRight: Radius.circular(16.r),
            bottomLeft: Radius.circular(16.r),
            bottomRight: Radius.circular(4.r),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              message,
              style: TextStyle(
                color: Colors.white,
                fontSize: 13.sp,
              ),
            ),
            SizedBox(height: 4.h),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  time,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 10.sp,
                  ),
                ),
                SizedBox(width: 4.w),
                Icon(
                  Icons.done_all,
                  color: Colors.white.withOpacity(0.8),
                  size: 14.r,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --- Bottom Input Bar ---
  Widget _buildBottomInputArea(bool isDark) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      color: isDark ? AppColors.surfaceDark : Colors.white,
      child: Row(
        children: [
          CircleAvatar(
            radius: 18.r,
            backgroundColor: isDark ? AppColors.dividerDark : AppColors.scaffoldBg,
            child: Icon(
              Icons.attach_file,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              size: 20.r,
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              decoration: BoxDecoration(
                color: isDark ? AppColors.backgroundDark : AppColors.scaffoldBg,
                borderRadius: BorderRadius.circular(24.r),
              ),
              child: TextField(
                style: TextStyle(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  fontSize: 13.sp,
                ),
                decoration: InputDecoration(
                  hintText: AppStrings.messageUserHint(message.title),
                  hintStyle: TextStyle(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    fontSize: 13.sp,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          SizedBox(width: 8.w),
          CircleAvatar(
            radius: 20.r,
            backgroundColor: AppColors.primary,
            child: Icon(
              Icons.send,
              color: Colors.white,
              size: 18.r,
            ),
          ),
        ],
      ),
    );
  }
}