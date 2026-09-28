
import 'dart:async';

import 'package:get/get.dart';
import 'package:to_let_app_abandon/core/constants/storage_keys.dart';
import 'package:to_let_app_abandon/core/services/storage_service.dart';
import 'package:to_let_app_abandon/domain/entities/tolet_item.dart';
import 'package:to_let_app_abandon/domain/repositories/tolet_repository.dart';

import 'package:to_let_app_abandon/data/repositories/favorites_repo.dart';

class FavoriteAnimationEvent {
  final String itemId;
  final bool isNowFavorite;
  FavoriteAnimationEvent(this.itemId, this.isNowFavorite);
}

class FavoriteController extends GetxController {
  final ToLetRepository repository;
  final StorageService storageService;
  late final FavoritesRepo _favoritesRepo;

  FavoriteController({
    required this.repository,
    required this.storageService,
    FavoritesRepo? favoritesRepo,
  }) {
    _favoritesRepo = favoritesRepo ?? (Get.isRegistered<FavoritesRepo>() ? Get.find<FavoritesRepo>() : FavoritesRepo());
  }


  final RxList<String> favoriteIds = <String>[].obs;
  final RxList<ToLetItem> favoriteItems = <ToLetItem>[].obs;
  final RxBool isLoading = false.obs;


  final RxString animatingId = ''.obs;
  final RxBool isAnimating = false.obs;


  final StreamController<FavoriteAnimationEvent> _animationEventsController =
      StreamController<FavoriteAnimationEvent>.broadcast();
  Stream<FavoriteAnimationEvent> get animationEvents =>
      _animationEventsController.stream;

  @override
  void onInit() {
    super.onInit();
    loadFavorites();
  }

  @override
  void onClose() {

    _animationEventsController.close();
    super.onClose();
  }


  Future<void> loadFavorites() async {
    try {
      isLoading.value = true;
      final saved = storageService.favoriteProperties;
      favoriteIds.assignAll(saved);

      final allProperties = await repository.getProperties();
      favoriteItems.assignAll(
        allProperties.where((p) => saved.contains(p.id)).toList(),
      );

      // Fetch latest favorites from API if logged in
      final token = storageService.getString(StorageKeys.authToken);
      if (token != null && token.isNotEmpty) {
        final response = await _favoritesRepo.getFavorites();
        if (response.isSuccess) {
          final apiItems = _favoritesRepo.parseFavoritesList(response);
          if (apiItems.isNotEmpty) {
            favoriteItems.assignAll(apiItems);
            favoriteIds.assignAll(apiItems.map((e) => e.id));
            await storageService.setFavoriteProperties(favoriteIds);
          }
        }
      }
    } catch (e) {
      // Ignore load error
    } finally {
      isLoading.value = false;
    }
  }


  bool isFavorite(String id) {
    return favoriteIds.contains(id);
  }


  Future<void> toggleFavorite(ToLetItem item) async {
    final id = item.id;
    final bool willBeFavorite = !favoriteIds.contains(id);

    animatingId.value = id;
    isAnimating.value = true;

    if (favoriteIds.contains(id)) {
      favoriteIds.remove(id);
      favoriteItems.removeWhere((p) => p.id == id);
      await storageService.setFavoriteProperties(favoriteIds);
      await repository.toggleFavorite(id);

      // API call in background
      _favoritesRepo.removeFavorite(id);
    } else {
      favoriteIds.add(id);
      favoriteItems.add(item);
      await storageService.setFavoriteProperties(favoriteIds);
      await repository.toggleFavorite(id);

      // API call in background
      _favoritesRepo.addFavorite(id);
    }

    _animationEventsController.add(
      FavoriteAnimationEvent(id, willBeFavorite),
    );

    await Future.delayed(const Duration(milliseconds: 400));
    isAnimating.value = false;
    animatingId.value = '';
  }


  Future<void> removeFavorite(String id) async {
    if (favoriteIds.contains(id)) {
      favoriteIds.remove(id);
      favoriteItems.removeWhere((p) => p.id == id);
      await storageService.setFavoriteProperties(favoriteIds);
      await repository.toggleFavorite(id);

      // API call in background
      _favoritesRepo.removeFavorite(id);
    }
  }


  Future<void> clearAllFavorites() async {
    for (final item in List.from(favoriteItems)) {
      await repository.toggleFavorite(item.id);
    }
    favoriteIds.clear();
    favoriteItems.clear();
    await storageService.setFavoriteProperties([]);
  }


  int get favoriteCount => favoriteIds.length;


  bool get isEmpty => favoriteItems.isEmpty;


  ToLetItem? getFavoriteItem(String id) {
    try {
      return favoriteItems.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }


  Future<void> refreshFavorites() async {
    await loadFavorites();
  }
}