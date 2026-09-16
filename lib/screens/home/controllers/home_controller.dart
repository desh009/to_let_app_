import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:to_let_app_abandon/data/models/listing_model.dart';
import 'package:to_let_app_abandon/data/repositories/listings_repo.dart';
import 'package:to_let_app_abandon/widgets/favourite/controller/favourite_controller.dart';
import 'package:to_let_app_abandon/widgets/nav/nav_controller.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/storage_keys.dart';
import '../../../core/services/storage_service.dart';
import '../../../domain/entities/tolet_item.dart';
import '../../../domain/repositories/tolet_repository.dart';

class HomeController extends GetxController {
  final ToLetRepository repository;
  final StorageService storageService;
  final ListingsRepo _listingsRepo = ListingsRepo();

  NavController get navController => Get.find<NavController>();
  FavoriteController get favoriteController => Get.find<FavoriteController>();

  HomeController({required this.repository, required this.storageService});

  final RxList<ToLetItem> allProperties = <ToLetItem>[].obs;
  final RxList<ListingModel> apiListings = <ListingModel>[].obs;
  final RxList<ToLetItem> featuredProperties = <ToLetItem>[].obs;
  final RxList<ToLetItem> recommendedProperties = <ToLetItem>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;

  final Rx<PaginationModel?> pagination = Rx<PaginationModel?>(null);

  final RxString selectedLocation = 'Khulna, Bangladesh'.obs;
  final RxString selectedCategory = ''.obs;
  final RxString searchQuery = ''.obs;

  final RxInt currentNavIndex = 0.obs;
  final RxBool isDarkMode = false.obs;
  final RxString savedUserName = 'Desh'.obs;
  final RxString savedUserPhone = ''.obs;
  final RxString timeGreeting = ''.obs;
  Timer? _greetingTimer;

  final List<String> availableLocations = [
    'Khulna, Bangladesh',
    'Sonadanga, Khulna',
    'Khalishpur, Khulna',
    'Boyra, Khulna',
    'Nirala, Khulna',
    'Daulatpur, Khulna',
    'Shiromoni, Khulna',
    'KUET Area, Khulna',
    'Fulbarigate, Khulna',
    'Moylapota, Khulna',
    'Shibbari, Khulna',
    'Gollamari, Khulna',
    'Rupsha, Khulna',
    'Tutpara, Khulna',
    'KDA Avenue, Khulna',
    'Royal Mor, Khulna',
    'Dakbangla, Khulna',
    'Teligati, Khulna',
    'Gilatala, Khulna',
    'Khulna Sadar, Khulna',
  ];

  @override
  void onInit() {
    super.onInit();
    _loadUserPreferences();
    _updateTimeGreeting();
    _greetingTimer = Timer.periodic(
      const Duration(minutes: 1),
      (_) => _updateTimeGreeting(),
    );
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
    // Reset search query and category on launch so home always populates full listings
    searchQuery.value = '';
    selectedCategory.value = '';
    storageService.remove(StorageKeys.savedSearchQuery);
  }

