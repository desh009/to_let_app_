import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:to_let_app_abandon/core/constants/app_strings.dart';


/// এক একটা পলিসি সেকশন — প্যারাগ্রাফ অথবা বুলেট লিস্ট
class PolicySection {
  final String title;
  final String? body;
  final List<String> bullets;

  const PolicySection({
    required this.title,
    this.body,
    this.bullets = const [],
  });

  bool get hasBullets => bullets.isNotEmpty;
}

class PrivacyPolicyController extends GetxController {
  final ScrollController scrollController = ScrollController();

  /// স্ক্রল করে নিচে নামলে "টপে যাও" বাটন দেখাবে
  final RxBool showScrollToTop = false.obs;

  final List<PolicySection> sections = const [
    PolicySection(
      title: AppStrings.dataWeCollectTitle,
      body: AppStrings.dataWeCollectBody,
    ),
    PolicySection(
      title: AppStrings.howWeUseTitle,
      bullets: [
        AppStrings.howWeUseItem1,
        AppStrings.howWeUseItem2,
        AppStrings.howWeUseItem3,
        AppStrings.howWeUseItem4,
      ],
    ),
    PolicySection(
      title: AppStrings.sharingTitle,
      body: AppStrings.sharingBody,
    ),
    PolicySection(
      title: AppStrings.yourRightsTitle,
      body: AppStrings.yourRightsBody,
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final shouldShow = scrollController.offset > 200;
    if (shouldShow != showScrollToTop.value) {
      showScrollToTop.value = shouldShow;
    }
  }

  void scrollToTop() {
    scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
    );
  }

  void handleBack() {
    Get.back();
  }

  @override
  void onClose() {
    scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.onClose();
  }
}