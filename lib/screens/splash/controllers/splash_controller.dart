import 'package:flutter/animation.dart';
import 'package:get/get.dart';
import '../../../core/constants/storage_keys.dart';
import '../../../core/services/storage_service.dart';
import '../../../data/repositories/auth_repo.dart';
import '../../../routes/app_routes.dart';

class SplashController extends GetxController with GetSingleTickerProviderStateMixin {
  final StorageService storageService = Get.find<StorageService>();

  late AnimationController animationController;
  late Animation<double> scaleAnimation;

  @override
  void onInit() {
    super.onInit();
    
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    scaleAnimation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeOutBack,
    );

    animationController.forward();

    _handleSplashLogic();
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }

  Future<void> _handleSplashLogic() async {
    try {
      await Future.delayed(const Duration(seconds: 2));

      final isFirstTime = storageService.getBool(StorageKeys.isFirstTime) ?? true;
      if (isFirstTime) {
        await storageService.setBool(StorageKeys.isFirstTime, false);
      }

      final isLoggedIn = storageService.getBool(StorageKeys.isLoggedIn) ?? false;

      if (isLoggedIn) {
        // Validate session with /me API
        try {
          // Use timeout to prevent hanging on splash screen
          final response = await Get.find<AuthRepo>().getMe().timeout(
            const Duration(seconds: 5),
          );
          
          if (response.isSuccess) {
            Get.offAllNamed(Routes.HOME);
          } else if (response.statusCode == 401) {
            // Token is explicitly invalid/expired
            await storageService.setBool(StorageKeys.isLoggedIn, false);
            Get.offAllNamed(Routes.LOGIN);
          } else {
            // Other error (500, etc.), still go home
            Get.offAllNamed(Routes.HOME);
          }
        } catch (e) {
          // Network error or timeout, go to home
          print('Splash session validation error: $e');
          Get.offAllNamed(Routes.HOME);
        }
      } else {
        Get.offAllNamed(Routes.LOGIN);
      }
    } catch (e) {
      print('Critical Splash Logic Error: $e');
      // Final safety net: go to login
      Get.offAllNamed(Routes.LOGIN);
    }
  }
}
