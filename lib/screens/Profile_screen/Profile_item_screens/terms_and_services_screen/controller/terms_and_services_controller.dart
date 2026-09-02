import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:to_let_app_abandon/core/constants/app_strings.dart';


/// এক একটা টার্মস সেকশন — প্যারাগ্রাফ অথবা বুলেট লিস্ট
class TermsSection {
  final String title;
  final String? body;
  final List<String> bullets;

  const TermsSection({
    required this.title,
    this.body,
    this.bullets = const [],
  });

  bool get hasBullets => bullets.isNotEmpty;
}

class TermsOfServiceController extends GetxController {
  final ScrollController scrollController = ScrollController();

  /// স্ক্রল করে নিচে নামলে "টপে যাও" বাটন দেখাবে
  final RxBool showScrollToTop = false.obs;

  final List<TermsSection> sections = const [
    TermsSection(
      title: AppStrings.userResponsibilitiesTitle,
      body: AppStrings.userResponsibilitiesBody,
    ),
    TermsSection(
      title: AppStrings.listingRulesTitle,
      bullets: [
        AppStrings.listingRule1,
        AppStrings.listingRule2,
        AppStrings.listingRule3,
        AppStrings.listingRule4,
      ],
    ),
    TermsSection(
      title: AppStrings.paymentsBrokerageTitle,
      body: AppStrings.paymentsBrokerageBody,
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