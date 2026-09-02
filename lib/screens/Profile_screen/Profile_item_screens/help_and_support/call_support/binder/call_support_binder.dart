import 'package:get/get.dart';
import 'package:to_let_app_abandon/screens/Profile_screen/Profile_item_screens/help_and_support/call_support/controller/call_support_controller.dart';

class CallUsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CallUsController>(() => CallUsController());
  }
}