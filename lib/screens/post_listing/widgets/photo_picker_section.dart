import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/post_listing_controller.dart';

class PhotoPickerSection extends GetView<PostListingController> {
  const PhotoPickerSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
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
          // Header Row
          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${'property_photos'.tr} • ${controller.propertyPhotos.length}/8',
                  style: TextStyle(
                    fontSize: 11.5.sp,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                    color: isDark
                        ? const Color(0xFFA0AEC0)
                        : const Color(0xFF8E9BAE),
                  ),
                ),
                Text(
                  'min_photos_hint'.tr,
                  style: TextStyle(
                    fontSize: 11.5.sp,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? const Color(0xFFA0AEC0)
                        : const Color(0xFF8E9BAE),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 14.h),

          // Photos Row / List
          Obx(
            () => SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: [
                  ...List.generate(controller.propertyPhotos.length, (index) {
                    final photoPath = controller.propertyPhotos[index];
                    return Padding(
                      padding: EdgeInsets.only(right: 12.w),
                      child: _buildPhotoThumbnail(
                        context,
                        photoPath: photoPath,
                        index: index,
                        isCover: index == 0,
                      ),
                    );
                  }),

                  // Add Photo Box
                  if (controller.propertyPhotos.length < 8)
                    _buildAddPhotoBox(context, isDark),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoThumbnail(
    BuildContext context, {
    required String photoPath,
    required int index,
    required bool isCover,
  }) {
    final bool isNetwork =
        photoPath.startsWith('http://') || photoPath.startsWith('https://');

    return GestureDetector(
      onTap: () {
        if (!isCover) {
          controller.setCoverPhoto(index);
        }
      },
      child: Stack(
        children: [
          Container(
            width: 86.w,
            height: 86.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              color: const Color(0xFFE2E8F0),
            ),
            clipBehavior: Clip.antiAlias,
            child: isNetwork
                ? Image.network(
                    photoPath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Center(child: Icon(Icons.broken_image_rounded)),
                  )
                : (kIsWeb
                    ? Image.network(
                        photoPath,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Center(
                                child: Icon(Icons.broken_image_rounded)),
                      )
                    : Image.file(
                        File(photoPath),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Center(
                                child: Icon(Icons.broken_image_rounded)),
                      )),
          ),

          // Cover Badge
          if (isCover)
            Positioned(
              bottom: 6.h,
              left: 6.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF191D24),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Text(
                  'cover'.tr,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 9.5.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),

          // Close / Remove Button
          Positioned(
            top: 6.h,
            right: 6.w,
            child: GestureDetector(
              onTap: () => controller.removePhoto(index),
              child: Container(
                width: 22.r,
                height: 22.r,
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(160),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.close_rounded,
                  size: 13.r,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddPhotoBox(BuildContext context, bool isDark) {
    return GestureDetector(
      onTap: controller.showImagePickerSourceSheet,
      child: CustomPaint(
        painter: _DashedRRectPainter(
          color: isDark ? const Color(0xFF4A5568) : const Color(0xFFCFD9E4),
          strokeWidth: 1.5,
          gap: 4.0,
          radius: 16.r,
        ),
        child: Container(
          width: 86.w,
          height: 86.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            color: isDark ? const Color(0xFF242930) : const Color(0xFFFAFBFD),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 28.r,
                height: 28.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDark
                        ? const Color(0xFF718096)
                        : const Color(0xFF8E9BAE),
                    width: 1.5,
                  ),
                ),
                child: Icon(
                  Icons.add_rounded,
                  size: 18.r,
                  color: isDark
                      ? const Color(0xFFA0AEC0)
                      : const Color(0xFF5A6A7D),
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                'add_photo'.tr,
                style: TextStyle(
                  fontSize: 10.5.sp,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? const Color(0xFFA0AEC0)
                      : const Color(0xFF6E7E91),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashedRRectPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;
  final double radius;

  _DashedRRectPainter({
    required this.color,
    required this.strokeWidth,
    required this.gap,
    required this.radius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          Radius.circular(radius),
        ),
      );

    final dashPath = _dashPath(path, 5.0, gap);
    canvas.drawPath(dashPath, paint);
  }

  Path _dashPath(Path source, double dashLength, double dashGap) {
    final dest = Path();
    for (final metric in source.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final length = (distance + dashLength < metric.length)
            ? dashLength
            : metric.length - distance;
        dest.addPath(
          metric.extractPath(distance, distance + length),
          Offset.zero,
        );
        distance += dashLength + dashGap;
      }
    }
    return dest;
  }

  @override
  bool shouldRepaint(covariant _DashedRRectPainter oldDelegate) =>
      color != oldDelegate.color ||
      strokeWidth != oldDelegate.strokeWidth ||
      gap != oldDelegate.gap ||
      radius != oldDelegate.radius;
}
