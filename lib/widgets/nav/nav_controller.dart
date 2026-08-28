// widgets/nav_contoller/nav_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:to_let_app_abandon/screens/home/LayOut/items/Items/custom_bottom_nav_bar.dart';
import '../../routes/app_routes.dart';

class NavController extends GetxController {
  final RxInt currentIndex = 0.obs;

  // ── Reusable bottom nav bar ──────────────────────────────────
  // Any screen just does: bottomNavigationBar: navController.bottomNavBar
  // All the tab-switching logic lives here, once — no need to repeat
  // switch/onTap code in every screen.
  Widget get bottomNavBar => Obx(
    () =>
        CustomBottomNavBar(currentIndex: currentIndex.value, onTap: _onNavTap),
  );

  void _onNavTap(int index) {
    if (currentIndex.value == index) return;
    switch (index) {
      case 0:
        toHome();
        break;
      case 1:
        toSaved();
        break;
      case 2:
        toMessages();
        break;
      case 3:
        // Profile route not wired up yet — just update the highlighted tab.
        toProfile();
        break;
    }
  }

  // Tab Change (updates highlight only, no navigation)
  void changeTab(int index) {
    if (currentIndex.value == index) return;
    currentIndex.value = index;
  }

  // Navigation Methods
  // Using offNamed instead of toNamed for tab switches so the stack
  // doesn't keep growing every time someone taps between tabs.
  void toHome() {
    currentIndex.value = 0;
    Get.offNamed(Routes.HOME);
  }

  void toSaved() {
    currentIndex.value = 1;
    Get.offNamed(Routes.SAVED);
  }

  void toMessages() {
    currentIndex.value = 2;
    Get.offNamed(Routes.MESSAGES);
  }

  void toProfile() {
    currentIndex.value = 3;
    Get.offNamed(Routes.PROFILE);
  }

  void toDetails(dynamic property) {
    Get.toNamed(Routes.DETAILS, arguments: property);
  }

  // Navigate with replacement
  void toHomeAndRemoveAll() {
    currentIndex.value = 0;
    Get.offAllNamed(Routes.HOME);
  }

  @override
  void onClose() {
    super.onClose();
  }
}
