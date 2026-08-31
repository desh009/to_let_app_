import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../controllers/post_listing_controller.dart';

class PublishBottomBar extends GetView<PostListingController> {
  const PublishBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Publish Button
        Obx(
          () => SizedBox(
            width: double.infinity,
            height: 56.h,
            child: ElevatedButton(
              onPressed: controller.isSubmitting.value
                  ? null
                  : controller.publishListing,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                disabledBackgroundColor: AppColors.primary.withAlpha(150),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.r),
                ),
                elevation: 0,
                shadowColor: Colors.transparent,
              ),
              child: controller.isSubmitting.value
                  ? SizedBox(
                      width: 24.r,
                      height: 24.r,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'publish_listing_btn'.tr,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Container(
                          width: 28.r,
                          height: 28.r,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withAlpha(50),
                          ),
                          child: Icon(
                            Icons.north_east_rounded,
                            size: 16.r,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
        SizedBox(height: 12.h),

        // Subtext / Terms Info
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Text(
            'publish_review_notice'.tr,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10.5.sp,
              height: 1.4,
              fontWeight: FontWeight.w500,
              color: isDark
                  ? const Color(0xFFA0AEC0)
                  : const Color(0xFF7E8B9B),
            ),
          ),
        ),
      ],
    );
  }
}
