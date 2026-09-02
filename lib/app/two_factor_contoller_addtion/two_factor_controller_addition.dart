// ─────────────────────────────────────────────────────────────────────────
// Add these members inside your existing AuthController class
// (the one ForgotPasswordScreen already uses as `controller`).
// ─────────────────────────────────────────────────────────────────────────

  // ── TWO-FACTOR AUTH STATE ────────────────────────────────────────────
  import 'dart:async';

import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

final RxBool isTwoFactorEnabled = false.obs;      // current saved state (from backend)
  final RxBool isTwoFactorSetupStep2 = false.obs;   // false = intro/toggle view, true = OTP view
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

  /// Call this when the screen opens to sync with backend's real status.
  Future<void> fetchTwoFactorStatus() async {
    try {
      // TODO: replace with your real API call
      // final res = await _authRepository.getTwoFactorStatus();
      // isTwoFactorEnabled.value = res.enabled;
    } catch (e) {
      // handle/log error
    }
  }

  /// Step 1 -> Step 2: user taps "Enable" and we send an OTP to their
  /// registered phone/email to confirm they own the account.
  Future<void> sendTwoFactorOtp() async {
    if (isSendingTwoFactorOtp.value) return;
    isSendingTwoFactorOtp.value = true;
    try {
      // TODO: replace with your real API call
      // await _authRepository.sendTwoFactorOtp();

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

  /// Final step: verify the OTP and actually flip 2FA ON in the backend.
  Future<void> verifyTwoFactorOtp() async {
    if (isVerifyingTwoFactorOtp.value) return;
    isVerifyingTwoFactorOtp.value = true;
    try {
      final code = twoFactorOtpDigits.join();

      // TODO: replace with your real API call
      // final ok = await _authRepository.verifyTwoFactorOtp(code);
      final bool ok = code.length == 6; // placeholder success check

      if (ok) {
        isTwoFactorEnabled.value = true;
        isTwoFactorSetupStep2.value = false;
        _twoFactorTimer?.cancel();
        Get.back(); // close the 2FA screen and return to Profile
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

  /// Turning 2FA OFF — normally you'd ask for password confirmation here
  /// before disabling, since it lowers account security.
  Future<void> disableTwoFactor() async {
    if (isDisablingTwoFactor.value) return;
    isDisablingTwoFactor.value = true;
    try {
      // TODO: replace with your real API call
      // await _authRepository.disableTwoFactor();
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
    // If this controller already has a parent class override, keep its
    // onClose logic above this line and call super.onClose() there.
  }