
import 'package:get/get.dart';
import 'package:to_let_app_abandon/screens/Profile_screen/controller/profile-controller.dart';
import '../../../core/services/storage_service.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileController>(
      () => ProfileController(
        storageService: Get.find<StorageService>(),
      ),
      fenix: true,
    );
  }
}