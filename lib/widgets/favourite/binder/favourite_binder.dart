
import 'package:get/get.dart';
import 'package:to_let_app_abandon/core/services/storage_service.dart';
import 'package:to_let_app_abandon/domain/repositories/tolet_repository.dart';
import 'package:to_let_app_abandon/widgets/favourite/controller/favourite_controller.dart';

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