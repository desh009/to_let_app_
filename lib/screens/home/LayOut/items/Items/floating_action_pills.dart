import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/controllers/gemini_voice_controller.dart';
import '../../../../../widgets/custom_snackbar.dart';

class FloatingActionPills extends StatelessWidget {
  final VoidCallback onPostListing;
  final VoidCallback onMapView;

  const FloatingActionPills({
    super.key,
    required this.onPostListing,
    required this.onMapView,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Center(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Post a Listing pill
              InkWell(
                borderRadius: BorderRadius.circular(30.r),
                onTap: onPostListing,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(30.r),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withAlpha(90),
                        blurRadius: 14.r,
                        offset: Offset(0, 6.h),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add_rounded, color: Colors.white, size: 20.r),
                      SizedBox(width: 6.w),
                      Text(
                        'Post a listing',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 10.w),

              // Gemini Voice FAB
              Obx(() {
                final isListening = GeminiVoiceController.to.isListening.value;
                return GestureDetector(
                  onLongPressStart: (_) => GeminiVoiceController.to.startListening(),
                  onLongPressEnd: (_) => GeminiVoiceController.to.stopListening(),
                  onTap: () {
                    CustomSnackbar.showInfo(
                      title: 'Gemini Voice Search',
                      message: 'Press & hold to speak your command.',
                    );
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h),
                    decoration: BoxDecoration(
                      gradient: isListening
                          ? const LinearGradient(
                              colors: [Color(0xFFE53935), Color(0xFFFF7043)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : const LinearGradient(
                              colors: [Color(0xFF4285F4), Color(0xFF9B59B6)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                      borderRadius: BorderRadius.circular(30.r),
                      boxShadow: [
                        BoxShadow(
                          color: (isListening ? Colors.redAccent : const Color(0xFF4285F4)).withAlpha(100),
                          blurRadius: 14.r,
                          offset: Offset(0, 6.h),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isListening ? Icons.stop_rounded : Icons.auto_awesome_rounded,
                          color: Colors.white,
                          size: 20.r,
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          isListening ? 'Listening...' : 'Voice Search',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              SizedBox(width: 10.w),

              // Map View pill
              InkWell(
                borderRadius: BorderRadius.circular(30.r),
                onTap: onMapView,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h),
                  decoration: BoxDecoration(
                    color: AppColors.darkCharcoal,
                    borderRadius: BorderRadius.circular(30.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(100),
                        blurRadius: 14.r,
                        offset: Offset(0, 6.h),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.map_outlined, color: Colors.white, size: 20.r),
                      SizedBox(width: 6.w),
                      Text(
                        'Map view',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
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
    );
  }
}
