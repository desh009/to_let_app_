import 'package:get/get.dart';
import '../../../domain/repositories/tolet_repository.dart';
import '../controllers/details_controller.dart';

class DetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailsController>(
      () => DetailsController(repository: Get.find<ToLetRepository>()),
    );
  }
}
