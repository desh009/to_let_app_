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

    final bedText = item.bedrooms > 0 ? '${item.bedrooms} beds' : 'Seat';
    final badgeText = '$bedText • ${item.category}';
    final locationName = item.location.split(',').first.trim();
    final bhkTitle = item.bedrooms > 0 ? '${item.bedrooms}BHK • $locationName' : item.title;

    return Container(
      width: 245.w,
      margin: EdgeInsets.only(right: 14.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(
          color: isDark ? AppColors.dividerDark : const Color(0xFFF0F0F0),
          width: 1,
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
        borderRadius: BorderRadius.circular(22.r),
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [

            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(22.r),
                    bottom: Radius.circular(16.r),
                  ),
                  child: Container(
                    height: 145.h,
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
                            size: 44.r,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),


                Positioned(
                  bottom: 10.h,
                  left: 10.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 5.h,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF1E232A).withAlpha(230)
                          : Colors.white.withAlpha(245),
                      borderRadius: BorderRadius.circular(20.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(20),
                          blurRadius: 4.r,
                          offset: Offset(0, 2.h),
                        ),
                      ],
                    ),
                    child: Text(
                      badgeText,
                      style: TextStyle(
                        color: isDark ? Colors.white : const Color(0xFF1E232A),
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),


                Positioned(
                  top: 10.h,
                  right: 10.w,
                  child: Container(
                    height: 34.r,
                    width: 34.r,
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(240),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(25),
                          blurRadius: 6.r,
                          offset: Offset(0, 2.h),
                        ),
                      ],
                    ),
                    child: Center(
                      child: AnimatedFavoriteButton(item: item, size: 17),
                    ),
                  ),
                ),
              ],
            ),


            Padding(
              padding: EdgeInsets.fromLTRB(14.w, 10.h, 14.w, 14.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        '৳${item.price.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 17.sp,
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
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : const Color(0xFF7E8B9B),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 3.h),


                  Text(
                    bhkTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13.5.sp,
                      fontWeight: FontWeight.w700,
                      color: isDark
                          ? AppColors.textPrimaryDark
                          : const Color(0xFF1E232A),
                    ),
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
