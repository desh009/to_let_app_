import 'package:get/get.dart';
import '../../../core/services/storage_service.dart';
import '../../../domain/entities/tolet_item.dart';
import '../../../domain/repositories/tolet_repository.dart';
import '../../../widgets/custom_snackbar.dart';
import '../../../core/constants/app_strings.dart';

class SavedController extends GetxController {
  final ToLetRepository repository;
  final StorageService storageService;

  SavedController({
    required this.repository,
    required this.storageService,
  });

  final RxList<ToLetItem> savedItems = <ToLetItem>[].obs;
  final RxList<String> favoriteIds = <String>[].obs;
  final RxBool isLoading = false.obs;
  final RxString selectedFilter = 'All'.obs;

  List<String> get filterOptions {
    final cats = savedItems.map((e) => e.category).toSet().toList();
    return ['All', ...cats];
  }

  List<ToLetItem> get filteredItems {
    if (selectedFilter.value == 'All') return savedItems;
    return savedItems
        .where((e) => e.category == selectedFilter.value)
        .toList();
  }

  int countByCategory(String cat) {
    if (cat == 'All') return savedItems.length;
    return savedItems.where((e) => e.category == cat).length;
  }

  @override
  void onInit() {
    super.onInit();
    loadSaved();
  }

  Future<void> loadSaved() async {
    try {
      isLoading.value = true;
      final allProperties = await repository.getProperties();
      final favs = await repository.getFavorites();
      favoriteIds.assignAll(favs);
      savedItems.assignAll(
        allProperties.where((p) => favs.contains(p.id)).toList(),
      );
    } catch (e) {
      CustomSnackbar.showError(
        title: 'Error',
        message: 'Failed to load saved listings: $e',
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> removeFavorite(String id) async {
    await repository.toggleFavorite(id);
    favoriteIds.remove(id);
    savedItems.removeWhere((p) => p.id == id);
    CustomSnackbar.showInfo(
      title: AppStrings.removedFromSaved,
      message: 'Item removed from your saved listings.',
      duration: const Duration(seconds: 2),
    );
  }

  Future<void> clearAll() async {
    for (final item in List.from(savedItems)) {
      await repository.toggleFavorite(item.id);
    }
    favoriteIds.clear();
    savedItems.clear();
    CustomSnackbar.showInfo(
      title: AppStrings.clearAll,
      message: 'All saved listings cleared.',
      duration: const Duration(seconds: 2),
    );
  }

  void selectFilter(String filter) {
    selectedFilter.value = filter;
  }
}
