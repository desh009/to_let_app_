import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:to_let_app_abandon/screens/saved_screen/controllers/saved_controller.dart';

class SavedBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SavedController>(() => SavedController(), fenix: true);
  }
}