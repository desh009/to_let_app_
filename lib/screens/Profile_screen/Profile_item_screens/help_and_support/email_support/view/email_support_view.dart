import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:to_let_app_abandon/core/constants/app_colors.dart';
import 'package:to_let_app_abandon/core/constants/app_strings.dart';
import 'package:to_let_app_abandon/screens/Profile_screen/Profile_item_screens/help_and_support/email_support/controller/email_support_controller.dart';


// CHANGED: StatefulWidget -> GetView<EmailSupportController>
class EmailSupportScreen extends GetView<EmailSupportController> {
  const EmailSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(isDark), // CHANGED: removed context parameter
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 500.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 8.h),

                        // Top Support Info Box
                        _buildTopInfoCard(isDark),
                        SizedBox(height: 24.h),

                        // Your Email Field Label
                        Text(
                          AppStrings.yourEmail,
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.textSecondaryDark : Colors.grey.shade600,
                            letterSpacing: 0.8,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        _buildEmailField(isDark),
                        SizedBox(height: 20.h),

                        // Subject Dropdown Label
                        Text(
                          AppStrings.subject,
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.textSecondaryDark : Colors.grey.shade600,
                            letterSpacing: 0.8,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        _buildSubjectDropdown(isDark),
                        SizedBox(height: 24.h),

                        // Attach Screenshot Button (Dotted Border)
                        // CHANGED: Wrapped with GestureDetector to make it tappable
                        GestureDetector(
                          onTap: controller.pickAttachment,
                          child: _buildAttachmentButton(isDark),
                        ),
                        SizedBox(height: 24.h),

                        // Send Email Button with Loading
                        // CHANGED: Wrapped with Obx for reactive loading state
                        Obx(
                          () => SizedBox(
                            width: double.infinity,
                            height: 52.h,
                            child: ElevatedButton(
                              onPressed: controller.isLoading.value
                                  ? null
                                  : controller.sendEmail,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                disabledBackgroundColor: AppColors.primary.withOpacity(0.6),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(26.r),
                                ),
                                elevation: 0,
                              ),
                              child: controller.isLoading.value
                                  ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      ),
                                    )
                                  : Text(
                                      AppStrings.sendEmail,
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),

                        // Ticket ID Footer Note
                        Center(
                          child: Text(
                            AppStrings.ticketIdNote,
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: isDark ? AppColors.textSecondaryDark : Colors.grey.shade500,
                            ),
                          ),
                        ),
                        SizedBox(height: 20.h),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Header App Bar
  // CHANGED: Removed BuildContext parameter, uses controller.handleBack
  Widget _buildAppBar(bool isDark) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: controller.handleBack, // CHANGED
            child: Container(
              width: 36.r,
              height: 36.r,
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_back,
                size: 18.r,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
            ),
          ),
          Text(
            AppStrings.emailSupportTitle,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(10.r),
            ),
          
            
          ),
        ],
      ),
    );
  }

  // Top Email Info Card
  Widget _buildTopInfoCard(bool isDark) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark ? AppColors.dividerDark : Colors.grey.shade200,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44.r,
            height: 44.r,
            decoration: BoxDecoration(
              color: isDark ? AppColors.backgroundDark : Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: isDark ? AppColors.dividerDark : Colors.grey.shade200,
              ),
            ),
            child: Icon(
              Icons.email_outlined,
              size: 20.r,
              color: isDark ? AppColors.textPrimaryDark : Colors.grey.shade800,
            ),
          ),
          SizedBox(width: 14.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.responseWithinTime,
                style: TextStyle(
                  fontSize: 11.sp,
                  color: isDark ? AppColors.textSecondaryDark : Colors.grey.shade600,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                AppStrings.supportEmailAddress,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Email Address Display Container
  Widget _buildEmailField(bool isDark) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.grey.shade100.withOpacity(0.6),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // CHANGED: Uses controller emailController
          Text(
            controller.emailController.text,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
          ),
          Icon(
            Icons.check,
            size: 18.r,
            // CHANGED: Fixed invalid Colors.emerald to AppColors.success
            color: AppColors.success,
          ),
        ],
      ),
    );
  }

  // Subject Dropdown Selector
  // CHANGED: Wrapped with Obx for reactive dropdown
  Widget _buildSubjectDropdown(bool isDark) {
    return Obx(
      () => Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isDark ? AppColors.dividerDark : Colors.grey.shade300,
          ),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: controller.selectedSubject.value, // CHANGED
            isExpanded: true,
            icon: Icon(
              Icons.keyboard_arrow_down,
              color: isDark ? AppColors.textSecondaryDark : Colors.grey.shade600,
            ),
            dropdownColor: isDark ? AppColors.surfaceDark : Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            items: controller.subjects.map((String value) { // CHANGED
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                ),
              );
            }).toList(),
            onChanged: controller.selectSubject, // CHANGED
          ),
        ),
      ),
    );
  }

  // Custom Dotted Border Attachment Button
  // CHANGED: Added Obx to show selected file name
  Widget _buildAttachmentButton(bool isDark) {
    return CustomPaint(
      painter: DottedBorderPainter(
        color: isDark ? AppColors.dividerDark : Colors.grey.shade400,
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 14.h),
        alignment: Alignment.center,
        child: Obx(() {
          if (controller.attachedFileName.value != null) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.insert_drive_file_outlined,
                  size: 18.r,
                  color: AppColors.primary,
                ),
                SizedBox(width: 8.w),
                Text(
                  controller.attachedFileName.value!,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                ),
                SizedBox(width: 8.w),
                GestureDetector(
                  onTap: controller.removeAttachment,
                  child: Icon(
                    Icons.close,
                    size: 18.r,
                    color: Colors.red,
                  ),
                ),
              ],
            );
          }
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.upload_outlined,
                size: 18.r,
                color: isDark ? AppColors.textSecondaryDark : Colors.grey.shade600,
              ),
              SizedBox(width: 8.w),
              Text(
                AppStrings.attachScreenshot,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
              SizedBox(width: 4.w),
              Text(
                AppStrings.maxFileSize,
                style: TextStyle(
                  fontSize: 11.sp,
                  color: isDark ? AppColors.textSecondaryDark : Colors.grey.shade500,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

// Custom Painter for Dotted Border around attachment
// CHANGED: Fixed invalid Paint() syntax error (..color = color)
class DottedBorderPainter extends CustomPainter {
  final Color color;

  DottedBorderPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color // CHANGED: was 'color = color' (syntax error)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    final RRect rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(16),
    );

    final Path path = Path()..addRRect(rrect);
    final Path dashPath = Path();

    double distance = 0.0;
    const double dashWidth = 5.0;
    const double dashSpace = 4.0;

    for (final PathMetric metric in path.computeMetrics()) {
      while (distance < metric.length) {
        dashPath.addPath(
          metric.extractPath(distance, distance + dashWidth),
          Offset.zero,
        );
        distance += dashWidth + dashSpace;
      }
    }

    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}