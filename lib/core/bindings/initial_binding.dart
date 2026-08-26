import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:to_let_app_abandon/core/services/storage_service.dart';
import 'package:to_let_app_abandon/data/datasources/tolet_local_datasource.dart';
import 'package:to_let_app_abandon/data/repositories/tolet_repository_impl.dart';
import 'package:to_let_app_abandon/domain/repositories/tolet_repository.dart';
import 'package:to_let_app_abandon/screens/saved_screen/controllers/saved_controller.dart';
import 'package:to_let_app_abandon/widgets/favourite/button/animated_favourite_button.dart';
import 'package:to_let_app_abandon/widgets/nav/nav_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<StorageService>()) {
      Get.put<StorageService>(StorageService(), permanent: true);
    }

    final storageService = Get.find<StorageService>();

    if (!Get.isRegistered<NavController>()) {
      Get.put<NavController>(NavController(), permanent: true);
    }

    Get.lazyPut<ToLetLocalDataSource>(
      () => ToLetLocalDataSourceImpl(storageService: storageService),
      fenix: true,
    );

    Get.lazyPut<ToLetRepository>(
      () => ToLetRepositoryImpl(localDataSource: Get.find<ToLetLocalDataSource>()),
      fenix: true,
    );

    if (!Get.isRegistered<FavoriteController>()) {
      Get.put<FavoriteController>(
        FavoriteController(
          repository: Get.find<ToLetRepository>(),
          storageService: storageService,
        ),
        permanent: true,
      );
       if (!Get.isRegistered<SavedController>()) {
      Get.put<SavedController>(SavedController(), permanent: true);
    }
    }
  }
}