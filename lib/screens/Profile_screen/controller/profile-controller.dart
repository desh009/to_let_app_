// screens/profile/controllers/profile_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/constants/storage_keys.dart';
import '../../../widgets/nav/nav_controller.dart';

class ProfileController extends GetxController {
  final StorageService storageService;

  ProfileController({
    required this.storageService,
  });

  // Observables
  final RxString userName = ''.obs;
  final RxString userEmail = ''.obs;
  final RxString userPhone = ''.obs;
  final RxBool isLoading = false.obs;
  final RxInt savedCount = 0.obs;
  final RxInt listingCount = 0.obs;
  final RxInt visitsCount = 0.obs;

  // Navigation
  NavController get navController => Get.find<NavController>();

  @override
  void onInit() {
    super.onInit();
    loadUserData();
    loadStats();
  }

  void loadUserData() {
    final name = storageService.getString(StorageKeys.userName) ?? 'Desh';
    final phone = storageService.getString(StorageKeys.userPhone) ?? '+880123456789';
    
    userName.value = name;
    userPhone.value = phone;
    userEmail.value = '${name.toLowerCase()}@gmail.com';
  }

  void loadStats() {
    final favorites = storageService.favoriteProperties;
    savedCount.value = favorites.length;
    listingCount.value = 1;
    visitsCount.value = 2;
  }

  void goBack() {
    Get.back();
  }

  void navigateToSettings() {
    // Silent navigation
  }

  void navigateToMyListings() {
    // Silent navigation
  }

  void navigateToScheduledVisits() {
    // Silent navigation
  }

  void navigateToPayments() {
    // Silent navigation
  }

  void navigateToHelpSupport() {
    // Silent navigation
  }

  void logout() {
    Get.dialog(
      AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              storageService.remove(StorageKeys.userToken);
              storageService.remove(StorageKeys.userName);
              storageService.remove(StorageKeys.userPhone);
              Get.offAllNamed('/splash');
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void changeTab(int index) {
    navController.changeTab(index);
  }

  @override
  void onClose() {
    super.onClose();
  }
}