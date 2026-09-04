import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../controllers/post_listing_controller.dart';

class AmenitiesSection extends GetView<PostListingController> {
  const AmenitiesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final labelColor =
        isDark ? const Color(0xFFA0AEC0) : const Color(0xFF8E9BAE);
    final textColor =
        isDark ? const Color(0xFFF7FAFC) : const Color(0xFF1E232A);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E2228) : Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 30 : 10),
            blurRadius: 16.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            'amenities_label'.tr,
            style: TextStyle(
              fontSize: 11.5.sp,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
              color: labelColor,
            ),
          ),
          SizedBox(height: 12.h),


          Obx(
            () => _buildSwitchRow(
              title: 'amenity_lift'.tr,
              value: controller.hasLift.value,
              onChanged: controller.toggleLift,
              textColor: textColor,
            ),
          ),
          SizedBox(height: 10.h),


          Obx(
            () => _buildSwitchRow(
              title: 'amenity_parking'.tr,
              value: controller.hasParking.value,
              onChanged: controller.toggleParking,
              textColor: textColor,
            ),
          ),
          SizedBox(height: 10.h),


          Obx(
            () => _buildSwitchRow(
              title: 'amenity_gas_line'.tr,
              value: controller.hasGasLine.value,
              onChanged: controller.toggleGasLine,
              textColor: textColor,
            ),
          ),
          SizedBox(height: 10.h),


          Obx(
            () => _buildSwitchRow(
              title: 'amenity_wifi'.tr,
              value: controller.hasWifi.value,
              onChanged: controller.toggleWifi,
              textColor: textColor,
            ),
          ),
          SizedBox(height: 16.h),


          GestureDetector(
            onTap: controller.toggleDirectOwner,
            behavior: HitTestBehavior.opaque,
            child: Row(
              children: [
                Obx(
                  () => Container(
                    width: 22.r,
                    height: 22.r,
                    decoration: BoxDecoration(
                      color: controller.isDirectOwner.value
                          ? (isDark
                              ? const Color(0xFF3B4452)
                              : const Color(0xFF1E232A))
                          : Colors.transparent,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: controller.isDirectOwner.value
                            ? (isDark
                                ? const Color(0xFF3B4452)
                                : const Color(0xFF1E232A))
                            : (isDark
                                ? const Color(0xFF718096)
                                : const Color(0xFFCBD5E0)),
                        width: 1.5,
                      ),
                    ),
                    child: controller.isDirectOwner.value
                        ? Icon(
                            Icons.check_rounded,
                            size: 14.r,
                            color: Colors.white,
                          )
                        : null,
                  ),
                ),
                SizedBox(width: 10.w),
                Text(
                  'no_brokerage_owner'.tr,
                  style: TextStyle(
                    fontSize: 13.5.sp,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchRow({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
    required Color textColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14.5.sp,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
        Transform.scale(
          scale: 0.85,
          child: CupertinoSwitch(
            value: value,
            activeTrackColor: AppColors.primary,
            thumbColor: Colors.white,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
