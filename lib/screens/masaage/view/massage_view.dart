// screens/masaage/views/massage_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
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
          backgroundColor: isDark ? AppColors.backgroundDark : AppColors.scaffoldBg,
          appBar: _buildAppBar(isDark),
          body: SafeArea(child: _buildBody(controller, isDark)),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(bool isDark) {
    return AppBar(
      backgroundColor: isDark ? AppColors.surfaceDark : Colors.transparent,
      elevation: 0,
      toolbarHeight: 56.h,
      leading: Padding(
        padding: EdgeInsets.all(8.r),
        child: CircleAvatar(
          radius: 18.r,
          backgroundColor: isDark ? AppColors.dividerDark : AppColors.borderSubtle,
          child: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              size: 20.r,
            ),
            onPressed: () => Get.find<MessagesController>().goBack(),
          ),
        ),
      ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Messages',
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
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Text(
              'v1.0',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      centerTitle: true,
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 16.w),
          child: CircleAvatar(
            radius: 18.r,
            backgroundColor: isDark ? AppColors.dividerDark : AppColors.borderSubtle,
            child: Icon(
              Icons.more_horiz,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              size: 20.r,
            ),
          ),
        ),
      ],
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
                color: isSelected ? Colors.white : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 13.sp,
              ),
            ),
            selected: isSelected,
            selectedColor: AppColors.primary,
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
                        backgroundColor: isDark ? AppColors.dividerDark : AppColors.primary,
                        radius: 24.r,
                        child: Icon(
                          Icons.check,
                          color: isDark ? AppColors.textPrimaryDark : Colors.white,
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
                        color: AppColors.error,
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
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                            fontWeight: FontWeight.bold,
                            fontSize: 14.sp,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        message.time,
                        style: TextStyle(
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    message.message,
                    style: TextStyle(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
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
                          color: isDark ? AppColors.dividerDark : AppColors.borderSubtle,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Text(
                          message.tag,
                          style: TextStyle(
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
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
                            color: AppColors.error,
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
                    'Need Help?',
                    style: TextStyle(
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Contact our support team',
                    style: TextStyle(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              size: 22.r,
            ),
          ],
        ),
      ),
    );
  }
}