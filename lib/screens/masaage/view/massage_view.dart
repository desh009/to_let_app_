// screens/masaage/views/massage_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../controller/massage_controller.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});



  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    Get.put(MessagesController(), permanent: false);

    return GetBuilder<MessagesController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: isDark
              ? AppColors.backgroundDark
              : AppColors.scaffoldBg,
          body: SafeArea(
            child: Column(
              children: [
                // Custom Header (AppBar-এর বদলে Custom Header)
                _buildCustomHeader(context, isDark),

                // Content Body
                Expanded(child: _buildBody(controller, isDark)),
              ],
            ),
          ),
        );
      },
    );
  }




  Widget _buildCustomHeader(BuildContext context, bool isDark) {
    return Container(
      height: 56.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      color: isDark ? AppColors.surfaceDark : Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Back Button

          // Title & Version Tag
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppStrings.messages,
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

          // More Options Button
        ],
      ),
    );
  }



  Widget _buildBody(MessagesController controller, bool isDark) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 600.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 12.h),
              _buildFilterChips(controller, isDark),
              SizedBox(height: 16.h),
              ...controller.filteredMessages.map(
                (message) => _buildMessageTile(controller, message, isDark),
              ),
              SizedBox(height: 8.h),
              _buildSupportCard(controller, isDark),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }



  Widget _buildFilterChips(MessagesController controller, bool isDark) {
    return Obx(
      () => Wrap(
        spacing: 8.w,
        runSpacing: 8.h,
        children: List.generate(controller.tabs.length, (index) {
          final isSelected = controller.selectedTabIndex.value == index;
          return ChoiceChip(
            label: Text(
              controller.tabs[index],
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : (isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimaryLight),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 13.sp,
              ),
            ),
            selected: isSelected,
            selectedColor: AppColors.darkCharcoal,
            backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
            shape: StadiumBorder(
              side: BorderSide(
                color: isSelected
                    ? Colors.transparent
                    : (isDark ? AppColors.dividerDark : AppColors.borderSubtle),
              ),
            ),
            onSelected: (selected) {
              controller.changeTab(index);
            },
          );
        }),
      ),
    );
  }



  Widget _buildMessageTile(
    MessagesController controller,
    MessageTileData message,
    bool isDark,
  ) {
    return GestureDetector(
      onTap: () => controller.navigateToMessageDetail(message),
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: (isDark ? Colors.white : Colors.black).withOpacity(0.05),
              spreadRadius: 2,
              blurRadius: 8.r,
              offset: Offset(0, 2.h),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                message.isSystem
                    ? CircleAvatar(
                        backgroundColor: AppColors.darkCharcoal,
                        radius: 24.r,
                        child: Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 20.r,
                        ),
                      )
                    : CircleAvatar(
                        backgroundImage: NetworkImage(message.avatar!),
                        radius: 24.r,
                      ),
                if (message.badgeCount != null)
                  Positioned(
                    top: -2.h,
                    right: -2.w,
                    child: Container(
                      padding: EdgeInsets.all(4.r),
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      constraints: BoxConstraints(
                        minWidth: 16.r,
                        minHeight: 16.r,
                      ),
                      child: Text(
                        message.badgeCount!,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          message.title,
                          style: TextStyle(
                            color: isDark
                                ? AppColors.textPrimaryDark
                                : AppColors.textPrimaryLight,
                            fontWeight: FontWeight.bold,
                            fontSize: 14.sp,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        message.time,
                        style: TextStyle(
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    message.message,
                    style: TextStyle(
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                      fontSize: 13.sp,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.dividerDark
                              : AppColors.scaffoldBg,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Text(
                          message.tag,
                          style: TextStyle(
                            color: isDark
                                ? AppColors.textPrimaryDark
                                : AppColors.textPrimaryLight,
                            fontSize: 11.sp,
                          ),
                        ),
                      ),
                      if (message.showDot) ...[
                        SizedBox(width: 8.w),
                        Container(
                          width: 6.r,
                          height: 6.r,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSupportCard(MessagesController controller, bool isDark) {
    return GestureDetector(
      onTap: controller.navigateToSupport,
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isDark ? AppColors.dividerDark : AppColors.borderSubtle,
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20.r,
              backgroundColor: AppColors.primaryLight,
              child: Icon(
                Icons.call_outlined,
                color: AppColors.primary,
                size: 20.r,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.needHelp,
                    style: TextStyle(
                      color: isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimaryLight,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    AppStrings.contactSupport,
                    style: TextStyle(
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
              size: 22.r,
            ),
          ],
        ),
      ),
    );
  }
}
