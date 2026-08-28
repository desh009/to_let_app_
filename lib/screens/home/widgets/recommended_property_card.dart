import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:to_let_app_abandon/widgets/favourite/button/animated_favourite_button.dart';
import '../../../core/constants/app_colors.dart';
import '../../../domain/entities/tolet_item.dart';

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

    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: isDark ? AppColors.dividerDark : AppColors.borderSubtle,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 20 : 5),
            blurRadius: 10.r,
            offset: Offset(0, 3.h),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20.r),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(12.r),
          child: Row(
            children: [
              // Thumbnail image with heart
              ClipRRect(
                borderRadius: BorderRadius.circular(14.r),
                child: Container(
                  height: 80.r,
                  width: 80.r,
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
                        Icons.apartment,
                        color: Colors.grey,
                        size: 28.r,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),

              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            '৳${item.price.toStringAsFixed(0)}',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 16.sp,
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
                    SizedBox(height: 4.h),
                    Text(
                      '${item.title.split('·').first.trim()} · ${item.location.split('·').first.trim()}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : const Color(0xFF7D7A75),
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Row(
                      children: [
                        Icon(
                          Icons.bed_outlined,
                          size: 14.r,
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : const Color(0xFF8A8784),
                        ),
                        SizedBox(width: 4.w),
                        Flexible(
                          child: Text(
                            '${item.bedrooms} beds',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: isDark
                                  ? AppColors.textSecondaryDark
                                  : const Color(0xFF8A8784),
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Icon(
                          Icons.bathtub_outlined,
                          size: 14.r,
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : const Color(0xFF8A8784),
                        ),
                        SizedBox(width: 4.w),
                        Flexible(
                          child: Text(
                            '${item.bathrooms} baths',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: isDark
                                  ? AppColors.textSecondaryDark
                                  : const Color(0xFF8A8784),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Favorite button
              AnimatedFavoriteButton(item: item, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
