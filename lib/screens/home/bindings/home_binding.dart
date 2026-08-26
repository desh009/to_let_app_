import 'package:get/get.dart';
import 'package:to_let_app_abandon/widgets/nav/nav_controller.dart';
import '../../../core/services/storage_service.dart';
import '../../../data/datasources/tolet_local_datasource.dart';
import '../../../data/repositories/tolet_repository_impl.dart';
import '../../../domain/repositories/tolet_repository.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    final storageService = Get.find<StorageService>();
    
    // NavController
    if (!Get.isRegistered<NavController>()) {
      Get.put<NavController>(NavController(), permanent: true);
    }

    // Datasource
    Get.lazyPut<ToLetLocalDataSource>(
      () => ToLetLocalDataSourceImpl(storageService: storageService),
      fenix: true,
    );

    // Repository
    Get.lazyPut<ToLetRepository>(
      () => ToLetRepositoryImpl(
        localDataSource: Get.find<ToLetLocalDataSource>(),
      ),
      fenix: true,
    );

   

    // HomeController
    Get.lazyPut<HomeController>(
      () => HomeController(
        repository: Get.find<ToLetRepository>(),
        storageService: storageService,
      ),
      fenix: true,
    );
  }
}