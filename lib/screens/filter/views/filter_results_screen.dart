import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/tolet_model.dart';
import '../../../routes/app_routes.dart';
import '../controllers/filter_controller.dart';

class FilterResultsScreen extends GetView<FilterController> {
  const FilterResultsScreen({super.key});

  List<ToLetModel> get _filteredProperties {
    final searchLoc = controller.selectedSubLocation.value.trim().toLowerCase();
    final areaName = searchLoc.contains(',')
        ? searchLoc.split(',').first.trim()
        : searchLoc;

    return ToLetModel.sampleData.where((item) {
      final locLower = item.location.toLowerCase();
      final titleLower = item.title.toLowerCase();
      final descLower = item.description.toLowerCase();

      bool areaMatch = true;
      if (areaName.isNotEmpty && areaName != 'khulna' && areaName != 'khulna, bangladesh') {
        areaMatch = locLower.contains(areaName) ||
            titleLower.contains(areaName) ||
            descLower.contains(areaName);
      }

      return areaMatch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final subLoc = controller.selectedSubLocation.value.isNotEmpty
        ? controller.selectedSubLocation.value.split(',').first
        : 'Khulna';
    final displayList = _filteredProperties;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [

            Padding(
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
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Properties in $subLoc',
                          style: TextStyle(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.textPrimaryDark : const Color(0xFF1E232A),
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          '${displayList.length} properties found • ${controller.selectedPropertyType.value}',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () => Get.back(),
                    borderRadius: BorderRadius.circular(16.r),
                    child: Container(
                      padding: EdgeInsets.all(10.r),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withAlpha(20),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.tune_rounded,
                        size: 20.r,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),


            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
              child: Row(
                children: [
                  _buildFilterSummaryTag('📍 $subLoc', isDark),
                  SizedBox(width: 8.w),
                  _buildFilterSummaryTag('🏠 ${controller.selectedPropertyType.value}', isDark),
                  SizedBox(width: 8.w),
                  _buildFilterSummaryTag(
                    '৳${controller.priceRange.value.start.round()} - ৳${controller.priceRange.value.end.round()}',
                    isDark,
                  ),
                  SizedBox(width: 8.w),
                  _buildFilterSummaryTag('🛏️ ${controller.selectedBedrooms.value} Beds', isDark),
                ],
              ),
            ),

            SizedBox(height: 10.h),


            Expanded(
              child: displayList.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.home_work_outlined,
                            size: 64.r,
                            color: isDark ? Colors.white24 : Colors.black26,
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            'No properties found in $subLoc',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: isDark ? AppColors.textPrimaryDark : const Color(0xFF1E232A),
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Try adjusting your price range or property filters',
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                            ),
                          ),
                          SizedBox(height: 20.h),
                          ElevatedButton(
                            onPressed: () => Get.back(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                            ),
                            child: const Text('Reset Filters', style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                      itemCount: displayList.length,
                      itemBuilder: (context, index) {
                        final item = displayList[index];
                        return _buildPropertyCard(context, item, isDark);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterSummaryTag(String text, bool isDark) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2C2523) : const Color(0xFFFDEEEA),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColors.primary.withAlpha(60),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildPropertyCard(BuildContext context, ToLetModel item, bool isDark) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: isDark ? AppColors.dividerDark : AppColors.borderSubtle,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 30 : 10),
            blurRadius: 12.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => Get.toNamed(Routes.DETAILS, arguments: item),
        borderRadius: BorderRadius.circular(20.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
                  child: Image.network(
                    item.images.isNotEmpty
                        ? item.images.first
                        : 'https://picsum.photos/seed/${item.id}/800/600',
                    height: 170.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (ctx, err, stack) => Image.network(
                      'https://picsum.photos/seed/${item.id}/800/600',
                      height: 170.h,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, err, stack) => Container(
                        height: 170.h,
                        color: isDark ? Colors.grey[800] : Colors.grey[300],
                        child: const Icon(Icons.home_outlined, size: 40),
                      ),
                    ),
                  ),
                ),


                Positioned(
                  top: 12.h,
                  left: 12.w,
                  right: 12.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Text(
                          item.category,
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(6.r),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.favorite_border_rounded,
                          size: 18.r,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),


                Positioned(
                  bottom: 12.h,
                  left: 12.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha(180),
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    child: Text(
                      '৳${item.price.toString()} / month',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),


            Padding(
              padding: EdgeInsets.all(14.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.textPrimaryDark : const Color(0xFF1E232A),
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 14.r,
                        color: AppColors.primary,
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Text(
                          item.location,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),


                  Row(
                    children: [
                      _buildSpecItem(Icons.king_bed_outlined, '${item.bedrooms} Beds', isDark),
                      SizedBox(width: 14.w),
                      _buildSpecItem(Icons.bathtub_outlined, '${item.bathrooms} Baths', isDark),
                      SizedBox(width: 14.w),
                      _buildSpecItem(Icons.square_foot_outlined, '${item.squareFeet} sqft', isDark),
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

  Widget _buildSpecItem(IconData icon, String text, bool isDark) {
    return Row(
      children: [
        Icon(
          icon,
          size: 15.r,
          color: isDark ? AppColors.textSecondaryDark : const Color(0xFF8A8784),
        ),
        SizedBox(width: 4.w),
        Text(
          text,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: isDark ? AppColors.textSecondaryDark : const Color(0xFF8A8784),
          ),
        ),
      ],
    );
  }
}
