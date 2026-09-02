import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:to_let_app_abandon/core/constants/app_strings.dart';


class ProblemOption {
  final String title;
  final String subtitle;

  const ProblemOption({required this.title, required this.subtitle});
}

class ReportProblemController extends GetxController {
  final TextEditingController descriptionController = TextEditingController();

  final RxInt selectedIndex = 0.obs;
  final RxBool isSubmitting = false.obs;

  final List<ProblemOption> options = const [
    ProblemOption(
      title: AppStrings.listingIsFake,
      subtitle: AppStrings.listingIsFakeSub,
    ),
    ProblemOption(
      title: AppStrings.ownerNotResponding,
      subtitle: AppStrings.ownerNotRespondingSub,
    ),
    ProblemOption(
      title: AppStrings.wrongPriceLocation,
      subtitle: AppStrings.wrongPriceLocationSub,
    ),
    ProblemOption(
      title: AppStrings.fraudScam,
      subtitle: AppStrings.fraudScamSub,
    ),
    ProblemOption(
      title: AppStrings.appBug,
      subtitle: AppStrings.appBugSub,
    ),
  ];

  ProblemOption get selectedOption => options[selectedIndex.value];

  /// আগের স্ক্রিন থেকে পাঠানো listing id (optional)
  String? listingId;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map && args['listingId'] != null) {
      listingId = args['listingId'].toString();
    }
  }

  void selectOption(int index) {
    if (index == selectedIndex.value) return;
    selectedIndex.value = index;
  }

  void handleBack() {
    if (Get.key.currentState?.canPop() ?? false) {
      Get.back();
    } else {
      Get.back(closeOverlays: true);
    }
  }

  Future<void> submitReport() async {
    final description = descriptionController.text.trim();

    if (description.length < 10) {
      Get.snackbar(
        AppStrings.reportAProblemTitle,
        AppStrings.reportHintText,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (isSubmitting.value) return;
    isSubmitting.value = true;

    try {
      // TODO: repository/API call
      // await _repository.submitReport(
      //   reason: selectedOption.title,
      //   description: description,
      //   listingId: listingId,
      // );
      await Future.delayed(const Duration(milliseconds: 800));

      descriptionController.clear();
      selectedIndex.value = 0;
      Get.back(result: true);
    } catch (e) {
      Get.snackbar(
        AppStrings.reportAProblemTitle,
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  @override
  void onClose() {
    descriptionController.dispose();
    super.onClose();
  }
}