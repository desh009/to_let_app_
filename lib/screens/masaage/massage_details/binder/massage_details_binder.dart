
import 'package:get/get.dart';
import 'package:to_let_app_abandon/screens/masaage/massage_details/controller/massage_details-controller.dart';

class ChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChatController>(
      () => ChatController(),
      fenix: true,
    );
  }
}