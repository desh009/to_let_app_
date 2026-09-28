import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:to_let_app_abandon/app/data/services/notification/notification_service.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/config/urls.dart';
import '../../../data/repositories/listings_repo.dart';
import '../../../domain/entities/tolet_item.dart';
import '../../home/controllers/home_controller.dart';
import '../../notifications/controllers/notifications_controller.dart';

class PostListingController extends GetxController {
  final ImagePicker _picker = ImagePicker();
  final ListingsRepo _listingsRepo = ListingsRepo();

  late final TextEditingController titleController;
  late final TextEditingController locationController;
  late final TextEditingController rentController;
  late final TextEditingController descriptionController;

  final RxList<String> propertyPhotos = <String>[].obs;

  final RxInt bedrooms = 2.obs;
  final RxInt bathrooms = 2.obs;

  final List<String> tenantTypes = const [
    'Bachelor',
    'Family',
    'Seat',
    'Sublet',
  ];
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

  Future<void> publishListing() async {
    final title = titleController.text.trim();
    final location = locationController.text.trim();
    final rentText = rentController.text
        .replaceAll(',', '')
        .replaceAll('৳', '')
        .trim();
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

    // ============================================================
    // EXTRACT CITY AND AREA FROM LOCATION
    // ============================================================
    String city = 'Khulna';
    String? area;

    if (location.contains(',')) {
      final parts = location.split(',');
      area = parts[0].trim();
      city = parts.length > 1 ? parts[1].trim() : 'Khulna';
    } else {
      area = location;
    }

    // ============================================================
    // PROCESS AND UPLOAD PHOTOS
    // ============================================================
    final List<String> finalImageUrls = [];
    final List<String> localBase64Images = [];

    for (final photo in propertyPhotos) {
      if (photo.startsWith('http://') || photo.startsWith('https://')) {
        finalImageUrls.add(photo);
      } else {
        try {
          final file = File(photo);
          if (file.existsSync()) {
            final bytes = await file.readAsBytes();
            localBase64Images.add(base64Encode(bytes));
          }
        } catch (e) {
          debugPrint('Error reading photo: $e');
        }
      }
    }

    if (localBase64Images.isNotEmpty) {
      try {
        final uploadRes = await _listingsRepo.uploadPropertyImages(localBase64Images);
        if (uploadRes.isSuccess && uploadRes.responseData?['data']?['urls'] != null) {
          final urls = (uploadRes.responseData!['data']['urls'] as List)
              .map((e) => e.toString());
          finalImageUrls.addAll(urls);
        }
      } catch (e) {
        debugPrint('Upload error: $e');
      }
    }

    if (finalImageUrls.isEmpty) {
      finalImageUrls.add('https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?w=800');
    }

    // ============================================================
    // PREPARE API REQUEST BODY
    // ============================================================
    final requestBody = {
      'title': title,
      'location': location,
      'city': city,
      'area': area,
      'price': rent.toInt(),
      'bedrooms': bedrooms.value,
      'bathrooms': bathrooms.value,
      'square_feet': 950,
      'description': descriptionController.text.trim(),
      'contact_number': '+8801700000000',
      'images': finalImageUrls,
      'category': selectedTenantType.value,
      'furnishing': 'Unfurnished',
      'amenities': {
        'lift': hasLift.value,
        'parking': hasParking.value,
        'gasLine': hasGasLine.value,
        'wifi': hasWifi.value,
        'generator': false,
        'water24_7': true,
      },
      'availability': 'Available now',
      'is_direct_owner': isDirectOwner.value,
    };

    debugPrint('========== POST LISTING API REQUEST ==========');
    debugPrint('URL: ${Urls.allListings}');
    debugPrint('Body: $requestBody');
    debugPrint('==============================================');

    // ============================================================
    // CALL API TO SAVE TO SUPABASE
    // ============================================================
    try {
      final response = await _listingsRepo.createListing(requestBody);

      debugPrint('========== POST LISTING API RESPONSE ==========');
      debugPrint('Success: ${response.isSuccess}');
      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Data: ${response.responseData}');
      debugPrint('Error: ${response.errorMessage}');
      debugPrint('==============================================');

      if (!response.isSuccess) {
        isSubmitting.value = false;
        Get.snackbar(
          'Error',
          response.errorMessage ?? 'Failed to create listing',
          backgroundColor: AppColors.error,
          colorText: Colors.white,
        );
        return;
      }

      // ============================================================
      // GET LISTING ID FROM RESPONSE
      // ============================================================
      final listingId =
          response.responseData?['data']?['id']?.toString() ??
          DateTime.now().millisecondsSinceEpoch.toString();

      final newItem = ToLetItem(
        id: listingId,
        title: title,
        location: location,
        price: rent,
        bedrooms: bedrooms.value,
        bathrooms: bathrooms.value,
        squareFeet: 950,
        description: descriptionController.text.trim(),
        contactNumber: '+8801700000000',
        ownerName: 'Property Owner',
        images: List<String>.from(propertyPhotos),
        category: selectedTenantType.value,
        badgeText: 'Featured',
        isVerified: true,
        isAvailable: true,
        isFeatured: true,
      );

      // ============================================================
      // UPDATE LOCAL HOME CONTROLLER
      // ============================================================
      if (Get.isRegistered<HomeController>()) {
        final homeController = Get.find<HomeController>();
        homeController.featuredProperties.insert(0, newItem);
        homeController.allProperties.insert(0, newItem);
      }

      // ============================================================
      // NOTIFICATIONS
      // ============================================================
      NotificationsController.to.addNotification(
        title: '✨ Listing Published: $title',
        body:
            'Your property listing in $location has been successfully published!',
        propertyId: newItem.id,
        property: newItem,
        type: 'listing',
      );

      NotificationApiService.notifyNewListing(
        listingTitle: title,
        listingId: newItem.id,
      );

      isSubmitting.value = false;

      // ============================================================
      // SUCCESS DIALOG
      // ============================================================
      Get.dialog(
        Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
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
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
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
                      resetForm();
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
    } catch (e) {
      isSubmitting.value = false;
      debugPrint('Error publishing listing: $e');
      Get.snackbar(
        'Error',
        'Failed to publish listing: $e',
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
    }
  }

  // ============================================================
  // UPDATE LISTING
  // ============================================================

  Future<void> updateListing(String listingId) async {
    // Validation
    if (titleController.text.trim().isEmpty) {
      Get.snackbar(
        'Required',
        'Please enter property title',
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
      return;
    }

    if (locationController.text.trim().isEmpty) {
      Get.snackbar(
        'Required',
        'Please enter location',
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
      return;
    }

    if (rentController.text.trim().isEmpty) {
      Get.snackbar(
        'Required',
        'Please enter rent amount',
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
      return;
    }

    if (propertyPhotos.isEmpty) {
      Get.snackbar(
        'Required',
        'Please add at least one photo',
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
      return;
    }

    isSubmitting.value = true;

    final location = locationController.text.trim();
    String city = 'Khulna';
    String area = location;
    if (location.contains(',')) {
      final parts = location.split(',');
      area = parts[0].trim();
      city = parts.length > 1 ? parts[1].trim() : 'Khulna';
    }

    // Process and upload photos
    final List<String> finalImageUrls = [];
    final List<String> localBase64Images = [];

    for (final photo in propertyPhotos) {
      if (photo.startsWith('http://') || photo.startsWith('https://')) {
        finalImageUrls.add(photo);
      } else {
        try {
          final file = File(photo);
          if (file.existsSync()) {
            final bytes = await file.readAsBytes();
            localBase64Images.add(base64Encode(bytes));
          }
        } catch (e) {
          debugPrint('Error reading photo: $e');
        }
      }
    }

    if (localBase64Images.isNotEmpty) {
      try {
        final uploadRes = await _listingsRepo.uploadPropertyImages(localBase64Images);
        if (uploadRes.isSuccess && uploadRes.responseData?['data']?['urls'] != null) {
          final urls = (uploadRes.responseData!['data']['urls'] as List)
              .map((e) => e.toString());
          finalImageUrls.addAll(urls);
        }
      } catch (e) {
        debugPrint('Upload error: $e');
      }
    }

    if (finalImageUrls.isEmpty) {
      finalImageUrls.add('https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?w=800');
    }

    final requestBody = {
      'title': titleController.text.trim(),
      'location': location,
      'city': city,
      'area': area,
      'price': int.parse(rentController.text.trim()),
      'bedrooms': bedrooms.value,
      'bathrooms': bathrooms.value,
      'description': descriptionController.text.trim(),
      'contact_number': '+8801700000000',
      'images': finalImageUrls,
      'category': selectedTenantType.value,
      'furnishing': 'Unfurnished',
      'amenities': {
        'lift': hasLift.value,
        'parking': hasParking.value,
        'gasLine': hasGasLine.value,
        'wifi': hasWifi.value,
        'generator': false,
        'water24_7': true,
      },
      'availability': 'Available now',
      'is_direct_owner': isDirectOwner.value,
    };

    debugPrint('========== UPDATE LISTING API REQUEST ==========');
    debugPrint('Listing ID: $listingId');
    debugPrint('URL: ${Urls.allListings}/$listingId');
    debugPrint('Body: $requestBody');
    debugPrint('==============================================');

    try {
      final response = await _listingsRepo.updateListing(
        listingId,
        requestBody,
      );

      debugPrint('========== UPDATE LISTING API RESPONSE ==========');
      debugPrint('Success: ${response.isSuccess}');
      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Data: ${response.responseData}');
      debugPrint('Error: ${response.errorMessage}');
      debugPrint('==============================================');

      if (!response.isSuccess) {
        isSubmitting.value = false;
        Get.snackbar(
          'Error',
          response.errorMessage ?? 'Failed to update listing',
          backgroundColor: AppColors.error,
          colorText: Colors.white,
        );
        return;
      }

      // Update local data
      if (Get.isRegistered<HomeController>()) {
        final homeController = Get.find<HomeController>();

        // Find and update in all properties
        final index = homeController.allProperties.indexWhere(
          (item) => item.id == listingId,
        );

        if (index != -1) {
          // Create updated item
          final updatedItem = ToLetItem(
            id: listingId,
            title: titleController.text.trim(),
            location: locationController.text.trim(),
            price: double.parse(rentController.text.trim()),
            bedrooms: bedrooms.value,
            bathrooms: bathrooms.value,
            squareFeet: 950.0,
            description: descriptionController.text.trim(),
            contactNumber: '+8801700000000',
            ownerName: 'Updated Owner',
            ownerAvatar: 'https://ui-avatars.com/api/?name=Owner',
            images: finalImageUrls,
            category: selectedTenantType.value,
            badgeText: 'Available now',
            isVerified: true,
            isAvailable: true,
            isFeatured: false,
          );

          homeController.allProperties[index] = updatedItem;

          // Also update in featured if exists
          final featuredIndex = homeController.featuredProperties.indexWhere(
            (item) => item.id == listingId,
          );
          if (featuredIndex != -1) {
            homeController.featuredProperties[featuredIndex] = updatedItem;
          }
        }
      }

      isSubmitting.value = false;

      // Success dialog
      Get.dialog(
        barrierDismissible: false,
        Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80.w,
                  height: 80.w,
                  decoration: BoxDecoration(
                    color: Colors.green.withAlpha(25),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle_outline,
                    size: 48.sp,
                    color: Colors.green,
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  'Listing Updated!',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimaryLight,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Your property listing has been updated successfully.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: AppColors.textSecondaryLight,
                  ),
                ),
                SizedBox(height: 20.h),
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
                      Get.back(); // Close dialog
                      Get.back(); // Go back to previous screen
                    },
                    child: const Text(
                      'Done',
                      style: TextStyle(
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
      );
    } catch (e) {
      debugPrint('Update listing error: $e');
      isSubmitting.value = false;
      Get.snackbar(
        'Error',
        'An unexpected error occurred',
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
    }
  }

  // ============================================================
  // DELETE LISTING
  // ============================================================

  Future<void> deleteListing(String listingId) async {
    // Show confirmation dialog
    final confirm = await Get.dialog<bool>(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Listing'),
        content: const Text(
          'Are you sure you want to delete this listing? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      final response = await _listingsRepo.deleteListing(listingId);

      debugPrint('========== DELETE LISTING API RESPONSE ==========');
      debugPrint('Success: ${response.isSuccess}');
      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Error: ${response.errorMessage}');
      debugPrint('==============================================');

      if (!response.isSuccess) {
        Get.snackbar(
          'Error',
          response.errorMessage ?? 'Failed to delete listing',
          backgroundColor: AppColors.error,
          colorText: Colors.white,
        );
        return;
      }

      // Remove from local list
      if (Get.isRegistered<HomeController>()) {
        final homeController = Get.find<HomeController>();
        homeController.allProperties.removeWhere(
          (item) => item.id == listingId,
        );
        homeController.featuredProperties.removeWhere(
          (item) => item.id == listingId,
        );
      }

      Get.snackbar(
        'Success!',
        'Listing deleted successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );

      Get.back(); // Go back to previous screen
    } catch (e) {
      debugPrint('Delete listing error: $e');
      Get.snackbar(
        'Error',
        'An unexpected error occurred',
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
    }
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
