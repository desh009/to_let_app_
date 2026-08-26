// controllers/favorite_controller.dart
import 'package:get/get.dart';
import 'package:to_let_app_abandon/core/services/storage_service.dart';
import 'package:to_let_app_abandon/domain/entities/tolet_item.dart';
import 'package:to_let_app_abandon/domain/repositories/tolet_repository.dart';


class FavoriteController extends GetxController {
  final ToLetRepository repository;
  final StorageService storageService;

  FavoriteController({
    required this.repository,
    required this.storageService,
  });

  // Observables
  final RxList<String> favoriteIds = <String>[].obs;
  final RxList<ToLetItem> favoriteItems = <ToLetItem>[].obs;
  final RxBool isLoading = false.obs;

  // Animation related
  final RxString animatingId = ''.obs;
  final RxBool isAnimating = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadFavorites();
  }

  // Load favorites from storage
  Future<void> loadFavorites() async {
    try {
      isLoading.value = true;
      final saved = storageService.favoriteProperties;
      favoriteIds.assignAll(saved);
      
      // Load full items if needed
      final allProperties = await repository.getProperties();
      favoriteItems.assignAll(
        allProperties.where((p) => saved.contains(p.id)).toList(),
      );
    } catch (e) {
      // Silent error
    } finally {
      isLoading.value = false;
    }
  }

  // Check if item is favorite
  bool isFavorite(String id) {
    return favoriteIds.contains(id);
  }

  // Toggle favorite with animation
  Future<void> toggleFavorite(ToLetItem item) async {
    final id = item.id;
    
    // Start animation
    animatingId.value = id;
    isAnimating.value = true;

    // Toggle logic
    if (favoriteIds.contains(id)) {
      // Remove from favorites
      favoriteIds.remove(id);
      favoriteItems.removeWhere((p) => p.id == id);
      
      // Update storage
      await storageService.setFavoriteProperties(favoriteIds);
      await repository.toggleFavorite(id);
    } else {
      // Add to favorites
      favoriteIds.add(id);
      favoriteItems.add(item);
      
      // Update storage
      await storageService.setFavoriteProperties(favoriteIds);
      await repository.toggleFavorite(id);
    }

    // End animation after a delay
    await Future.delayed(const Duration(milliseconds: 400));
    isAnimating.value = false;
    animatingId.value = '';
  }

  // Remove from favorites (without animation)
  Future<void> removeFavorite(String id) async {
    if (favoriteIds.contains(id)) {
      favoriteIds.remove(id);
      favoriteItems.removeWhere((p) => p.id == id);
      await storageService.setFavoriteProperties(favoriteIds);
      await repository.toggleFavorite(id);
    }
  }

  // Clear all favorites
  Future<void> clearAllFavorites() async {
    for (final item in List.from(favoriteItems)) {
      await repository.toggleFavorite(item.id);
    }
    favoriteIds.clear();
    favoriteItems.clear();
    await storageService.setFavoriteProperties([]);
  }

  // Get favorite count
  int get favoriteCount => favoriteIds.length;

  // Check if favorite items are empty
  bool get isEmpty => favoriteItems.isEmpty;

  // Get favorite item by id
  ToLetItem? getFavoriteItem(String id) {
    try {
      return favoriteItems.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  // Refresh favorites
  Future<void> refreshFavorites() async {
    await loadFavorites();
  }
}