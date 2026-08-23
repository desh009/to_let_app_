import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/storage_keys.dart';
import '../../../core/services/storage_service.dart';
import '../../../domain/entities/tolet_item.dart';
import '../../../domain/repositories/tolet_repository.dart';
import '../../../routes/app_routes.dart';
import '../../../widgets/custom_snackbar.dart';

class HomeController extends GetxController {
  final ToLetRepository repository;
  final StorageService storageService;

  HomeController({
    required this.repository,
    required this.storageService,
  });

  // Observables
  final RxList<ToLetItem> allProperties = <ToLetItem>[].obs;
  final RxList<ToLetItem> featuredProperties = <ToLetItem>[].obs;
  final RxList<ToLetItem> recommendedProperties = <ToLetItem>[].obs;
  final RxList<String> favoriteIds = <String>[].obs;
  final RxBool isLoading = false.obs;

  // Search & Filters
  final RxString selectedLocation = 'Dhaka, Bangladesh'.obs;
  final RxString selectedCategory = 'Family'.obs;
  final RxString searchQuery = ''.obs;

  // Navigation & User Preferences
  final RxInt currentNavIndex = 0.obs;
  final RxBool isDarkMode = false.obs;
  final RxString savedUserName = 'Desh'.obs;
  final RxString savedUserPhone = ''.obs;

  final List<String> availableLocations = [
    'Dhaka, Bangladesh',
    'Gulshan, Dhaka',
    'Banani, Dhaka',
    'Dhanmondi, Dhaka',
    'Uttara, Dhaka',
    'Bashundhara R/A, Dhaka',
    'Mirpur, Dhaka',
    'Chattogram, Bangladesh',
    'Sylhet, Bangladesh',
  ];

  @override
  void onInit() {
    super.onInit();
    _loadUserPreferences();
    loadProperties();
  }

  void _loadUserPreferences() {
    isDarkMode.value = storageService.getBool(StorageKeys.isDarkMode) ?? false;
    final storedName = storageService.getString(StorageKeys.userName);
    savedUserName.value = (storedName != null && storedName.isNotEmpty) ? storedName : 'Desh';
    savedUserPhone.value = storageService.getString(StorageKeys.userPhone) ?? '';
    final lastSearch = storageService.getString(StorageKeys.savedSearchQuery) ?? '';
    if (lastSearch.isNotEmpty) {
      searchQuery.value = lastSearch;
    }
  }

  Future<void> loadProperties() async {
    try {
      isLoading.value = true;
      final properties = await repository.getProperties();
      allProperties.assignAll(properties);

      final favs = await repository.getFavorites();
      favoriteIds.assignAll(favs);

      _filterSections();
    } catch (e) {
      CustomSnackbar.showError(
        title: 'Error',
        message: 'Failed to load properties: $e',
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _filterSections() {
    // Featured properties: Items marked featured, optionally filtered by category
    final featured = allProperties.where((p) => p.isFeatured).toList();
    featuredProperties.assignAll(featured.isNotEmpty ? featured : allProperties.take(2).toList());

    // Recommended properties: The remaining items or non-featured items
    final recommended = allProperties.where((p) => !p.isFeatured).toList();
    recommendedProperties.assignAll(recommended.isNotEmpty ? recommended : allProperties.skip(2).toList());
  }

  void selectCategory(String category) {
    if (selectedCategory.value == category) {
      selectedCategory.value = ''; // toggle off
    } else {
      selectedCategory.value = category;
    }
    _applyCategoryFilter();
  }

  void _applyCategoryFilter() {
    if (selectedCategory.value.isEmpty) {
      _filterSections();
      return;
    }

    final cat = selectedCategory.value.toLowerCase();
    final matching = allProperties.where((item) => item.category.toLowerCase() == cat).toList();

    if (matching.isNotEmpty) {
      featuredProperties.assignAll(matching);
      recommendedProperties.assignAll(matching);
    } else {
      _filterSections();
    }
  }

  void updateLocation(String location) {
    selectedLocation.value = location;
    CustomSnackbar.showInfo(
      title: 'Location Changed',
      message: 'Now showing properties in $location',
      duration: const Duration(seconds: 2),
    );
  }

  void changeNavTab(int index) {
    currentNavIndex.value = index;
    switch (index) {
      case 1:
        Get.toNamed(Routes.SAVED);
        break;
      case 2:
        CustomSnackbar.showInfo(
          title: 'Messages',
          message: 'Messages screen coming soon!',
        );
        break;
      case 3:
        CustomSnackbar.showInfo(
          title: 'Profile',
          message: 'Profile screen coming soon!',
        );
        break;
      default:
        break;
    }
  }

  Future<void> toggleFavorite(String id) async {
    await repository.toggleFavorite(id);
    if (favoriteIds.contains(id)) {
      favoriteIds.remove(id);
    } else {
      favoriteIds.add(id);
    }
  }

  bool isFavorite(String id) => favoriteIds.contains(id);

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    storageService.setBool(StorageKeys.isDarkMode, isDarkMode.value);
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }

  Future<void> updateUserProfile(String name, String phone) async {
    savedUserName.value = name;
    savedUserPhone.value = phone;
    await storageService.setString(StorageKeys.userName, name);
    await storageService.setString(StorageKeys.userPhone, phone);
    CustomSnackbar.showSuccess(
      title: 'Profile Updated',
      message: 'Preferences saved to SharedPreferences successfully!',
    );
  }
}
