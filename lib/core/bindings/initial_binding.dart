import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:to_let_app_abandon/core/services/storage_service.dart';
import 'package:to_let_app_abandon/data/datasources/tolet_local_datasource.dart';
import 'package:to_let_app_abandon/data/repositories/tolet_repository_impl.dart';
import 'package:to_let_app_abandon/domain/repositories/tolet_repository.dart';
import 'package:to_let_app_abandon/screens/saved_screen/controllers/saved_controller.dart';
import 'package:to_let_app_abandon/widgets/favourite/controller/favourite_controller.dart';
import 'package:to_let_app_abandon/data/repositories/auth_repo.dart';
import 'package:to_let_app_abandon/data/repositories/listings_repo.dart';
import 'package:to_let_app_abandon/data/repositories/user_repo.dart';
import 'package:to_let_app_abandon/data/repositories/favorites_repo.dart';
import 'package:to_let_app_abandon/data/repositories/notifications_repo.dart';
import 'package:to_let_app_abandon/data/repositories/messages_repo.dart';
import 'package:to_let_app_abandon/screens/auth/controllers/auth_controller.dart';
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
      () => ToLetRepositoryImpl(
        localDataSource: Get.find<ToLetLocalDataSource>(),
      ),
      fenix: true,
    );

    // Repositories
    if (!Get.isRegistered<AuthRepo>()) {
      Get.put<AuthRepo>(AuthRepo(), permanent: true);
    }
    if (!Get.isRegistered<ListingsRepo>()) {
      Get.put<ListingsRepo>(ListingsRepo(), permanent: true);
    }
    if (!Get.isRegistered<UserRepo>()) {
      Get.put<UserRepo>(UserRepo(), permanent: true);
    }
    if (!Get.isRegistered<FavoritesRepo>()) {
      Get.put<FavoritesRepo>(FavoritesRepo(), permanent: true);
    }
    if (!Get.isRegistered<NotificationsRepo>()) {
      Get.put<NotificationsRepo>(NotificationsRepo(), permanent: true);
    }
    if (!Get.isRegistered<MessagesRepo>()) {
      Get.put<MessagesRepo>(MessagesRepo(), permanent: true);
    }

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

    if (!Get.isRegistered<AuthController>()) {
      Get.lazyPut<AuthController>(() => AuthController(), fenix: true);
    }
  }
}
