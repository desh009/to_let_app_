import 'package:get/get.dart';
import 'package:to_let_app_abandon/screens/Profile_screen/Profile_item_screens/privacy_and_policy/controller/privacy_policy_controller.dart';


class PrivacyPolicyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PrivacyPolicyController>(() => PrivacyPolicyController());
  }
}