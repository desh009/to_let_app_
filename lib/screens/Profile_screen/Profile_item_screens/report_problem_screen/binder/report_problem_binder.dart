import 'package:get/get.dart';
import 'package:to_let_app_abandon/screens/Profile_screen/Profile_item_screens/report_problem_screen/controller/report_problem_controller.dart';


class ReportProblemBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReportProblemController>(() => ReportProblemController());
  }
}