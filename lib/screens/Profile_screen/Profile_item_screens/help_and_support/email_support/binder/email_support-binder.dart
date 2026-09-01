import 'package:get/get.dart';
import 'package:to_let_app_abandon/screens/Profile_screen/Profile_item_screens/help_and_support/email_support/controller/email_support_controller.dart';

class EmailSupportBinding extends Bindings {
  @override
  void dependencies() {
    // ADDED: Controller registered via lazyPut
    Get.lazyPut<EmailSupportController>(() => EmailSupportController());
  }
}