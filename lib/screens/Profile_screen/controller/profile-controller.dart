import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:to_let_app_abandon/screens/auth/controllers/auth_controller.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/constants/storage_keys.dart';
import '../../../routes/app_routes.dart';
import '../../../widgets/nav/nav_controller.dart';

import 'package:to_let_app_abandon/data/repositories/user_repo.dart';
import 'package:to_let_app_abandon/data/repositories/auth_repo.dart';
import 'package:to_let_app_abandon/data/models/user_profile_model.dart';
import 'package:to_let_app_abandon/widgets/custom_snackbar.dart';

class ProfileController extends GetxController {
  final StorageService storageService;
  late final UserRepo _userRepo;
  late final AuthRepo _authRepo;

  ProfileController({
    required this.storageService,
    UserRepo? userRepo,
    AuthRepo? authRepo,
  }) {
    _userRepo =
        userRepo ??
        (Get.isRegistered<UserRepo>() ? Get.find<UserRepo>() : UserRepo());
    _authRepo =
        authRepo ??
        (Get.isRegistered<AuthRepo>() ? Get.find<AuthRepo>() : AuthRepo());
  }

  final RxString userName = ''.obs;
  final RxString userEmail = ''.obs;
  final RxString userPhone = ''.obs;
  final RxString avatarUrl = ''.obs;
  final RxString userBio = ''.obs;
  final RxString userAddress = ''.obs;
  final RxString userCity = ''.obs;
  final Rx<UserProfileModel?> userProfile = Rx<UserProfileModel?>(null);
  final RxBool isLoading = false.obs;
  final RxInt savedCount = 0.obs;
  final RxInt listingCount = 0.obs;
  final RxInt visitsCount = 0.obs;

  final RxBool isDarkMode = false.obs;

  final RxString userRole = 'tenant'.obs;

  final RxString selectedLanguage = 'en'.obs;

  // Text Editing Controllers
  late final TextEditingController nameEditController;
  late final TextEditingController phoneEditController;
  late final TextEditingController bioEditController;
  late final TextEditingController addressEditController;
  late final TextEditingController cityEditController;

  NavController get navController => Get.find<NavController>();

  @override
  void onInit() {
    super.onInit();
    nameEditController = TextEditingController();
    phoneEditController = TextEditingController();
    bioEditController = TextEditingController();
    addressEditController = TextEditingController();
    cityEditController = TextEditingController();

    loadUserData();
    loadStats();
    fetchUserProfileFromApi();
    _loadThemePrefrence();
    _loadLanguagePreference();
  }

  void initializeEditControllers() {
    nameEditController.text = userName.value;
    phoneEditController.text = userPhone.value;
    bioEditController.text = userBio.value;
    addressEditController.text = userAddress.value;
    cityEditController.text = userCity.value;
  }

  void loadUserData() {
    final name = storageService.getString(StorageKeys.userName) ?? 'User';
    final phone = storageService.getString(StorageKeys.userPhone) ?? '';
    final email = storageService.getString(StorageKeys.userEmail) ?? '';

    userName.value = name;
    userPhone.value = phone;
    userEmail.value = email;
  }

  Future<void> fetchUserProfileFromApi() async {
    try {
      isLoading.value = true;
      final response = await _userRepo.getProfile();
      if (response.isSuccess) {
        final profile = _userRepo.parseProfile(response);
        if (profile != null) {
          userProfile.value = profile;
          userName.value = profile.name;
          userEmail.value = profile.email;
          userPhone.value = profile.phone;
          avatarUrl.value = profile.avatarUrl ?? '';
          userBio.value = profile.bio;
          userAddress.value = profile.address;
          userCity.value = profile.city;
          userRole.value = profile.role;
          listingCount.value = profile.listingsCount;
          savedCount.value = profile.favoritesCount;

          // Save to local storage cache
          await storageService.setString(StorageKeys.userName, profile.name);
          await storageService.setString(StorageKeys.userEmail, profile.email);
          await storageService.setString(StorageKeys.userPhone, profile.phone);
        }
      }
    } catch (e) {
      debugPrint('Error fetching user profile: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateUserProfile({
    String? name,
    String? phone,
    String? bio,
    String? address,
    String? city,
  }) async {
    try {
      isLoading.value = true;
      final response = await _userRepo.updateProfile(
        name: name,
        phone: phone,
        bio: bio,
        address: address,
        city: city,
      );

      if (response.isSuccess) {
        if (name != null) userName.value = name;
        if (phone != null) userPhone.value = phone;
        if (bio != null) userBio.value = bio;
        if (address != null) userAddress.value = address;
        if (city != null) userCity.value = city;

        CustomSnackbar.showSuccess(
          title: 'Success',
          message: 'Profile updated successfully!',
        );
        return true;
      } else {
        CustomSnackbar.showError(
          title: 'Error',
          message: response.errorMessage ?? 'Failed to update profile.',
        );
        return false;
      }
    } catch (e) {
      CustomSnackbar.showError(
        title: 'Error',
        message: 'An unexpected error occurred: $e',
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> uploadAvatar(String base64Image) async {
    try {
      isLoading.value = true;
      final response = await _userRepo.uploadAvatar(base64Image);

      // Handle response based on provided JSON structure (avatarUrl at root or inside data)
      String? url;
      if (response.isSuccess && response.responseData != null) {
        url =
            response.responseData!['avatarUrl']?.toString() ??
            response.responseData!['data']?['avatarUrl']?.toString();
      }

      if (url != null) {
        avatarUrl.value = url;
        CustomSnackbar.showSuccess(
          title: 'Success',
          message: 'Avatar updated successfully!',
        );
        return true;
      } else {
        CustomSnackbar.showError(
          title: 'Error',
          message: response.errorMessage ?? 'Failed to upload avatar.',
        );
        return false;
      }
    } catch (e) {
      CustomSnackbar.showError(
        title: 'Error',
        message: 'An unexpected error occurred: $e',
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> changePassword({
    String? currentPassword,
    required String newPassword,
  }) async {
    try {
      isLoading.value = true;
      final response = await _userRepo.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      if (response.isSuccess) {
        CustomSnackbar.showSuccess(
          title: 'Success',
          message: 'Password changed successfully!',
        );
        return true;
      } else {
        CustomSnackbar.showError(
          title: 'Error',
          message: response.errorMessage ?? 'Failed to change password.',
        );
        return false;
      }
    } catch (e) {
      CustomSnackbar.showError(
        title: 'Error',
        message: 'An unexpected error occurred: $e',
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  void loadStats() {
    final favorites = storageService.favoriteProperties;
    savedCount.value = favorites.length;
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
          TextButton(onPressed: () => Get.back(), child: Text('cancel'.tr)),
          TextButton(
            onPressed: () async {
              Get.back();
              try {
                await _authRepo.logout();
              } catch (_) {}
              await storageService.setBool(StorageKeys.isLoggedIn, false);
              await storageService.remove(StorageKeys.authToken);
              await storageService.remove(StorageKeys.userToken);
              await storageService.remove(StorageKeys.userName);
              await storageService.remove(StorageKeys.userPhone);
              await storageService.remove(StorageKeys.userEmail);
              if (Get.isRegistered<AuthController>()) {
                await Get.find<AuthController>().loadBiometricSettings();
              }
              navController.currentIndex.value = 0;
              Get.offAllNamed(Routes.LOGIN);
            },
            child: Text(
              'logout'.tr,
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
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
    nameEditController.dispose();
    phoneEditController.dispose();
    bioEditController.dispose();
    addressEditController.dispose();
    cityEditController.dispose();
    super.onClose();
  }
}
