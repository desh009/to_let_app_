import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:to_let_app_abandon/core/constants/app_strings.dart';


class EmailSupportController extends GetxController {

  final subjects = [
    AppStrings.subjectListing,
    AppStrings.subjectAccount,
    AppStrings.subjectOther,
  ];


  final selectedSubject = ''.obs;
  final isLoading = false.obs;
  final attachedFileName = RxnString();


  late final TextEditingController emailController;

  @override
  void onInit() {
    super.onInit();
    emailController = TextEditingController(text: AppStrings.userEmail);
    selectedSubject.value = subjects.first;
  }


  void handleBack() => Get.back();


  void selectSubject(String? value) {
    if (value != null) selectedSubject.value = value;
  }


  Future<void> pickAttachment() async {


    attachedFileName.value = 'screenshot.png';
  }


  void removeAttachment() => attachedFileName.value = null;


  Future<void> sendEmail() async {
    if (isLoading.value) return;
    isLoading.value = true;
    try {
      await Future.delayed(const Duration(seconds: 1));
      Get.snackbar(
        'Success',
        'Support email sent successfully',
        snackPosition: SnackPosition.BOTTOM,
      );


    } catch (_) {
      Get.snackbar(
        'Error',
        'Failed to send email. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}