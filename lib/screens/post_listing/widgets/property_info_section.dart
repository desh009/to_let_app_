import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/post_listing_controller.dart';

class PropertyInfoSection extends GetView<PostListingController> {
  const PropertyInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final inputBg = isDark ? const Color(0xFF242930) : const Color(0xFFF7F8FA);
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
          _buildLabel('title_label'.tr, labelColor),
          SizedBox(height: 8.h),
          _buildInputField(
            controller: controller.titleController,
            inputBg: inputBg,
            textColor: textColor,
            hintText: '',
          ),
          SizedBox(height: 18.h),

          _buildLabel('post_location_label'.tr, labelColor),
          SizedBox(height: 8.h),
          _buildInputField(
            controller: controller.locationController,
            inputBg: inputBg,
            textColor: textColor,
            hintText: '',
            prefixIcon: Icon(
              Icons.location_on_outlined,
              color: labelColor,
              size: 20.r,
            ),
          ),
          SizedBox(height: 18.h),

          // 2.5 TENANT TYPE (Bachelor / Family / Seat / Sublet)
          _buildLabel('tenant_type_label'.tr, labelColor),
          SizedBox(height: 8.h),
          Obx(
            () => Row(
              children: controller.tenantTypes.map((type) {
                final isSelected = controller.selectedTenantType.value == type;
                final isLast = type == controller.tenantTypes.last;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => controller.selectTenantType(type),
                    child: Container(
                      margin: EdgeInsets.only(right: isLast ? 0 : 8.w),
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF1E232A) : inputBg,
                        borderRadius: BorderRadius.circular(14.r),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF1E232A)
                              : (isDark
                                  ? const Color(0xFF2D3748)
                                  : const Color(0xFFE2E8F0)),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          type,
                          style: TextStyle(
                            fontSize: 11.5.sp,
                            fontWeight: FontWeight.w700,
                            color: isSelected ? Colors.white : textColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          SizedBox(height: 18.h),

     // 3. MONTHLY RENT
_buildLabel('monthly_rent_label'.tr, labelColor),
SizedBox(height: 8.h),
Container(
  height: 52.h,
  padding: EdgeInsets.symmetric(horizontal: 14.w),
  decoration: BoxDecoration(
    border: Border.all(
      color: isDark
          ? const Color(0xFF4A5568)
          : const Color(0xFFE2E8F0),
      width: 1.2,
    ),
  ),
  child: Row(
    children: [
      Text(
        '৳ ',
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.w700,
          color: textColor,
        ),
      ),
      Expanded(
        child: TextField(
          controller: controller.rentController,
          keyboardType: TextInputType.number,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: textColor,
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            focusedErrorBorder: InputBorder.none,
            isDense: true,
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ),
      Text(
        'month_suffix'.tr,
        style: TextStyle(
          fontSize: 11.5.sp,
          fontWeight: FontWeight.w600,
          color: isDark
              ? const Color(0xFFA0AEC0)
              : const Color(0xFF5A6A7D),
        ),
      ),
    ],
  ),
),
SizedBox(height: 18.h),

          // 4. BEDROOMS / ROOMS & BATHROOMS Row
          Obx(() {
            final isBachelorOrSeat =
                controller.selectedTenantType.value == 'Bachelor' ||
                    controller.selectedTenantType.value == 'Seat';
            final roomLabel = isBachelorOrSeat ? 'ROOM' : 'bedrooms_label'.tr;
            final unitLabel = isBachelorOrSeat ? 'Room' : 'bhk'.tr;

            return Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel(roomLabel, labelColor),
                      SizedBox(height: 8.h),
                      _buildCounterBox(
                        context,
                        isDark: isDark,
                        inputBg: inputBg,
                        textColor: textColor,
                        unitLabel: unitLabel,
                        rxValue: controller.bedrooms,
                        onDecrement: controller.decrementBedrooms,
                        onIncrement: controller.incrementBedrooms,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel('bathrooms_label'.tr, labelColor),
                      SizedBox(height: 8.h),
                      _buildCounterBox(
                        context,
                        isDark: isDark,
                        inputBg: inputBg,
                        textColor: textColor,
                        unitLabel: 'bath'.tr,
                        rxValue: controller.bathrooms,
                        onDecrement: controller.decrementBathrooms,
                        onIncrement: controller.incrementBathrooms,
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
          SizedBox(height: 18.h),

          // 5. DESCRIPTION
          _buildLabel('description_label'.tr, labelColor),
          SizedBox(height: 8.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: inputBg,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: TextField(
              controller: controller.descriptionController,
              maxLines: 5,
              minLines: 5,
              style: TextStyle(
                fontSize: 13.sp,
                height: 1.4,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
                hintText: 'description_hint'.tr,
                hintStyle: TextStyle(
                  fontSize: 13.sp,
                  color: labelColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text, Color color) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 11.5.sp,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.8,
        color: color,
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required Color inputBg,
    required Color textColor,
    required String hintText,
    Widget? prefixIcon,
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
            SizedBox(width: 8.w),
          ],
          Expanded(
            child: TextField(
              controller: controller,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                isDense: true,
                hintText: hintText.isEmpty ? null : hintText,
                hintStyle: TextStyle(
                  fontSize: 14.sp,
                  color: textColor.withAlpha(120),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCounterBox(
    BuildContext context, {
    required bool isDark,
    required Color inputBg,
    required Color textColor,
    required String unitLabel,
    required RxInt rxValue,
    required VoidCallback onDecrement,
    required VoidCallback onIncrement,
  }) {
    return Container(
      height: 56.h,
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      decoration: BoxDecoration(
        color: inputBg,
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: onDecrement,
            child: Container(
              width: 32.r,
              height: 32.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDark ? const Color(0xFF1E2228) : Colors.white,
                border: Border.all(
                  color: isDark
                      ? const Color(0xFF4A5568)
                      : const Color(0xFFE2E8F0),
                  width: 1.2,
                ),
              ),
              child: Icon(
                Icons.remove_rounded,
                size: 16.r,
                color: textColor,
              ),
            ),
          ),
          Obx(
            () => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${rxValue.value}',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w800,
                    color: textColor,
                    height: 1.0,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  unitLabel,
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                    height: 1.0,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onIncrement,
            child: Container(
              width: 32.r,
              height: 32.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDark ? const Color(0xFF3B4452) : const Color(0xFF1E232A),
              ),
              child: Icon(
                Icons.add_rounded,
                size: 16.r,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}