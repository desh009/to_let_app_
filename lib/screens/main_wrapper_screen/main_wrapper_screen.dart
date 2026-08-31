import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:to_let_app_abandon/screens/home/views/home_screen.dart';
import 'package:to_let_app_abandon/screens/home/LayOut/items/Items/custom_bottom_nav_bar.dart';
import 'package:to_let_app_abandon/screens/masaage/view/massage_view.dart';
import 'package:to_let_app_abandon/screens/saved_screen/views/saved_screen.dart';
import 'package:to_let_app_abandon/widgets/nav/nav_controller.dart';

class MainWrapper extends GetView<NavController> {
  const MainWrapper({super.key});

  static final List<Widget> _screens = [
    const HomeScreen(),
    const SavedScreen(),
    const MessagesScreen(),
    // const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => IndexedStack(
          index: controller.currentIndex.value,
          children: _screens,
        ),
      ),
      bottomNavigationBar: Obx(
        () => CustomBottomNavBar(
          currentIndex: controller.currentIndex.value,
          onTap: controller.changeTab,
        ),
      ),
    );
  }
}
