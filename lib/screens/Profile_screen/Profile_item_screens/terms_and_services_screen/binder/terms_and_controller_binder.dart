import 'package:get/get.dart';
import 'package:to_let_app_abandon/screens/Profile_screen/Profile_item_screens/terms_and_services_screen/controller/terms_and_services_controller.dart';


class TermsOfServiceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TermsOfServiceController>(() => TermsOfServiceController());
  }
}