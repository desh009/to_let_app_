import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/constants/app_colors.dart';

/// Custom Shimmer Loading Widget
/// Replace CircularProgressIndicator throughout the app
class CustomShimmer extends StatelessWidget {
  final double? width;
  final double? height;
  final ShimmerType type;
  final BorderRadius? borderRadius;

  const CustomShimmer({
    Key? key,
    this.width,
    this.height,
    this.type = ShimmerType.rectangular,
    this.borderRadius,
  }) : super(key: key);

  const CustomShimmer.circular({
    Key? key,
    this.width,
    this.height,
  })  : type = ShimmerType.circular,
        borderRadius = null,
        super(key: key);

  const CustomShimmer.rectangular({
    Key? key,
    this.width,
    this.height,
    this.borderRadius,
  })  : type = ShimmerType.rectangular,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Shimmer.fromColors(
      baseColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
      highlightColor: isDark ? Colors.grey[700]! : Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: type == ShimmerType.circular
              ? BorderRadius.circular((width ?? height ?? 50) / 2)
              : borderRadius ?? BorderRadius.circular(8.r),
        ),
      ),
    );
  }
}

enum ShimmerType {
  rectangular,
  circular,
}

/// Shimmer for property cards in home screen
class PropertyCardShimmer extends StatelessWidget {
  const PropertyCardShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      width: 280.w,
      margin: EdgeInsets.only(right: 16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image shimmer
          CustomShimmer(
            width: 280.w,
            height: 160.h,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          ),
          Padding(
            padding: EdgeInsets.all(12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title shimmer
                CustomShimmer(
                  width: 200.w,
                  height: 16.h,
                ),
                SizedBox(height: 8.h),
                // Location shimmer
                CustomShimmer(
                  width: 150.w,
                  height: 14.h,
                ),
                SizedBox(height: 12.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Price shimmer
                    CustomShimmer(
                      width: 80.w,
                      height: 18.h,
                    ),
                    // Rating shimmer
                    CustomShimmer(
                      width: 60.w,
                      height: 16.h,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Shimmer for list items
class ListItemShimmer extends StatelessWidget {
  const ListItemShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          // Image shimmer
          CustomShimmer.circular(
            width: 60.r,
            height: 60.r,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomShimmer(
                  width: double.infinity,
                  height: 16.h,
                ),
                SizedBox(height: 8.h),
                CustomShimmer(
                  width: 150.w,
                  height: 14.h,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Circular shimmer loading indicator (replacement for CircularProgressIndicator)
class CircularShimmerLoader extends StatelessWidget {
  final double? size;
  
  const CircularShimmerLoader({
    Key? key,
    this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final loaderSize = size ?? 40.r;
    
    return SizedBox(
      width: loaderSize,
      height: loaderSize,
      child: Shimmer.fromColors(
        baseColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
        highlightColor: isDark ? Colors.grey[700]! : AppColors.primary.withOpacity(0.3),
        period: Duration(milliseconds: 1500),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

/// Button shimmer (for loading buttons)
class ButtonShimmer extends StatelessWidget {
  final double? width;
  final double? height;
  
  const ButtonShimmer({
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Shimmer.fromColors(
      baseColor: isDark ? Colors.grey[800]! : AppColors.primary.withOpacity(0.3),
      highlightColor: isDark ? Colors.grey[700]! : AppColors.primary.withOpacity(0.1),
      child: Container(
        width: width ?? double.infinity,
        height: height ?? 50.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25.r),
        ),
      ),
    );
  }
}

/// Text shimmer lines
class TextShimmer extends StatelessWidget {
  final int lines;
  final double? width;
  
  const TextShimmer({
    Key? key,
    this.lines = 3,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        lines,
        (index) => Padding(
          padding: EdgeInsets.only(bottom: 8.h),
          child: CustomShimmer(
            width: width ?? (index == lines - 1 ? 200.w : double.infinity),
            height: 14.h,
          ),
        ),
      ),
    );
  }
}