  void _updateTimeGreeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      timeGreeting.value = 'Good morning';
    } else if (hour < 17) {
      timeGreeting.value = 'Good afternoon';
    } else if (hour < 21) {
      timeGreeting.value = 'Good evening';
    } else {
      timeGreeting.value = 'Good night';
    }
  }

  @override
  void onClose() {
    _greetingTimer?.cancel();
    super.onClose();
  }

  Future<void> loadProperties() async {
    try {
      isLoading.value = true;

      // Fetch from API - using /api/listings
      final response = await _listingsRepo.getAllListings(offset: 0, limit: 20);

      if (response.isSuccess) {
        final listingsResponse = _listingsRepo.parseListingsResponse(response);

        if (listingsResponse != null) {
          apiListings.assignAll(listingsResponse.data);
          pagination.value = listingsResponse.pagination;

          // Convert API listings to ToLetItem format for existing UI
          allProperties.assignAll(_convertToToLetItems(listingsResponse.data));

          await favoriteController.loadFavorites();
          _applyFilters();
        }
      } else {
        // Fallback to local repository if API fails
        final properties = await repository.getProperties();
        allProperties.assignAll(properties);
        await favoriteController.loadFavorites();
        _applyFilters();

        Get.snackbar(
          'Notice',
          'Using cached data. ${response.errorMessage ?? "API unavailable"}',
          backgroundColor: AppColors.secondary,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      debugPrint('Error loading properties: $e');
      // Fallback to local data
      try {
        final properties = await repository.getProperties();
        allProperties.assignAll(properties);
        await favoriteController.loadFavorites();
        _applyFilters();
      } catch (localError) {
        debugPrint('Error loading local properties: $localError');
      }
    } finally {
      isLoading.value = false;
    }
  }

  // Load more listings (pagination)
  Future<void> loadMoreProperties() async {
    if (isLoadingMore.value ||
        pagination.value == null ||
        !pagination.value!.hasMore) {
      return;
    }

    try {
      isLoadingMore.value = true;

      final response = await _listingsRepo.getAllListings(
        offset: pagination.value!.offset + pagination.value!.limit,
        limit: 20,
      );

      if (response.isSuccess) {
        final listingsResponse = _listingsRepo.parseListingsResponse(response);

        if (listingsResponse != null) {
          apiListings.addAll(listingsResponse.data);
          pagination.value = listingsResponse.pagination;

          allProperties.addAll(_convertToToLetItems(listingsResponse.data));
          _applyFilters();
        }
      }
    } catch (e) {
      debugPrint('Error loading more properties: $e');
    } finally {
      isLoadingMore.value = false;
    }
  }

  // Convert API ListingModel to ToLetItem
  List<ToLetItem> _convertToToLetItems(List<ListingModel> listings) {
    return listings.map((listing) {
      return ToLetItem(
        id: listing.id.toString(),
        title: listing.title,
        location: listing.location,
        price: listing.price.toDouble(),
        bedrooms: listing.bedrooms,
        bathrooms: listing.bathrooms,
        squareFeet: (listing.squareFeet ?? 1000).toDouble(),
        description: listing.description ?? '',
        contactNumber: listing.contactNumber,
        ownerName: listing.ownerName ?? 'Owner',
        images: listing.images.isNotEmpty
            ? listing.images
            : [listing.imageUrl ?? 'https://via.placeholder.com/400'],
        category: listing.category,
        badgeText: listing.availability,
        isVerified: listing.isDirectOwner,
        isAvailable: listing.availability == 'Available now',
        isFeatured: listing.id <= 5, // First 5 are featured
      );
    }).toList();
  }

  void _filterSections() {
    final featured = allProperties.where((p) => p.isFeatured).toList();
    featuredProperties.assignAll(
      featured.isNotEmpty ? featured : allProperties.take(4).toList(),
    );

    final recommended = allProperties.where((p) => !p.isFeatured).toList();
    recommendedProperties.assignAll(
      recommended.isNotEmpty ? recommended : allProperties.skip(4).toList(),
    );
  }

  void selectCategory(String category) {
    if (selectedCategory.value == category) {
      selectedCategory.value = '';
    } else {
      selectedCategory.value = category;
    }
    _applyFilters();
  }

  void _applyFilters() {
    List<ToLetItem> filtered = allProperties;

    final selectedCat = selectedCategory.value.trim().toLowerCase();
    if (selectedCat.isNotEmpty && selectedCat != 'all') {
      filtered = filtered
          .where((item) => item.category.toLowerCase() == selectedCat)
          .toList();
    }

    final query = searchQuery.value.trim().toLowerCase();
    if (query.isNotEmpty) {
      filtered = filtered.where((item) {
        return item.title.toLowerCase().contains(query) ||
            item.location.toLowerCase().contains(query) ||
            item.description.toLowerCase().contains(query) ||
            item.category.toLowerCase().contains(query);
      }).toList();
    }

    if (selectedCat.isEmpty && query.isEmpty) {
      _filterSections();
    } else {
      final featured = filtered.where((p) => p.isFeatured).toList();
      final recommended = filtered.where((p) => !p.isFeatured).toList();

      if (featured.isEmpty && recommended.isEmpty) {
        featuredProperties.assignAll(filtered);
        recommendedProperties.clear();
      } else {
        featuredProperties.assignAll(featured);
        recommendedProperties.assignAll(recommended);
      }
    }
  }

  void updateLocation(String location) {
    selectedLocation.value = location;
  }

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

  void navigateToPostListing() {
    navController.toPostListing();
  }

  void navigateToMapView() {}

  Future<void> toggleFavorite(ToLetItem item) async {
    await favoriteController.toggleFavorite(item);
  }

  bool isFavorite(String id) {
    return favoriteController.isFavorite(id);
  }

  int get favoriteCount => favoriteController.favoriteCount;

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
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
    if (query.isNotEmpty) {
      storageService.setString(StorageKeys.savedSearchQuery, query);
    } else {
      storageService.remove(StorageKeys.savedSearchQuery);
    }
    _applyFilters();
  }

  void clearSearch() {
    searchQuery.value = '';
    storageService.remove(StorageKeys.savedSearchQuery);
    _applyFilters();
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
}
