import 'package:get/get.dart';
import 'package:to_let_app_abandon/widgets/favourite/controller/favourite_controller.dart';
import '../../../domain/entities/tolet_item.dart';
import '../../../widgets/custom_snackbar.dart';
import '../../../core/constants/app_strings.dart';

class SavedController extends GetxController {
  final FavoriteController favoriteController = Get.find<FavoriteController>();

  final RxString selectedFilter = 'All'.obs;

  // নিজের savedItems না রেখে সরাসরি FavoriteController-এর রিঅ্যাক্টিভ লিস্ট রেফার করুন
  RxList<ToLetItem> get savedItems => favoriteController.favoriteItems;
  RxBool get isLoading => favoriteController.isLoading;

  List<String> get filterOptions {
    final cats = savedItems.map((e) => e.category).toSet().toList();
    return ['All', ...cats];
  }

  List<ToLetItem> get filteredItems {
    if (selectedFilter.value == 'All') return savedItems;
    return savedItems.where((e) => e.category == selectedFilter.value).toList();
  }

  int countByCategory(String cat) {
    if (cat == 'All') return savedItems.length;
    return savedItems.where((e) => e.category == cat).length;
  }

  Future<void> removeFavorite(String id) async {
    final item = favoriteController.getFavoriteItem(id);
    if (item != null) {
      await favoriteController.toggleFavorite(item);
    }
    CustomSnackbar.showInfo(
      title: AppStrings.removedFromSaved,
      message: 'Item removed from your saved listings.',
      duration: const Duration(seconds: 2),
    );
  }

  Future<void> clearAll() async {
    await favoriteController.clearAllFavorites();
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