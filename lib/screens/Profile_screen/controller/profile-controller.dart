
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/constants/storage_keys.dart';
import '../../../routes/app_routes.dart';
import '../../../widgets/nav/nav_controller.dart';

class ProfileController extends GetxController {
  final StorageService storageService;

  ProfileController({required this.storageService});


  final RxString userName = ''.obs;
  final RxString userEmail = ''.obs;
  final RxString userPhone = ''.obs;
  final RxBool isLoading = false.obs;
  final RxInt savedCount = 0.obs;
  final RxInt listingCount = 0.obs;
  final RxInt visitsCount = 0.obs;

  final RxBool isDarkMode = false.obs;


  final RxString userRole = 'tenant'.obs;


  final RxString selectedLanguage = 'en'.obs;


  NavController get navController => Get.find<NavController>();

  @override
  void onInit() {
    super.onInit();
    loadUserData();
    loadStats();
    _loadThemePrefrence();
    _loadLanguagePreference();
  }

  void loadUserData() {
    final name = storageService.getString(StorageKeys.userName) ?? 'Desh';
    final phone =
        storageService.getString(StorageKeys.userPhone) ?? '+880123456789';

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

  void _loadThemePrefrence() {
    isDarkMode.value = storageService.getBool(StorageKeys.isDarkMode) ?? false;
  }


  void _loadLanguagePreference() {
    final lang = storageService.getString(StorageKeys.language) ?? 'en';
    selectedLanguage.value = lang;

  }


  void toggleDarkMode(bool value) {
    isDarkMode.value = value;
    storageService.setBool(StorageKeys.isDarkMode, value);
    Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);
  }

  void toogleDarkMode(bool value) {
    toggleDarkMode(value);
  }
  void changeLanguage(String langCode) {
    if (selectedLanguage.value == langCode) return;

    selectedLanguage.value = langCode;
    storageService.setString(StorageKeys.language, langCode);

    Get.updateLocale(Locale(langCode));

    update();
  }


  void navigateToSettings() {
    Get.toNamed('/settings');
  }

  void navigateToHelpSupport() {
    Get.toNamed('/help-support');
  }

  void logout() {
    Get.dialog(
      AlertDialog(
        title: Text('logout'.tr),
        content: Text(
          Get.locale?.languageCode == 'bn'
              ? 'আপনি কি নিশ্চিত যে আপনি লগআউট করতে চান?'
              : 'Are you sure you want to logout?',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('cancel'.tr),
          ),
          TextButton(
            onPressed: () async {
              Get.back();
              await storageService.setBool(StorageKeys.isLoggedIn, false);
              await storageService.remove(StorageKeys.userToken);
              await storageService.remove(StorageKeys.userName);
              await storageService.remove(StorageKeys.userPhone);
              navController.currentIndex.value = 0;
              Get.offAllNamed(Routes.LOGIN);
            },
            child: Text(
              'logout'.tr,
              style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void changeTab(int index) {
    navController.changeTab(index);
  }


  void navigateToMyProperties() {
    Get.toNamed('/my-properties');
  }

  void navigateToViewingRequests() {
    Get.toNamed('/viewing-requests');
  }

  void navigateToPostAd() {
    Get.toNamed('/post-ad');
  }


  void navigateToSavedProperties() {
    Get.toNamed('/saved-properties');
  }

  void navigateToMyViewings() {
    Get.toNamed('/my-viewings');
  }

  void navigateToSearchHistory() {
    Get.toNamed('/search-history');
  }


  void navigateToMyListings() {
    Get.toNamed('/my-listings');
  }

  void navigateToScheduledVisits() {
    Get.toNamed('/scheduled-visits');
  }

  void navigateToPayments() {
    Get.toNamed('/payments');
  }

  @override
  void onClose() {
    super.onClose();
  }
}