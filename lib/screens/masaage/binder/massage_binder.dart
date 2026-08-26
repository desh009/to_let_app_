// bindings/messages_binding.dart
import 'package:get/get.dart';
import 'package:to_let_app_abandon/screens/masaage/controller/massage_controller.dart';

class MessagesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MessagesController>(
      () => MessagesController(),
      fenix: true, // Keeps controller alive even when not in use
    );
  }
}