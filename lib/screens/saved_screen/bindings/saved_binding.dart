import 'package:get/get.dart';
import '../../../core/services/storage_service.dart';
import '../../../data/datasources/tolet_local_datasource.dart';
import '../../../data/repositories/tolet_repository_impl.dart';
import '../controllers/saved_controller.dart';

class SavedBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SavedController>(
      () => SavedController(
        repository: ToLetRepositoryImpl(
          localDataSource: ToLetLocalDataSourceImpl(
            storageService: Get.find<StorageService>(),
          ),
        ),
        storageService: Get.find<StorageService>(),
      ),
    );
  }
}
