import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class CallUsController extends GetxController {
  final RxBool isDialing = false.obs;


  Future<void> dialNumber(String phoneNumber) async {
    isDialing.value = true;
    try {
      final Uri telUri = Uri(scheme: 'tel', path: phoneNumber);

      if (await canLaunchUrl(telUri)) {
        await launchUrl(telUri);
      } else {
        Get.snackbar(
          'Error',
          'Could not open phone dialer',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (_) {
      Get.snackbar(
        'Error',
        'Something went wrong. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isDialing.value = false;
    }
  }


  void handleBack() => Get.back();
}