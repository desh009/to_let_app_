import 'package:get/get.dart';
import 'package:to_let_app_abandon/widgets/favourite/controller/favourite_controller.dart';
import '../../../domain/entities/tolet_item.dart';

class DetailsController extends GetxController {
  final FavoriteController favoriteController = Get.find<FavoriteController>();

  late final ToLetItem item;

  bool get isFavorite => favoriteController.isFavorite(item.id);

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is ToLetItem) {
      item = Get.arguments as ToLetItem;
    }
  }

  Future<void> toggleFavorite() async {
    await favoriteController.toggleFavorite(item);
  }
}