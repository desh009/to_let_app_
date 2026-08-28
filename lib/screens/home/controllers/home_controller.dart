// screens/home/controllers/home_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:to_let_app_abandon/widgets/favourite/controller/favourite_controller.dart';
import 'package:to_let_app_abandon/widgets/nav/nav_controller.dart';
import '../../../core/constants/storage_keys.dart';
import '../../../core/services/storage_service.dart';
import '../../../domain/entities/tolet_item.dart';
import '../../../domain/repositories/tolet_repository.dart';

class HomeController extends GetxController {
  final ToLetRepository repository;
  final StorageService storageService;

  NavController get navController => Get.find<NavController>();
  FavoriteController get favoriteController => Get.find<FavoriteController>();

  HomeController({required this.repository, required this.storageService});

  final RxList<ToLetItem> allProperties = <ToLetItem>[].obs;
  final RxList<ToLetItem> featuredProperties = <ToLetItem>[].obs;
  final RxList<ToLetItem> recommendedProperties = <ToLetItem>[].obs;
  final RxBool isLoading = false.obs;

  final RxString selectedLocation = 'Dhaka, Bangladesh'.obs;
  final RxString selectedCategory = 'Family'.obs;
  final RxString searchQuery = ''.obs;

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
    _syncNavIndex();
  }

  void _syncNavIndex() {
    currentNavIndex.value = navController.currentIndex.value;
    ever(navController.currentIndex, (index) {
      currentNavIndex.value = index;
    });
  }

  void _loadUserPreferences() {
    isDarkMode.value = storageService.getBool(StorageKeys.isDarkMode) ?? false;
    final storedName = storageService.getString(StorageKeys.userName);
    savedUserName.value = (storedName != null && storedName.isNotEmpty)
        ? storedName
        : 'Desh';
    savedUserPhone.value =
        storageService.getString(StorageKeys.userPhone) ?? '';
    final lastSearch =
        storageService.getString(StorageKeys.savedSearchQuery) ?? '';
    if (lastSearch.isNotEmpty) {
      searchQuery.value = lastSearch;
    }
  }

  Future<void> loadProperties() async {
    try {
      isLoading.value = true;
      final properties = await repository.getProperties();
      allProperties.assignAll(properties);

      await favoriteController.loadFavorites();
      _filterSections();
    } catch (e) {
      // Silent - no snackbar
    } finally {
      isLoading.value = false;
    }
  }

  void _filterSections() {
    final featured = allProperties.where((p) => p.isFeatured).toList();
    featuredProperties.assignAll(
      featured.isNotEmpty ? featured : allProperties.take(2).toList(),
    );

    final recommended = allProperties.where((p) => !p.isFeatured).toList();
    recommendedProperties.assignAll(
      recommended.isNotEmpty ? recommended : allProperties.skip(2).toList(),
    );
  }

  void selectCategory(String category) {
    if (selectedCategory.value == category) {
      selectedCategory.value = '';
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
    final matching = allProperties
        .where((item) => item.category.toLowerCase() == cat)
        .toList();

    if (matching.isNotEmpty) {
      featuredProperties.assignAll(matching);
      recommendedProperties.assignAll(matching);
    } else {
      _filterSections();
    }
  }

  void updateLocation(String location) {
    selectedLocation.value = location;
  }

  // ============ NAVIGATION METHODS ============

  void changeNavTab(int index) {
    navController.changeTab(index);
  }

  void navigateToDetails(ToLetItem item) {
    navController.toDetails(item);
  }

  void navigateToSaved() {
    navController.toSaved();
  }

  void navigateToMessages() {
    navController.toMessages();
  }

  // void navigateToProfile() {
  //   navController.toProfile();
  // }

  void navigateToPostListing() {
    // Silent navigation - no snackbar
  }

  void navigateToMapView() {
    // Silent navigation - no snackbar
  }

  // ============ FAVORITE METHODS ============

  Future<void> toggleFavorite(ToLetItem item) async {
    await favoriteController.toggleFavorite(item);
  }

  bool isFavorite(String id) {
    return favoriteController.isFavorite(id);
  }

  int get favoriteCount => favoriteController.favoriteCount;

  // ============ THEME METHODS ============

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    storageService.setBool(StorageKeys.isDarkMode, isDarkMode.value);
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }

  // ============ PROFILE METHODS ============

  Future<void> updateUserProfile(String name, String phone) async {
    savedUserName.value = name;
    savedUserPhone.value = phone;
    await storageService.setString(StorageKeys.userName, name);
    await storageService.setString(StorageKeys.userPhone, phone);
  }

  // ============ SEARCH METHODS ============

  void updateSearchQuery(String query) {
    searchQuery.value = query;
    if (query.isNotEmpty) {
      storageService.setString(StorageKeys.savedSearchQuery, query);
    }
  }

  void clearSearch() {
    searchQuery.value = '';
    storageService.remove(StorageKeys.savedSearchQuery);
  }

  ToLetItem? getPropertyById(String id) {
    try {
      return allProperties.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> refreshData() async {
    await loadProperties();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
