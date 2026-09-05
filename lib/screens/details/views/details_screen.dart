import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../widgets/custom_snackbar.dart';
import 'package:to_let_app_abandon/widgets/favourite/button/animated_favourite_button.dart';
import '../controllers/details_controller.dart';

class DetailsScreen extends GetView<DetailsController> {
  const DetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final item = controller.item;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: Stack(
        children: [

          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [

              SliverAppBar(
                expandedHeight: 260.h,
                pinned: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                automaticallyImplyLeading: false,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [

                      Image.network(
                        item.images.isNotEmpty
                            ? item.images.first
                            : 'https://picsum.photos/seed/${item.id}/800/600',
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Image.network(
                          'https://picsum.photos/seed/${item.id}/800/600',
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: Colors.grey[300],
                            child: Icon(
                              Icons.apartment,
                              size: 64.r,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),


                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        height: 80.h,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withAlpha(120),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),


                      Positioned(
                        top: 46.h,
                        left: 16.w,
                        child: _CircleButton(
                          icon: Icons.arrow_back,
                          onTap: () => Get.back(),
                        ),
                      ),


                      Positioned(
                        top: 46.h,
                        right: 16.w,
                        child: Row(
                          children: [
                            _CircleButton(
                              icon: Icons.share_outlined,
                              onTap: () {
                                CustomSnackbar.showInfo(
                                  title: 'Share',
                                  message: 'Sharing ${item.title}...',
                                );
                              },
                            ),
                            SizedBox(width: 8.w),
                            AnimatedFavoriteButton(
                              item: item,
                              size: 22,
                            ),
                          ],
                        ),
                      ),


                      if (item.images.isNotEmpty)
                        Positioned(
                          bottom: 12.h,
                          right: 14.w,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withAlpha(160),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.photo_library_outlined,
                                  color: Colors.white,
                                  size: 12.r,
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  '1/${item.images.length}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),


              SliverToBoxAdapter(
                child: Container(
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Row(
                              children: [
                                _Badge(
                                  text: item.badgeText.isNotEmpty
                                      ? item.badgeText
                                      : 'Available now',
                                  bgColor: AppColors.badgeGreenBg,
                                  textColor: AppColors.badgeGreenText,
                                ),
                                SizedBox(width: 8.w),
                                if (!item.isVerified)
                                  _Badge(
                                    text: 'No brokerage',
                                    bgColor: AppColors.badgeGreyBg,
                                    textColor: AppColors.badgeGreyText,
                                  )
                                else
                                  _Badge(
                                    text: 'No brokerage',
                                    bgColor: AppColors.badgeGreyBg,
                                    textColor: AppColors.badgeGreyText,
                                  ),
                              ],
                            ),
                            SizedBox(height: 14.h),


                            Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text(
                                  '৳${item.price.toStringAsFixed(0)}',
                                  style: TextStyle(
                                    fontSize: 26.sp,
                                    fontWeight: FontWeight.w800,
                                    color: isDark
                                        ? AppColors.textPrimaryDark
                                        : AppColors.textPrimaryLight,
                                  ),
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  '/ month',
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    color: isDark
                                        ? AppColors.textSecondaryDark
                                        : AppColors.textSecondaryLight,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8.h),


                            Text(
                              item.title,
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w700,
                                color: isDark
                                    ? AppColors.textPrimaryDark
                                    : AppColors.textPrimaryLight,
                                height: 1.3,
                              ),
                            ),
                            SizedBox(height: 10.h),


                            Row(
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  size: 16.r,
                                  color: AppColors.primary,
                                ),
                                SizedBox(width: 4.w),
                                Expanded(
                                  child: Text(
                                    item.location,
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      color: isDark
                                          ? AppColors.textSecondaryDark
                                          : AppColors.textSecondaryLight,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20.h),


                            Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 16.h,
                                horizontal: 8.w,
                              ),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? AppColors.surfaceDark
                                    : AppColors.surfaceMuted,
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: _StatCell(
                                      label: 'Bedrooms',
                                      value: '${item.bedrooms} Beds',
                                      isDark: isDark,
                                    ),
                                  ),
                                  const _VerticalDivider(),
                                  Expanded(
                                    child: _StatCell(
                                      label: 'Bathrooms',
                                      value: '${item.bathrooms} Baths',
                                      isDark: isDark,
                                    ),
                                  ),
                                  const _VerticalDivider(),
                                  Expanded(
                                    child: _StatCell(
                                      label: 'Floor Area',
                                      value: '${item.squareFeet.toInt()} sqft',
                                      isDark: isDark,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 24.h),


                            Text(
                              'Property description',
                              style: TextStyle(
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w700,
                                color: isDark
                                    ? AppColors.textPrimaryDark
                                    : AppColors.textPrimaryLight,
                              ),
                            ),
                            SizedBox(height: 10.h),
                            Text(
                              item.description,
                              style: TextStyle(
                                fontSize: 13.sp,
                                height: 1.6,
                                color: isDark
                                    ? AppColors.textSecondaryDark
                                    : AppColors.textSecondaryLight,
                              ),
                            ),
                            SizedBox(height: 24.h),


                            Text(
                              'Amenities & features',
                              style: TextStyle(
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w700,
                                color: isDark
                                    ? AppColors.textPrimaryDark
                                    : AppColors.textPrimaryLight,
                              ),
                            ),
                            SizedBox(height: 14.h),
                            Wrap(
                              spacing: 10.w,
                              runSpacing: 10.h,
                              children: _amenities(item.category)
                                  .map(
                                    (a) => _AmenityChip(
                                      icon: a['icon'] as IconData,
                                      label: a['label'] as String,
                                      isDark: isDark,
                                    ),
                                  )
                                  .toList(),
                            ),
                            SizedBox(height: 100.h),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),


          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(18),
                    blurRadius: 16.r,
                    offset: Offset(0, -4.h),
                  ),
                ],
              ),
              child: Row(
                children: [

                  Obx(
                    () => InkWell(
                      borderRadius: BorderRadius.circular(14.r),
                      onTap: controller.toggleFavorite,
                      child: Container(
                        height: 50.r,
                        width: 50.r,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isDark
                                ? AppColors.dividerDark
                                : AppColors.borderMedium,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                        child: Icon(
                          controller.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border_rounded,
                          color: controller.isFavorite
                              ? AppColors.error
                              : AppColors.iconMuted,
                          size: 22.r,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 14.w),


                  Expanded(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14.r),
                      onTap: () {
                        CustomSnackbar.showInfo(
                          title: 'Contact Owner',
                          message: 'Calling ${item.contactNumber}...',
                        );
                      },
                      child: Container(
                        height: 50.h,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(14.r),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withAlpha(80),
                              blurRadius: 10.r,
                              offset: Offset(0, 4.h),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.phone_outlined,
                              color: Colors.white,
                              size: 20.r,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              'Contact Owner',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _amenities(String category) {
    final common = [
      {'icon': Icons.water_drop_outlined, 'label': '24hr Water'},
      {'icon': Icons.bolt_outlined, 'label': 'Generator'},
      {'icon': Icons.security_outlined, 'label': 'Security Guard'},
      {'icon': Icons.local_parking_outlined, 'label': 'Parking'},
    ];
    final extra = category.toLowerCase() == 'family'
        ? [
            {'icon': Icons.elevator_outlined, 'label': 'Lift'},
            {'icon': Icons.balcony_outlined, 'label': 'Balcony'},
          ]
        : [
            {'icon': Icons.wifi, 'label': 'WiFi Ready'},
            {'icon': Icons.kitchen_outlined, 'label': 'Kitchen'},
          ];
    return [...common, ...extra];
  }
}


class _CircleButton extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final VoidCallback onTap;

  const _CircleButton({
    required this.icon,
    required this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 38.r,
        width: 38.r,
        decoration: BoxDecoration(
          color: Colors.black.withAlpha(130),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: iconColor ?? Colors.white, size: 18.r),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;
  final Color bgColor;
  final Color textColor;

  const _Badge({
    required this.text,
    required this.bgColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }
}

class _StatCell extends StatelessWidget {
  final String label;
  final String value;
  final bool isDark;

  const _StatCell({
    required this.label,
    required this.value,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11.sp,
            color: isDark
                ? AppColors.textSecondaryDark
                : AppColors.iconMuted,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
      ],
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  const _VerticalDivider();

  @override
  Widget build(BuildContext context) {
    return Container(height: 36.h, width: 1, color: AppColors.borderMedium);
  }
}

class _AmenityChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isDark;

  const _AmenityChip({
    required this.icon,
    required this.label,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: isDark ? AppColors.dividerDark : AppColors.borderSubtle,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16.r,
            color: isDark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondaryLight,
          ),
          SizedBox(width: 6.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }
}