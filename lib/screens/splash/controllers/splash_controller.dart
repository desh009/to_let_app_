import 'package:get/get.dart';
import '../../../core/constants/storage_keys.dart';
import '../../../core/services/storage_service.dart';
import '../../../routes/app_routes.dart';

class SplashController extends GetxController {
  final StorageService storageService = Get.find<StorageService>();

  @override
  void onInit() {
    super.onInit();
    _handleSplashLogic();
  }

  Future<void> _handleSplashLogic() async {

    await Future.delayed(const Duration(seconds: 2));


    final isFirstTime = storageService.getBool(StorageKeys.isFirstTime) ?? true;
    if (isFirstTime) {
      await storageService.setBool(StorageKeys.isFirstTime, false);
    }


    final isLoggedIn = storageService.getBool(StorageKeys.isLoggedIn) ?? false;


    if (isLoggedIn) {
      Get.offNamed(Routes.HOME);
    } else {
      Get.offNamed(Routes.LOGIN);
    }
  }
}
