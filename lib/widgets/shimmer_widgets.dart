import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

// ─── Base shimmer box ─────────────────────────────────────────────────────────
class _ShimmerBox extends StatelessWidget {
  final double width;
  final double height;
  final double radius;
  const _ShimmerBox({
    required this.width,
    required this.height,
    this.radius = 8,
  });

  @override
  Widget build(BuildContext context) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius),
        ),
      );
}

// ─── Shimmer wrap helper ──────────────────────────────────────────────────────
class ShimmerWrap extends StatelessWidget {
  final Widget child;
  final bool isDark;
  const ShimmerWrap({super.key, required this.child, this.isDark = false});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: isDark ? const Color(0xFF2C2C2C) : const Color(0xFFE8E8E8),
      highlightColor:
          isDark ? const Color(0xFF3D3D3D) : const Color(0xFFF5F5F5),
      child: child,
    );
  }
}

// ─── Image shimmer (replaces CircularProgressIndicator in loadingBuilder) ─────
class ImageShimmer extends StatelessWidget {
  final double? width;
  final double? height;
  final double radius;
  final bool isDark;
  const ImageShimmer({
    super.key,
    this.width,
    this.height,
    this.radius = 0,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    return ShimmerWrap(
      isDark: isDark,
      child: Container(
        width: width ?? double.infinity,
        height: height ?? double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}

// ─── Featured property card shimmer ──────────────────────────────────────────
class FeaturedCardShimmer extends StatelessWidget {
  final bool isDark;
  const FeaturedCardShimmer({super.key, this.isDark = false});

  @override
  Widget build(BuildContext context) {
    return ShimmerWrap(
      isDark: isDark,
      child: Container(
        width: 230.w,
        margin: EdgeInsets.only(right: 16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image placeholder
            Container(
              height: 145.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(16.r)),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ShimmerBox(width: 120.w, height: 12.h, radius: 4),
                  SizedBox(height: 6.h),
                  _ShimmerBox(width: 80.w, height: 10.h, radius: 4),
                  SizedBox(height: 8.h),
                  _ShimmerBox(width: 60.w, height: 14.h, radius: 4),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Horizontal list of featured card shimmers
class FeaturedListShimmer extends StatelessWidget {
  final bool isDark;
  const FeaturedListShimmer({super.key, this.isDark = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 4,
        itemBuilder: (context, index) => FeaturedCardShimmer(isDark: isDark),
      ),
    );
  }
}

// ─── Recommended property card shimmer ───────────────────────────────────────
class RecommendedCardShimmer extends StatelessWidget {
  final bool isDark;
  const RecommendedCardShimmer({super.key, this.isDark = false});

  @override
  Widget build(BuildContext context) {
    return ShimmerWrap(
      isDark: isDark,
      child: Container(
        height: 110.h,
        margin: EdgeInsets.only(bottom: 14.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Row(
          children: [
            // Image placeholder
            Container(
              width: 98.r,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.horizontal(left: Radius.circular(14.r)),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _ShimmerBox(width: 130.w, height: 12.h, radius: 4),
                    _ShimmerBox(width: 90.w, height: 10.h, radius: 4),
                    _ShimmerBox(width: 70.w, height: 14.h, radius: 4),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Vertical list of recommended card shimmers
class RecommendedListShimmer extends StatelessWidget {
  final bool isDark;
  const RecommendedListShimmer({super.key, this.isDark = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        children: List.generate(
          5,
          (_) => RecommendedCardShimmer(isDark: isDark),
        ),
      ),
    );
  }
}

// ─── Filter results shimmer ───────────────────────────────────────────────────
class FilterResultsShimmer extends StatelessWidget {
  final bool isDark;
  const FilterResultsShimmer({super.key, this.isDark = false});

  @override
  Widget build(BuildContext context) {
    return ShimmerWrap(
      isDark: isDark,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Column(
          children: List.generate(
            6,
            (_) => Container(
              height: 100.h,
              margin: EdgeInsets.only(bottom: 12.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Row(
                children: [
                  Container(
                    width: 100.r,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.horizontal(left: Radius.circular(14.r)),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 14.h, horizontal: 4.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _ShimmerBox(width: 120.w, height: 12.h, radius: 4),
                          _ShimmerBox(width: 80.w, height: 10.h, radius: 4),
                          _ShimmerBox(width: 60.w, height: 14.h, radius: 4),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── My Listings shimmer ─────────────────────────────────────────────────────
class MyListingsShimmer extends StatelessWidget {
  final bool isDark;
  const MyListingsShimmer({super.key, this.isDark = false});

  @override
  Widget build(BuildContext context) {
    return ShimmerWrap(
      isDark: isDark,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Column(
          children: List.generate(
            5,
            (_) => Container(
              height: 120.h,
              margin: EdgeInsets.only(bottom: 14.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Row(
                children: [
                  Container(
                    width: 110.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.horizontal(left: Radius.circular(14.r)),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _ShimmerBox(width: 130.w, height: 13.h, radius: 4),
                          _ShimmerBox(width: 90.w, height: 10.h, radius: 4),
                          _ShimmerBox(width: 70.w, height: 16.h, radius: 4),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── User search shimmer ─────────────────────────────────────────────────────
class UserSearchShimmer extends StatelessWidget {
  final bool isDark;
  const UserSearchShimmer({super.key, this.isDark = false});

  @override
  Widget build(BuildContext context) {
    return ShimmerWrap(
      isDark: isDark,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Column(
          children: List.generate(
            8,
            (_) => Container(
              height: 64.h,
              margin: EdgeInsets.only(bottom: 10.h),
              child: Row(
                children: [
                  // Avatar
                  Container(
                    width: 44.r,
                    height: 44.r,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _ShimmerBox(width: 130.w, height: 12.h, radius: 4),
                      SizedBox(height: 6.h),
                      _ShimmerBox(width: 90.w, height: 10.h, radius: 4),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Details screen shimmer ──────────────────────────────────────────────────
class DetailsShimmer extends StatelessWidget {
  final bool isDark;
  const DetailsShimmer({super.key, this.isDark = false});

  @override
  Widget build(BuildContext context) {
    return ShimmerWrap(
      isDark: isDark,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero image
            Container(
              height: 280.h,
              width: double.infinity,
              color: Colors.white,
            ),
            Padding(
              padding: EdgeInsets.all(20.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ShimmerBox(width: 200.w, height: 18.h, radius: 4),
                  SizedBox(height: 10.h),
                  _ShimmerBox(width: 140.w, height: 13.h, radius: 4),
                  SizedBox(height: 16.h),
                  _ShimmerBox(width: 100.w, height: 22.h, radius: 4),
                  SizedBox(height: 24.h),
                  Row(
                    children: [
                      _ShimmerBox(width: 70.w, height: 60.h, radius: 10),
                      SizedBox(width: 12.w),
                      _ShimmerBox(width: 70.w, height: 60.h, radius: 10),
                      SizedBox(width: 12.w),
                      _ShimmerBox(width: 70.w, height: 60.h, radius: 10),
                    ],
                  ),
                  SizedBox(height: 24.h),
                  _ShimmerBox(width: double.infinity, height: 12.h, radius: 4),
                  SizedBox(height: 8.h),
                  _ShimmerBox(width: 280.w, height: 12.h, radius: 4),
                  SizedBox(height: 8.h),
                  _ShimmerBox(width: 220.w, height: 12.h, radius: 4),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
