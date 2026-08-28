import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:to_let_app_abandon/widgets/favourite/button/animated_favourite_button.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../domain/entities/tolet_item.dart';

class FeaturedPropertyCard extends StatelessWidget {
  final ToLetItem item;
  final VoidCallback onTap;

  const FeaturedPropertyCard({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: 275.w,
      margin: EdgeInsets.only(right: 16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: isDark ? AppColors.dividerDark : AppColors.borderSubtle,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 30 : 8),
            blurRadius: 16.r,
            offset: Offset(0, 6.h),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(24.r),
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image Stack
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(24.r),
                  ),
                  child: Container(
                    height: 155.h,
                    width: double.infinity,
                    color: isDark
                        ? const Color(0xFF2C2C2C)
                        : const Color(0xFFF0EFEB),
                    child: Image.network(
                      item.images.isNotEmpty
                          ? item.images.first
                          : 'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?w=800',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: isDark
                            ? AppColors.surfaceDark
                            : Colors.grey[200],
                        child: Center(
                          child: Icon(
                            Icons.apartment_rounded,
                            size: 48.r,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Available Now Badge (Top-Left)
                Positioned(
                  top: 12.h,
                  left: 12.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.badgeGreenBg,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      item.badgeText.isNotEmpty
                          ? item.badgeText
                          : 'Available now',
                      style: TextStyle(
                        color: AppColors.badgeGreenText,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),

                // Favorite Round Button (Top-Right)
                Positioned(
                  top: 10.h,
                  right: 10.w,
                  child: Container(
                    height: 36.r,
                    width: 36.r,
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(235),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(20),
                          blurRadius: 6.r,
                          offset: Offset(0, 2.h),
                        ),
                      ],
                    ),
                    child: Center(
                      child: AnimatedFavoriteButton(item: item, size: 18),
                    ),
                  ),
                ),
              ],
            ),

            // Content Section
            Padding(
              padding: EdgeInsets.all(12.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Price and Verified badge
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Flexible(
                              child: Text(
                                '৳${item.price.toStringAsFixed(0)}',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w800,
                                  color: isDark
                                      ? AppColors.textPrimaryDark
                                      : const Color(0xFF1E232A),
                                ),
                              ),
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              '/ month',
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: isDark
                                    ? AppColors.textSecondaryDark
                                    : const Color(0xFF8A8784),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (item.isVerified) ...[
                        SizedBox(width: 6.w),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 7.w,
                            vertical: 2.5.h,
                          ),
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF2C2A27)
                                : AppColors.badgeGreyBg,
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Text(
                            'Verified',
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? Colors.white70
                                  : AppColors.badgeGreyText,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: 4.h),

                  // Location
                  Text(
                    item.location,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : const Color(0xFF8A8784),
                    ),
                  ),
                  SizedBox(height: 6.h),

                  // Specs (beds, baths, sqft)
                  Row(
                    children: [
                      Text(
                        '${item.bedrooms} beds',
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : const Color(0xFF6B6864),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        '${item.bathrooms} baths',
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : const Color(0xFF6B6864),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Flexible(
                        child: Text(
                          '${item.squareFeet.toStringAsFixed(0)} sqft',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: isDark
                                ? AppColors.textSecondaryDark
                                : const Color(0xFF6B6864),
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
    );
  }
}
