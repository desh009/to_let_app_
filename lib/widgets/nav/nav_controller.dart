// widgets/nav_contoller/nav_controller.dart
import 'package:get/get.dart';
import '../../routes/app_routes.dart';

class NavController extends GetxController {
  final RxInt currentIndex = 0.obs;

  // Tab Change
  void changeTab(int index) {
    if (currentIndex.value == index) return;
    currentIndex.value = index;
  }

  // Navigation Methods
  void toHome() {
    currentIndex.value = 0;
    Get.toNamed(Routes.HOME);
  }

  void toSaved() {
    currentIndex.value = 1;
    Get.toNamed(Routes.SAVED);
  }

  void toMessages() {
    currentIndex.value = 2;
    Get.toNamed(Routes.MESSAGES);
  }

  void toProfile() {
    currentIndex.value = 3;
    Get.toNamed(Routes.PROFILE);
  }

  void toDetails(dynamic property) {
    Get.toNamed(Routes.DETAILS, arguments: property);
  }

  // Navigate with replacement
  void toHomeAndRemoveAll() {
    currentIndex.value = 0;
    Get.offAllNamed(Routes.HOME);
  }

  @override
  void onClose() {
    super.onClose();
  }
}