import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:to_let_app_abandon/core/constants/app_strings.dart';


class EmailSupportController extends GetxController {
  // ADDED: Subjects moved from UI to controller
  final subjects = [
    AppStrings.subjectListing,
    AppStrings.subjectAccount,
    AppStrings.subjectOther,
  ];

  // ADDED: Reactive state variables
  final selectedSubject = ''.obs;
  final isLoading = false.obs;
  final attachedFileName = RxnString(); // Nullable string for attachment

  // ADDED: TextEditingController managed by controller
  late final TextEditingController emailController;

  @override
  void onInit() {
    super.onInit();
    emailController = TextEditingController(text: AppStrings.userEmail);
    selectedSubject.value = subjects.first;
  }

  // ADDED: Back navigation handled by controller
  void handleBack() => Get.back();

  // ADDED: Subject selection logic
  void selectSubject(String? value) {
    if (value != null) selectedSubject.value = value;
  }

  // ADDED: Attachment picker logic (placeholder for file_picker)
  Future<void> pickAttachment() async {
    // TODO: Integrate file_picker package if real file selection needed
    // Example:
    // final result = await FilePicker.platform.pickFiles();
    // if (result != null) attachedFileName.value = result.files.single.name;

    // Simulated selection for demo
    attachedFileName.value = 'screenshot.png';
  }

  // ADDED: Remove selected attachment
  void removeAttachment() => attachedFileName.value = null;

  // ADDED: Send email with loading state
  Future<void> sendEmail() async {
    if (isLoading.value) return;
    isLoading.value = true;
    try {
      await Future.delayed(const Duration(seconds: 1)); // simulate network
      Get.snackbar(
        'Success',
        'Support email sent successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
      // Optionally navigate back after success:
      // Get.back();
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
    emailController.dispose(); // ADDED: Clean up controller
    super.onClose();
  }
}