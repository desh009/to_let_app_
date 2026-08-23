import 'package:get/get.dart';
import '../../../domain/entities/tolet_item.dart';
import '../../../domain/repositories/tolet_repository.dart';

class DetailsController extends GetxController {
  final ToLetRepository repository;

  DetailsController({required this.repository});

  late final ToLetItem item;
  final RxBool isFavorite = false.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is ToLetItem) {
      item = Get.arguments as ToLetItem;
      _checkFavoriteStatus();
    }
  }

  Future<void> _checkFavoriteStatus() async {
    isFavorite.value = await repository.isFavorite(item.id);
  }

  Future<void> toggleFavorite() async {
    await repository.toggleFavorite(item.id);
    isFavorite.value = !isFavorite.value;
  }
}
