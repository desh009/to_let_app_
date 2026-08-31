import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/storage_keys.dart';
import '../../../core/services/storage_service.dart';
import '../../../routes/app_routes.dart';

class AuthController extends GetxController {
  final StorageService storageService = Get.find<StorageService>();

  // ==================== LOGIN STATE ====================
  late final TextEditingController loginPhoneOrEmailController;
  late final TextEditingController loginPasswordController;
  final RxBool isLoginPasswordHidden = true.obs;
  final RxBool isLoggingIn = false.obs;

  // ==================== REGISTER STATE ====================
  late final TextEditingController regFullNameController;
  late final TextEditingController regPhoneController;
  late final TextEditingController regEmailController;
  late final TextEditingController regPasswordController;
  late final TextEditingController regConfirmPasswordController;
  final RxBool isRegPasswordHidden = true.obs;
  final RxBool isTermsAgreed = false.obs;
  final RxInt passwordStrength = 1.obs; // 1 to 4 segments
  final RxBool isRegistering = false.obs;

  // ==================== OTP STATE ====================
  final RxList<String> otpDigits = <String>['', '', '', '', '', ''].obs;
  final RxInt currentOtpIndex = 0.obs; // index pointing to the first box
  final RxInt resendCountdown = 45.obs;
  final RxBool canResend = false.obs;
  Timer? _timer;
  final RxString targetPhoneNumber = '+880 1712 345 678'.obs;
  final RxBool isVerifyingOtp = false.obs;

  @override
  void onInit() {
    super.onInit();
    loginPhoneOrEmailController = TextEditingController(text: '1712 345 678');
    loginPasswordController = TextEditingController(text: 'password123');

    regFullNameController = TextEditingController();
    regPhoneController = TextEditingController(text: '1712 345 678');
    regEmailController = TextEditingController();
    regPasswordController = TextEditingController();
    regConfirmPasswordController = TextEditingController();

    regPasswordController.addListener(_updatePasswordStrength);
    startResendTimer();
  }

  void _updatePasswordStrength() {
    final text = regPasswordController.text;
    if (text.isEmpty) {
      passwordStrength.value = 0;
    } else if (text.length < 6) {
      passwordStrength.value = 1;
    } else if (text.length < 8) {
      passwordStrength.value = 2;
    } else if (text.length < 10) {
      passwordStrength.value = 3;
    } else {
      passwordStrength.value = 4;
    }
  }

  // Timer for OTP Resend
  void startResendTimer() {
    _timer?.cancel();
    resendCountdown.value = 45;
    canResend.value = false;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendCountdown.value > 0) {
        resendCountdown.value--;
      } else {
        canResend.value = true;
        timer.cancel();
      }
    });
  }

  String get formattedTimer {
    final mins = (resendCountdown.value ~/ 60).toString().padLeft(2, '0');
    final secs = (resendCountdown.value % 60).toString().padLeft(2, '0');
    return '$mins:$secs';
  }

  // OTP Numpad Actions
  void inputOtpDigit(String digit) {
    if (currentOtpIndex.value < 6) {
      otpDigits[currentOtpIndex.value] = digit;
      currentOtpIndex.value++;
    }
  }

  void deleteOtpDigit() {
    if (currentOtpIndex.value > 0) {
      currentOtpIndex.value--;
      otpDigits[currentOtpIndex.value] = '';
    }
  }

  void selectOtpBox(int index) {
    if (index >= 0 && index < 6) {
      currentOtpIndex.value = index;
    }
  }

  String get formattedMaskedPhone {
    final phone = targetPhoneNumber.value.trim();
    // e.g. +880 1712 345 678 -> +880 17XX XXX 678
    if (phone.length >= 10) {
      return '+880 17XX XXX ${phone.substring(phone.length - 3)}';
    }
    return '+880 17XX XXX 678';
  }

  // ==================== AUTH ACTIONS ====================

  Future<void> login() async {
    final input = loginPhoneOrEmailController.text.trim();
    final pass = loginPasswordController.text.trim();

    if (input.isEmpty) {
      Get.snackbar(
        'Required Field',
        'Please enter your phone number or email address.',
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
      return;
    }

    if (pass.isEmpty) {
      Get.snackbar(
        'Required Field',
        'Please enter your password.',
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
      return;
    }

    isLoggingIn.value = true;
    await Future.delayed(const Duration(milliseconds: 700));
    isLoggingIn.value = false;

    // Save session
    await storageService.setBool(StorageKeys.isLoggedIn, true);
    await storageService.setString(
      StorageKeys.userName,
      input.contains('@') ? input.split('@')[0] : 'Desh',
    );

    Get.offAllNamed(Routes.HOME);
  }

  Future<void> register() async {
    final name = regFullNameController.text.trim();
    final phone = regPhoneController.text.trim();
    final pass = regPasswordController.text.trim();
    final confirmPass = regConfirmPasswordController.text.trim();

    if (name.isEmpty) {
      Get.snackbar(
        'Required Field',
        'Please enter your full name.',
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
      return;
    }

    if (phone.isEmpty) {
      Get.snackbar(
        'Required Field',
        'Please enter your phone number.',
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
      return;
    }

    if (pass.length < 6) {
      Get.snackbar(
        'Password too short',
        'Password must be at least 6 characters.',
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
      return;
    }

    if (pass != confirmPass) {
      Get.snackbar(
        'Password Mismatch',
        'Passwords do not match.',
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
      return;
    }

    if (!isTermsAgreed.value) {
      Get.snackbar(
        'Terms Required',
        'Please agree to the Terms & Privacy policy.',
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
      return;
    }

    isRegistering.value = true;
    await Future.delayed(const Duration(milliseconds: 600));
    isRegistering.value = false;

    targetPhoneNumber.value = phone;
    // OTP digits empty by default
    otpDigits.assignAll(['', '', '', '', '', '']);
    currentOtpIndex.value = 0;
    startResendTimer();

    Get.toNamed(Routes.VERIFY_OTP);
  }

  Future<void> verifyOtp() async {
    final code = otpDigits.join();
    if (code.length < 6) {
      Get.snackbar(
        'Incomplete Code',
        'Please enter the full 6-digit verification code.',
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
      return;
    }

    isVerifyingOtp.value = true;
    await Future.delayed(const Duration(milliseconds: 800));
    isVerifyingOtp.value = false;

    await storageService.setBool(StorageKeys.isLoggedIn, true);
    if (regFullNameController.text.trim().isNotEmpty) {
      await storageService.setString(
        StorageKeys.userName,
        regFullNameController.text.trim(),
      );
    }

    Get.offAllNamed(Routes.HOME);
  }

  void resendOtp() {
    if (!canResend.value) return;
    startResendTimer();
    Get.snackbar(
      'Code Sent',
      'A new verification code has been sent to your phone.',
      backgroundColor: AppColors.primary,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
    );
  }

  void socialLogin(String provider) async {
    isLoggingIn.value = true;
    await Future.delayed(const Duration(milliseconds: 600));
    isLoggingIn.value = false;
    await storageService.setBool(StorageKeys.isLoggedIn, true);
    await storageService.setString(StorageKeys.userName, '$provider User');
    Get.offAllNamed(Routes.HOME);
  }

  @override
  void onClose() {
    _timer?.cancel();
    loginPhoneOrEmailController.dispose();
    loginPasswordController.dispose();
    regFullNameController.dispose();
    regPhoneController.dispose();
    regEmailController.dispose();
    regPasswordController.dispose();
    regConfirmPasswordController.dispose();
    super.onClose();
  }
}
