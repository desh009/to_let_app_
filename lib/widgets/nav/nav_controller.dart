
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:to_let_app_abandon/screens/home/LayOut/items/Items/custom_bottom_nav_bar.dart';
import '../../routes/app_routes.dart';

class NavController extends GetxController {
  final RxInt currentIndex = 0.obs;


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

        toProfile();
        break;
    }
  }


  void changeTab(int index) {
    if (currentIndex.value == index) return;
    currentIndex.value = index;
  }


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

  void toPostListing() {
    Get.toNamed(Routes.POST_LISTING);
  }


  void toHomeAndRemoveAll() {
    currentIndex.value = 0;
    Get.offAllNamed(Routes.HOME);
  }

  @override
  void onClose() {
    super.onClose();
  }
}
