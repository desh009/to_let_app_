import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:to_let_app_abandon/app/data/services/notification/notification_service.dart';
import '../../../core/constants/app_colors.dart';
import '../../../domain/entities/tolet_item.dart';
import '../../home/controllers/home_controller.dart';

class PostListingController extends GetxController {
  final ImagePicker _picker = ImagePicker();

  // Text Editing Controllers
  late final TextEditingController titleController;
  late final TextEditingController locationController;
  late final TextEditingController rentController;
  late final TextEditingController descriptionController;

  final RxList<String> propertyPhotos = <String>[].obs;

  final RxInt bedrooms = 2.obs;
  final RxInt bathrooms = 2.obs;

  final List<String> tenantTypes = const ['Bachelor', 'Family', 'Seat', 'Sublet'];
  final RxString selectedTenantType = 'Family'.obs;

  void selectTenantType(String type) {
    selectedTenantType.value = type;
  }

  final RxBool hasLift = true.obs;
  final RxBool hasParking = true.obs;
  final RxBool hasGasLine = true.obs;
  final RxBool hasWifi = false.obs;

  final RxBool isDirectOwner = true.obs;

  final RxBool isSubmitting = false.obs;

  @override
  void onInit() {
    super.onInit();
    titleController = TextEditingController();
    locationController = TextEditingController();
    rentController = TextEditingController();
    descriptionController = TextEditingController();
  }

  void incrementBedrooms() {
    if (bedrooms.value < 10) bedrooms.value++;
  }

  void decrementBedrooms() {
    if (bedrooms.value > 1) bedrooms.value--;
  }

  void incrementBathrooms() {
    if (bathrooms.value < 10) bathrooms.value++;
  }

  void decrementBathrooms() {
    if (bathrooms.value > 1) bathrooms.value--;
  }

  void removePhoto(int index) {
    if (index >= 0 && index < propertyPhotos.length) {
      propertyPhotos.removeAt(index);
    }
  }

  void setCoverPhoto(int index) {
    if (index > 0 && index < propertyPhotos.length) {
      final item = propertyPhotos.removeAt(index);
      propertyPhotos.insert(0, item);
    }
  }

  void showImagePickerSourceSheet() {
    if (propertyPhotos.length >= 8) {
      Get.snackbar(
        'Limit Reached',
        'You can upload a maximum of 8 photos.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.black87,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    final isDark = Get.isDarkMode;

    Get.bottomSheet(
      Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E2228) : Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: isDark ? Colors.white24 : Colors.black12,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'upload_photo_title'.tr,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF1E232A),
                ),
              ),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildSourceTile(
                    icon: Icons.camera_alt_rounded,
                    label: 'camera'.tr,
                    onTap: () {
                      Get.back();
                      pickFromCamera();
                    },
                    isDark: isDark,
                  ),
                  _buildSourceTile(
                    icon: Icons.photo_library_rounded,
                    label: 'gallery'.tr,
                    onTap: () {
                      Get.back();
                      pickFromGallery();
                    },
                    isDark: isDark,
                  ),
                ],
              ),
              SizedBox(height: 12.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSourceTile({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60.r,
            height: 60.r,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.primary, size: 28.r),
          ),
          SizedBox(height: 8.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : const Color(0xFF1E232A),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> pickFromCamera() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
        maxWidth: 1400,
      );
      if (photo != null) {
        if (propertyPhotos.length < 8) {
          propertyPhotos.add(photo.path);
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Could not access camera: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> pickFromGallery() async {
    try {
      final int remainingSlots = 8 - propertyPhotos.length;
      if (remainingSlots <= 0) return;

      final List<XFile> images = await _picker.pickMultiImage(
        imageQuality: 85,
        maxWidth: 1400,
        limit: remainingSlots > 0 ? remainingSlots : null,
      );

      if (images.isNotEmpty) {
        for (final img in images) {
          if (propertyPhotos.length < 8) {
            propertyPhotos.add(img.path);
          }
        }
      }
    } catch (e) {
      try {
        final XFile? singleImage = await _picker.pickImage(
          source: ImageSource.gallery,
          imageQuality: 85,
          maxWidth: 1400,
        );
        if (singleImage != null && propertyPhotos.length < 8) {
          propertyPhotos.add(singleImage.path);
        }
      } catch (err) {
        Get.snackbar(
          'Error',
          'Could not pick images: $err',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }

  void toggleLift(bool val) => hasLift.value = val;
  void toggleParking(bool val) => hasParking.value = val;
  void toggleGasLine(bool val) => hasGasLine.value = val;
  void toggleWifi(bool val) => hasWifi.value = val;
  void toggleDirectOwner() => isDirectOwner.value = !isDirectOwner.value;

  void resetForm() {
    titleController.clear();
    locationController.clear();
    rentController.clear();
    descriptionController.clear();
    propertyPhotos.clear();
    bedrooms.value = 2;
    bathrooms.value = 2;
    selectedTenantType.value = 'Family';
    hasLift.value = true;
    hasParking.value = true;
    hasGasLine.value = true;
    hasWifi.value = false;
    isDirectOwner.value = true;
  }

  // Publish Listing Action
  Future<void> publishListing() async {
    final title = titleController.text.trim();
    final location = locationController.text.trim();
    final rentText =
        rentController.text.replaceAll(',', '').replaceAll('৳', '').trim();
    final rent = double.tryParse(rentText) ?? 32000;

    if (title.isEmpty) {
      Get.snackbar(
        'Missing Title',
        'Please enter a title for your property listing.',
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
      return;
    }

    if (location.isEmpty) {
      Get.snackbar(
        'Missing Location',
        'Please enter a location.',
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
      return;
    }

    if (propertyPhotos.isEmpty) {
      Get.snackbar(
        'Photos Required',
        'Please add at least 1 photo of the property.',
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
      return;
    }

    isSubmitting.value = true;
    await Future.delayed(const Duration(milliseconds: 900));
    isSubmitting.value = false;

    // Create newly posted item
    final newItem = ToLetItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      location: location,
      price: rent,
      bedrooms: bedrooms.value,
      bathrooms: bathrooms.value,
      squareFeet: 950,
      description: descriptionController.text.trim(),
      contactNumber: '+8801700000000',
      images: List<String>.from(propertyPhotos),
      category: selectedTenantType.value,
      badgeText: 'Featured',
      isVerified: true,
      isAvailable: true,
      isFeatured: true,
    );

    // If HomeController is registered, prepend to listings
    if (Get.isRegistered<HomeController>()) {
      final homeController = Get.find<HomeController>();
      homeController.featuredProperties.insert(0, newItem);
      homeController.allProperties.insert(0, newItem);
    }

    // ✅ Notification পাঠান — fire-and-forget, publish flow block করবে না
    NotificationApiService.notifyNewListing(
      listingTitle: title,
      listingId: newItem.id,
    );

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                  color: AppColors.primaryLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.primary,
                  size: 40,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'listing_submitted'.tr,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'listing_submitted_msg'.tr,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondaryLight,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () {
                    Get.back();
                    Get.back();
                  },
                  child: Text(
                    'done'.tr,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  @override
  void onClose() {
    titleController.dispose();
    locationController.dispose();
    rentController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}