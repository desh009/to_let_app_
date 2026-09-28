import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../widgets/custom_snackbar.dart';
import '../../../../../widgets/shimmer_widgets.dart';
import '../../../controller/profile-controller.dart';

class EditProfileScreen extends GetView<ProfileController> {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Initialize controllers with current data
    controller.initializeEditControllers();

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : const Color(0xFFFAF8F5),
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.backgroundDark : const Color(0xFFFAF8F5),
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Edit Profile',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : const Color(0xFF1E232A),
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: isDark ? Colors.white : const Color(0xFF1E232A),
          ),
          onPressed: () => Get.back(),
        ),
        actions: [
          Obx(() => controller.isLoading.value
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                )
              : TextButton(
                  onPressed: _handleSave,
                  child: Text(
                    'Save',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 15.sp,
                    ),
                  ),
                )),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAvatarSection(isDark),
            SizedBox(height: 30.h),
            _buildInputField(
              label: 'Full Name',
              controller: controller.nameEditController,
              icon: Icons.person_outline_rounded,
              isDark: isDark,
            ),
            SizedBox(height: 16.h),
            _buildInputField(
              label: 'Phone Number',
              controller: controller.phoneEditController,
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              isDark: isDark,
            ),
            SizedBox(height: 16.h),
            _buildInputField(
              label: 'Bio',
              controller: controller.bioEditController,
              icon: Icons.info_outline_rounded,
              maxLines: 3,
              isDark: isDark,
            ),
            SizedBox(height: 16.h),
            _buildInputField(
              label: 'City',
              controller: controller.cityEditController,
              icon: Icons.location_city_rounded,
              isDark: isDark,
            ),
            SizedBox(height: 16.h),
            _buildInputField(
              label: 'Address',
              controller: controller.addressEditController,
              icon: Icons.map_outlined,
              isDark: isDark,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarSection(bool isDark) {
    return Center(
      child: Stack(
        children: [
          Obx(() {
            if (controller.avatarUrl.value.isEmpty) {
              return CircleAvatar(
                radius: 50.r,
                backgroundColor: AppColors.primary.withAlpha(20),
                child: Icon(Icons.person, size: 50.r, color: AppColors.primary),
              );
            }
            return SizedBox(
              width: 100.r,
              height: 100.r,
              child: ClipOval(
                child: Image.network(
                  controller.avatarUrl.value,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return ImageShimmer(isDark: Theme.of(context).brightness == Brightness.dark, radius: 50.r);
                  },
                  errorBuilder: (context, err, st) => CircleAvatar(
                    radius: 50.r,
                    backgroundColor: AppColors.primary.withAlpha(20),
                    child: Icon(Icons.person, size: 50.r, color: AppColors.primary),
                  ),
                ),
              ),
            );
          }),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: _pickAndUploadImage,
              child: Container(
                padding: EdgeInsets.all(8.r),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.camera_alt_rounded, color: Colors.white, size: 18.r),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required bool isDark,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white70 : Colors.grey[700],
          ),
        ),
        SizedBox(height: 8.h),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: TextStyle(
            fontSize: 14.sp,
            color: isDark ? Colors.white : const Color(0xFF1E232A),
          ),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, size: 20.r, color: AppColors.primary),
            filled: true,
            fillColor: isDark ? AppColors.surfaceDark : Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(
                color: isDark ? AppColors.dividerDark : Colors.grey[300]!,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(
                color: isDark ? AppColors.dividerDark : Colors.grey[200]!,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          ),
        ),
      ],
    );
  }

  void _handleSave() async {
    final name = controller.nameEditController.text.trim();
    if (name.isEmpty) {
      CustomSnackbar.showError(title: 'Error', message: 'Name cannot be empty');
      return;
    }

    final success = await controller.updateUserProfile(
      name: name,
      phone: controller.phoneEditController.text.trim(),
      bio: controller.bioEditController.text.trim(),
      address: controller.addressEditController.text.trim(),
      city: controller.cityEditController.text.trim(),
    );

    if (success) {
      Get.back();
    }
  }

  void _pickAndUploadImage() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null) {
        final File file = File(image.path);
        final List<int> bytes = await file.readAsBytes();
        final String base64Image = base64Encode(bytes);
        
        await controller.uploadAvatar(base64Image);
      }
    } catch (e) {
      CustomSnackbar.showError(title: 'Error', message: 'Could not pick image');
    }
  }
}
