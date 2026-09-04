import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:to_let_app_abandon/widgets/favourite/button/animated_favourite_button.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../domain/entities/tolet_item.dart';

class RecommendedPropertyCard extends StatelessWidget {
  final ToLetItem item;
  final VoidCallback onTap;

  const RecommendedPropertyCard({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final locationName = item.location.split(',').first.trim();

    final bedStr = item.bedrooms > 0 ? '${item.bedrooms} bd' : 'Seat bd';
    final bathStr = item.bathrooms > 0 ? '${item.bathrooms} ba' : 'Shared ba';
    final sqftStr = item.squareFeet > 0 ? '${item.squareFeet.toInt()} sqft' : 'Shared';

    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(
          color: isDark ? AppColors.dividerDark : const Color(0xFFF0F0F0),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 25 : 8),
            blurRadius: 10.r,
            offset: Offset(0, 3.h),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(22.r),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(12.r),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16.r),
                    child: Container(
                      height: 98.r,
                      width: 98.r,
                      color: isDark
                          ? const Color(0xFF2C2C2C)
                          : const Color(0xFFF0EFEB),
                      child: Image.network(
                        item.images.isNotEmpty
                            ? item.images.first
                            : 'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=800',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Center(
                          child: Icon(
                            Icons.apartment_rounded,
                            color: Colors.grey,
                            size: 32.r,
                          ),
                        ),
                      ),
                    ),
                  ),


                  if (item.isVerified)
                    Positioned(
                      bottom: 6.h,
                      left: 6.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6.w,
                          vertical: 3.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.check_circle_rounded,
                              size: 11.r,
                              color: Colors.white,
                            ),
                            SizedBox(width: 3.w),
                            Text(
                              'VERIFIED',
                              style: TextStyle(
                                fontSize: 9.sp,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(width: 12.w),


              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            item.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14.5.sp,
                              fontWeight: FontWeight.w800,
                              color: isDark
                                  ? AppColors.textPrimaryDark
                                  : const Color(0xFF1E232A),
                            ),
                          ),
                        ),
                        SizedBox(width: 4.w),
                        AnimatedFavoriteButton(item: item, size: 18),
                      ],
                    ),
                    SizedBox(height: 3.h),


                    Row(
                      children: [
                        Text(
                          '৳${item.price.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w900,
                            color: isDark
                                ? AppColors.textPrimaryDark
                                : const Color(0xFF1E232A),
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Text(
                          '/mo',
                          style: TextStyle(
                            fontSize: 11.5.sp,
                            fontWeight: FontWeight.w500,
                            color: isDark
                                ? AppColors.textSecondaryDark
                                : const Color(0xFF7E8B9B),
                          ),
                        ),
                        SizedBox(width: 10.w),


                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 3.h,
                          ),
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF2D3748)
                                : const Color(0xFFF2F4F7),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Text(
                            item.category,
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? AppColors.textSecondaryDark
                                  : const Color(0xFF475467),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6.h),


                    Row(
                      children: [
                        Icon(
                          Icons.bed_outlined,
                          size: 13.r,
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : const Color(0xFF667085),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          bedStr,
                          style: TextStyle(
                            fontSize: 11.5.sp,
                            color: isDark
                                ? AppColors.textSecondaryDark
                                : const Color(0xFF667085),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5.w),
                          child: Text(
                            '•',
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: isDark
                                  ? AppColors.textSecondaryDark
                                  : const Color(0xFF98A2B3),
                            ),
                          ),
                        ),
                        Icon(
                          Icons.bathtub_outlined,
                          size: 13.r,
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : const Color(0xFF667085),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          bathStr,
                          style: TextStyle(
                            fontSize: 11.5.sp,
                            color: isDark
                                ? AppColors.textSecondaryDark
                                : const Color(0xFF667085),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5.w),
                          child: Text(
                            '•',
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: isDark
                                  ? AppColors.textSecondaryDark
                                  : const Color(0xFF98A2B3),
                            ),
                          ),
                        ),
                        Flexible(
                          child: Text(
                            sqftStr,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11.5.sp,
                              color: isDark
                                  ? AppColors.textSecondaryDark
                                  : const Color(0xFF667085),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),


                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 13.r,
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : const Color(0xFF667085),
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Text(
                            locationName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11.5.sp,
                              fontWeight: FontWeight.w500,
                              color: isDark
                                  ? AppColors.textSecondaryDark
                                  : const Color(0xFF667085),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
