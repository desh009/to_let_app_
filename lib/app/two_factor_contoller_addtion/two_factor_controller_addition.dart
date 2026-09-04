

  import 'dart:async';

import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

final RxBool isTwoFactorEnabled = false.obs;
  final RxBool isTwoFactorSetupStep2 = false.obs;
  final RxBool isSendingTwoFactorOtp = false.obs;
  final RxBool isVerifyingTwoFactorOtp = false.obs;
  final RxBool isDisablingTwoFactor = false.obs;

  final RxList<String> twoFactorOtpDigits = <String>[].obs;
  final RxInt currentTwoFactorOtpIndex = 0.obs;

  final RxBool canResendTwoFactorOtp = false.obs;
  final RxInt twoFactorResendSeconds = 60.obs;
  Timer? _twoFactorTimer;

  String get formattedTwoFactorTimer {
    final m = (twoFactorResendSeconds.value ~/ 60).toString().padLeft(2, '0');
    final s = (twoFactorResendSeconds.value % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }


  Future<void> fetchTwoFactorStatus() async {
    try {


    } catch (e) {

    }
  }


  Future<void> sendTwoFactorOtp() async {
    if (isSendingTwoFactorOtp.value) return;
    isSendingTwoFactorOtp.value = true;
    try {


      isTwoFactorSetupStep2.value = true;
      twoFactorOtpDigits.clear();
      currentTwoFactorOtpIndex.value = 0;
      _startTwoFactorResendTimer();
    } catch (e) {
      Get.snackbar('Error', 'Could not send OTP. Please try again.');
    } finally {
      isSendingTwoFactorOtp.value = false;
    }
  }

  Future<void> resendTwoFactorOtp() async {
    if (!canResendTwoFactorOtp.value) return;
    await sendTwoFactorOtp();
  }

  void _startTwoFactorResendTimer() {
    canResendTwoFactorOtp.value = false;
    twoFactorResendSeconds.value = 60;
    _twoFactorTimer?.cancel();
    _twoFactorTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (twoFactorResendSeconds.value <= 1) {
        canResendTwoFactorOtp.value = true;
        t.cancel();
      } else {
        twoFactorResendSeconds.value--;
      }
    });
  }

  void inputTwoFactorOtpDigit(String digit) {
    if (twoFactorOtpDigits.length >= 6) return;
    twoFactorOtpDigits.add(digit);
    currentTwoFactorOtpIndex.value = twoFactorOtpDigits.length;

    if (twoFactorOtpDigits.length == 6) {
      verifyTwoFactorOtp();
    }
  }

  void deleteTwoFactorOtpDigit() {
    if (twoFactorOtpDigits.isEmpty) return;
    twoFactorOtpDigits.removeLast();
    currentTwoFactorOtpIndex.value = twoFactorOtpDigits.length;
  }


  Future<void> verifyTwoFactorOtp() async {
    if (isVerifyingTwoFactorOtp.value) return;
    isVerifyingTwoFactorOtp.value = true;
    try {
      final code = twoFactorOtpDigits.join();


      final bool ok = code.length == 6;

      if (ok) {
        isTwoFactorEnabled.value = true;
        isTwoFactorSetupStep2.value = false;
        _twoFactorTimer?.cancel();
        Get.back();
        Get.snackbar('Two-Factor Authentication', 'Successfully enabled.');
      } else {
        Get.snackbar('Invalid Code', 'The OTP you entered is incorrect.');
        twoFactorOtpDigits.clear();
        currentTwoFactorOtpIndex.value = 0;
      }
    } catch (e) {
      Get.snackbar('Error', 'Verification failed. Please try again.');
    } finally {
      isVerifyingTwoFactorOtp.value = false;
    }
  }


  Future<void> disableTwoFactor() async {
    if (isDisablingTwoFactor.value) return;
    isDisablingTwoFactor.value = true;
    try {


      isTwoFactorEnabled.value = false;
      Get.snackbar('Two-Factor Authentication', 'Disabled.');
    } catch (e) {
      Get.snackbar('Error', 'Could not disable 2FA. Please try again.');
    } finally {
      isDisablingTwoFactor.value = false;
    }
  }

  @override
  void onClose() {
    _twoFactorTimer?.cancel();


  }