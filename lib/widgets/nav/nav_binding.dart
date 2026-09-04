
import 'package:get/get.dart';
import 'package:to_let_app_abandon/widgets/nav/nav_controller.dart';

class NavBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<NavController>(NavController(), permanent: true);
  }
}