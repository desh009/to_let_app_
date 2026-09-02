import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../controllers/post_listing_controller.dart';
import '../widgets/amenities_section.dart';
import '../widgets/photo_picker_section.dart';
import '../widgets/property_info_section.dart';
import '../widgets/publish_bottom_bar.dart';

class PostListingScreen extends GetView<PostListingController> {
  const PostListingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : const Color(0xFFFAF8F5),
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.backgroundDark : const Color(0xFFFAF8F5),
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: Padding(
          padding: EdgeInsets.only(left: 14.w),
          child: Center(
            child: GestureDetector(
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
                  color: isDark ? Colors.white : const Color(0xFF1E232A),
                ),
              ),
            ),
          ),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'post_listing_title'.tr,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : const Color(0xFF1E232A),
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 14.w),
            child: Center(
              child: PopupMenuButton<String>(
                offset: Offset(0, 44.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.r),
                ),
                onSelected: (value) {
                  if (value == 'reset') {
                    controller.resetForm();
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem<String>(
                    value: 'reset',
                    child: Row(
                      children: [
                        Icon(
                          Icons.refresh_rounded,
                          size: 18.r,
                          color: Colors.redAccent,
                        ),
                        SizedBox(width: 8.w),
                        Text('reset'.tr),
                      ],
                    ),
                  ),
                ],
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
                    Icons.more_horiz_rounded,
                    size: 20.r,
                    color: isDark ? Colors.white : const Color(0xFF1E232A),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Property Photos Card
              const PhotoPickerSection(),
              SizedBox(height: 16.h),

              // 2. Form Details Card (Title, Location, Rent, Rooms, Desc)
              const PropertyInfoSection(),
              SizedBox(height: 16.h),

              // 3. Amenities Card (Lift, Parking, Gas, Wifi, Direct Owner)
              const AmenitiesSection(),
              SizedBox(height: 24.h),

              // 4. Publish Button & Review Notes
              const PublishBottomBar(),
              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }
}
