// bindings/favorite_binding.dart
import 'package:get/get.dart';
import 'package:to_let_app_abandon/core/services/storage_service.dart';
import 'package:to_let_app_abandon/domain/repositories/tolet_repository.dart';
import 'package:to_let_app_abandon/widgets/favourite/button/animated_favourite_button.dart';

class FavoriteBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FavoriteController>(
      () => FavoriteController(
        repository: Get.find<ToLetRepository>(),
        storageService: Get.find<StorageService>(),
      ),
      fenix: true,
    );
  }
}