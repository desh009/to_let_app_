import 'package:get/get.dart';
import '../../../core/services/storage_service.dart';
import '../../../data/datasources/tolet_local_datasource.dart';
import '../../../data/repositories/tolet_repository_impl.dart';
import '../../../domain/repositories/tolet_repository.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    final storageService = Get.find<StorageService>();

    // Datasource
    Get.lazyPut<ToLetLocalDataSource>(
      () => ToLetLocalDataSourceImpl(storageService: storageService),
    );

    // Repository
    Get.lazyPut<ToLetRepository>(
      () => ToLetRepositoryImpl(localDataSource: Get.find<ToLetLocalDataSource>()),
    );

    // Controller
    Get.lazyPut<HomeController>(
      () => HomeController(
        repository: Get.find<ToLetRepository>(),
        storageService: storageService,
      ),
    );
  }
}
