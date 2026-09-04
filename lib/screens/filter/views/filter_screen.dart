import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../widgets/location_picker_bottom_sheet.dart';
import '../controllers/filter_controller.dart';

class FilterScreen extends GetView<FilterController> {
  const FilterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [

            _buildAppBar(context, isDark),


            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    _buildSubLocationChip(context, isDark),

                    SizedBox(height: 20.h),


                    _buildPriceRangeSection(isDark),

                    SizedBox(height: 24.h),


                    _buildPropertyTypeSection(isDark),

                    SizedBox(height: 24.h),


                    Obx(() {
                      if (controller.selectedPropertyType.value == 'Bachelor') {
                        return Column(
                          children: [
                            _buildBachelorGenderSection(isDark),
                            SizedBox(height: 24.h),
                          ],
                        );
                      }
                      return const SizedBox.shrink();
                    }),


                    _buildBedroomsSection(isDark),

                    SizedBox(height: 24.h),


                    Obx(() {
                      if (controller.selectedPropertyType.value == 'Family') {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildFurnishingSection(isDark),
                            SizedBox(height: 24.h),
                            _buildAmenitiesSection(isDark),
                            SizedBox(height: 24.h),
                          ],
                        );
                      }
                      return const SizedBox.shrink();
                    }),


                    _buildAvailabilitySection(isDark),

                    SizedBox(height: 30.h),
                  ],
                ),
              ),
            ),


            _buildBottomActionBar(isDark),
          ],
        ),
      ),
    );
  }


  Widget _buildAppBar(BuildContext context, bool isDark) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          InkWell(
            onTap: () => Get.back(),
            borderRadius: BorderRadius.circular(20.r),
            child: Container(
              height: 40.r,
              width: 40.r,
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDark ? AppColors.dividerDark : AppColors.borderSubtle,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(isDark ? 20 : 8),
                    blurRadius: 6.r,
                  ),
                ],
              ),
              child: Icon(
                Icons.arrow_back_rounded,
                size: 20.r,
                color: isDark ? AppColors.textPrimaryDark : const Color(0xFF1E232A),
              ),
            ),
          ),
          Expanded(
            child: Obx(
              () => Text(
                'Filter - ${controller.selectedCity.value}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.textPrimaryDark : const Color(0xFF1E232A),
                ),
              ),
            ),
          ),
          SizedBox(width: 40.r),
        ],
      ),
    );
  }


  Widget _buildSubLocationChip(BuildContext context, bool isDark) {
    return Obx(() {
      final hasSub = controller.selectedSubLocation.value.isNotEmpty;
      final displayLoc = hasSub
          ? controller.selectedSubLocation.value
          : '${controller.selectedCity.value}, Bangladesh';

      return InkWell(
        onTap: () {
          LocationPickerBottomSheet.show(
            context,
            onSelected: (fullLoc, subArea) {
              controller.selectedSubLocation.value = fullLoc;
              if (fullLoc.contains(',')) {
                controller.selectedCity.value = fullLoc.split(',').last.trim();
              }
            },
          );
        },
        borderRadius: BorderRadius.circular(24.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF2C2523) : const Color(0xFF1E232A),
            borderRadius: BorderRadius.circular(24.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.location_on_rounded,
                size: 16,
                color: AppColors.primary,
              ),
              SizedBox(width: 6.w),
              Text(
                displayLoc,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 8.w),
              if (hasSub)
                InkWell(
                  onTap: controller.clearSubLocation,
                  child: Container(
                    padding: EdgeInsets.all(2.r),
                    decoration: const BoxDecoration(
                      color: Colors.white24,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close,
                      size: 12.r,
                      color: Colors.white,
                    ),
                  ),
                )
              else
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 16.r,
                  color: Colors.white70,
                ),
            ],
          ),
        ),
      );
    });
  }


  Widget _buildPriceRangeSection(bool isDark) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : const Color(0xFFFAF4F0),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: isDark ? AppColors.dividerDark : AppColors.catFamilyBg,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Price Range',
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.textPrimaryDark : const Color(0xFF1E232A),
            ),
          ),
          SizedBox(height: 14.h),


          Row(
            children: [
              Expanded(
                child: _buildEditablePriceInputBox(
                  label: 'MIN PRICE',
                  textController: controller.minPriceTextController,
                  onChanged: controller.updateMinPrice,
                  isDark: isDark,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: Text(
                  '-',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white54 : Colors.black45,
                  ),
                ),
              ),
              Expanded(
                child: _buildEditablePriceInputBox(
                  label: 'MAX PRICE',
                  textController: controller.maxPriceTextController,
                  onChanged: controller.updateMaxPrice,
                  isDark: isDark,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),


          Obx(
            () => SliderTheme(
              data: SliderThemeData(
                activeTrackColor: AppColors.primary,
                inactiveTrackColor: isDark ? Colors.white24 : AppColors.primaryLight,
                thumbColor: AppColors.primary,
                overlayColor: AppColors.primary.withAlpha(30),
                rangeThumbShape: const RoundRangeSliderThumbShape(
                  enabledThumbRadius: 10,
                  elevation: 3,
                ),
                trackHeight: 6.h,
              ),
              child: RangeSlider(
                values: controller.priceRange.value,
                min: controller.minPriceLimit,
                max: controller.maxPriceLimit,
                divisions: 99,
                onChanged: controller.updatePriceRange,
              ),
            ),
          ),


          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '৳1,000',
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                ),
                Text(
                  '৳1,00,000',
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditablePriceInputBox({
    required String label,
    required TextEditingController textController,
    required Function(String) onChanged,
    required bool isDark,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark ? AppColors.dividerDark : AppColors.borderSubtle,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 9.sp,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              letterSpacing: 0.8,
            ),
          ),
          SizedBox(height: 2.h),
          TextField(
            controller: textController,
            keyboardType: TextInputType.number,
            onChanged: onChanged,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.textPrimaryDark : const Color(0xFF1E232A),
            ),
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.zero,
              border: InputBorder.none,
              prefixText: '৳ ',
              prefixStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildPropertyTypeSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Property Type',
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.textPrimaryDark : const Color(0xFF1E232A),
          ),
        ),
        SizedBox(height: 12.h),
        Obx(
          () => Wrap(
            spacing: 10.w,
            runSpacing: 10.h,
            children: controller.propertyTypes.map((item) {
              final title = item['title'] as String;
              final icon = item['icon'] as IconData;
              final isSelected = controller.selectedPropertyType.value == title;

              return InkWell(
                onTap: () => controller.selectPropertyType(title),
                borderRadius: BorderRadius.circular(20.r),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary
                        : (isDark ? AppColors.surfaceDark : Colors.white),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : (isDark ? AppColors.dividerDark : AppColors.borderSubtle),
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppColors.primary.withAlpha(60),
                              blurRadius: 8.r,
                              offset: Offset(0, 3.h),
                            ),
                          ]
                        : null,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        icon,
                        size: 18.r,
                        color: isSelected
                            ? Colors.white
                            : (isDark ? AppColors.textPrimaryDark : const Color(0xFF1E232A)),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                          color: isSelected
                              ? Colors.white
                              : (isDark ? AppColors.textPrimaryDark : const Color(0xFF1E232A)),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }


  Widget _buildBachelorGenderSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bachelor Preference',
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.textPrimaryDark : const Color(0xFF1E232A),
          ),
        ),
        SizedBox(height: 12.h),
        Obx(
          () => Row(
            children: controller.bachelorGenderOptions.map((option) {
              final isSelected = controller.selectedBachelorGender.value == option;
              IconData icon = Icons.person_outline_rounded;
              if (option == 'Male') icon = Icons.male_rounded;
              if (option == 'Female') icon = Icons.female_rounded;
              if (option == 'Any') icon = Icons.people_outline_rounded;

              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: option == controller.bachelorGenderOptions.last ? 0 : 10.w,
                  ),
                  child: InkWell(
                    onTap: () => controller.selectBachelorGender(option),
                    borderRadius: BorderRadius.circular(20.r),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary
                            : (isDark ? AppColors.surfaceDark : Colors.white),
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : (isDark ? AppColors.dividerDark : AppColors.borderSubtle),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            icon,
                            size: 18.r,
                            color: isSelected
                                ? Colors.white
                                : (isDark ? AppColors.textPrimaryDark : const Color(0xFF1E232A)),
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            option,
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                              color: isSelected
                                  ? Colors.white
                                  : (isDark ? AppColors.textPrimaryDark : const Color(0xFF1E232A)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }


  Widget _buildBedroomsSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bedrooms',
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.textPrimaryDark : const Color(0xFF1E232A),
          ),
        ),
        SizedBox(height: 12.h),
        Obx(
          () => Row(
            children: controller.bedroomOptions.map((option) {
              final isSelected = controller.selectedBedrooms.value == option;

              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: option == '4+' ? 0 : 10.w),
                  child: InkWell(
                    onTap: () => controller.selectBedrooms(option),
                    borderRadius: BorderRadius.circular(20.r),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF1E232A)
                            : (isDark ? AppColors.surfaceDark : Colors.white),
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF1E232A)
                              : (isDark ? AppColors.dividerDark : AppColors.borderSubtle),
                        ),
                      ),
                      child: Text(
                        option,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: isSelected
                              ? Colors.white
                              : (isDark ? AppColors.textPrimaryDark : const Color(0xFF1E232A)),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }


  Widget _buildFurnishingSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Furnishing',
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.textPrimaryDark : const Color(0xFF1E232A),
          ),
        ),
        SizedBox(height: 12.h),
        Obx(
          () => Row(
            children: controller.furnishingOptions.map((option) {
              final isSelected = controller.selectedFurnishing.value == option;

              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: option == controller.furnishingOptions.last ? 0 : 10.w,
                  ),
                  child: InkWell(
                    onTap: () => controller.selectFurnishing(option),
                    borderRadius: BorderRadius.circular(20.r),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary
                            : (isDark ? AppColors.surfaceDark : Colors.white),
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : (isDark ? AppColors.dividerDark : AppColors.borderSubtle),
                        ),
                      ),
                      child: Text(
                        option,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                          color: isSelected
                              ? Colors.white
                              : (isDark ? AppColors.textPrimaryDark : const Color(0xFF1E232A)),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }


  Widget _buildAmenitiesSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Amenities',
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.textPrimaryDark : const Color(0xFF1E232A),
          ),
        ),
        SizedBox(height: 12.h),
        Obx(
          () => Wrap(
            spacing: 10.w,
            runSpacing: 10.h,
            children: controller.amenityOptions.map((item) {
              final title = item['title'] as String;
              final icon = item['icon'] as IconData;
              final isSelected = controller.selectedAmenities.contains(title);

              return InkWell(
                onTap: () => controller.toggleAmenity(title),
                borderRadius: BorderRadius.circular(20.r),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF1E232A)
                        : (isDark ? AppColors.surfaceDark : Colors.white),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF1E232A)
                          : (isDark ? AppColors.dividerDark : AppColors.borderSubtle),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        icon,
                        size: 16.r,
                        color: isSelected
                            ? Colors.white
                            : (isDark ? AppColors.textPrimaryDark : const Color(0xFF1E232A)),
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                          color: isSelected
                              ? Colors.white
                              : (isDark ? AppColors.textPrimaryDark : const Color(0xFF1E232A)),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }


  Widget _buildAvailabilitySection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Availability',
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.textPrimaryDark : const Color(0xFF1E232A),
          ),
        ),
        SizedBox(height: 12.h),
        Obx(
          () => Row(
            children: controller.availabilityOptions.map((option) {
              final isSelected = controller.selectedAvailability.value == option;

              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: option == controller.availabilityOptions.last ? 0 : 10.w,
                  ),
                  child: InkWell(
                    onTap: () => controller.selectAvailability(option),
                    borderRadius: BorderRadius.circular(20.r),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF1E232A)
                            : (isDark ? AppColors.surfaceDark : Colors.white),
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF1E232A)
                              : (isDark ? AppColors.dividerDark : AppColors.borderSubtle),
                        ),
                      ),
                      child: Text(
                        option,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                          color: isSelected
                              ? Colors.white
                              : (isDark ? AppColors.textPrimaryDark : const Color(0xFF1E232A)),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }


  Widget _buildBottomActionBar(bool isDark) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 40 : 10),
            blurRadius: 10.r,
            offset: Offset(0, -4.h),
          ),
        ],
      ),
      child: Row(
        children: [

          OutlinedButton(
            onPressed: controller.resetFilters,
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
              side: BorderSide(
                color: isDark ? AppColors.dividerDark : AppColors.borderSubtle,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
            child: Text(
              'Reset',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.textPrimaryDark : const Color(0xFF1E232A),
              ),
            ),
          ),

          SizedBox(width: 12.w),


          Expanded(
            child: ElevatedButton(
              onPressed: controller.applyFilters,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
                elevation: 4,
                shadowColor: AppColors.primary.withAlpha(80),
              ),
              child: Text(
                'Show Results',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
