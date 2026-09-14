import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/storage_keys.dart';
import '../../../core/services/storage_service.dart';
import '../../../routes/app_routes.dart';

class AuthController extends GetxController {
  final StorageService storageService = Get.find<StorageService>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late final TextEditingController loginEmailController;
  late final TextEditingController loginPasswordController;
  final RxBool isLoginPasswordHidden = true.obs;
  final RxBool isLoggingIn = false.obs;

  late final TextEditingController regFullNameController;
  late final TextEditingController regPhoneController;
  late final TextEditingController regEmailController;
  late final TextEditingController regPasswordController;
  late final TextEditingController regConfirmPasswordController;
  final RxBool isRegPasswordHidden = true.obs;
  final RxBool isTermsAgreed = false.obs;
  final RxInt passwordStrength = 1.obs;
  final RxBool isRegistering = false.obs;

  final RxList<String> otpDigits = <String>['', '', '', '', '', ''].obs;
  final RxInt currentOtpIndex = 0.obs;
  final RxInt resendCountdown = 45.obs;
  final RxBool canResend = false.obs;
  Timer? _timer;
  final RxString targetPhoneNumber = '+880 1712 345 678'.obs;
  final RxBool isVerifyingOtp = false.obs;

  // Which flow currently owns the shared Verify OTP screen: register (false)
  // or forgot-password (true). Set right before Get.toNamed(Routes.VERIFY_OTP).
  final RxBool otpFlowIsForgotPassword = false.obs;
  final RxBool isVerifyingForgotOtp = false.obs;

  late final TextEditingController forgotPasswordInputController;
  late final TextEditingController forgotNewPasswordController;
  late final TextEditingController forgotConfirmPasswordController;
  final RxBool isForgotPasswordStep2 = false.obs;
  final RxBool isSendingForgotOtp = false.obs;
  final RxBool isResettingPassword = false.obs;
  final RxBool isForgotNewPasswordHidden = true.obs;
  final RxBool isForgotConfirmPasswordHidden = true.obs;
  final RxList<String> forgotOtpDigits = <String>['', '', '', '', '', ''].obs;
  final RxInt currentForgotOtpIndex = 0.obs;
  final RxInt forgotResendCountdown = 45.obs;
  final RxBool canResendForgotOtp = false.obs;
  Timer? _forgotTimer;

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

  @override
  void onInit() {
    super.onInit();
    loginEmailController = TextEditingController();
    loginPasswordController = TextEditingController();

    regFullNameController = TextEditingController();
    regPhoneController = TextEditingController();
    regEmailController = TextEditingController();
    regPasswordController = TextEditingController();
    regConfirmPasswordController = TextEditingController();

    regPasswordController.addListener(_updatePasswordStrength);
    startResendTimer();

    forgotPasswordInputController = TextEditingController();
    forgotNewPasswordController = TextEditingController();
    forgotConfirmPasswordController = TextEditingController();
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

    if (phone.length >= 10) {
      return '+880 17XX XXX ${phone.substring(phone.length - 3)}';
    }
    return '+880 17XX XXX 678';
  }

  // ---- Unified helpers so VerifyOtpScreen works for BOTH register and
  // forgot-password flows without duplicating the whole screen. ----

  String get activeOtpTargetLabel => otpFlowIsForgotPassword.value
      ? forgotPasswordInputController.text.trim()
      : formattedMaskedPhone;

  RxList<String> get activeOtpDigits =>
      otpFlowIsForgotPassword.value ? forgotOtpDigits : otpDigits;

  int get activeCurrentOtpIndex => otpFlowIsForgotPassword.value
      ? currentForgotOtpIndex.value
      : currentOtpIndex.value;

  String get activeFormattedTimer =>
      otpFlowIsForgotPassword.value ? formattedForgotTimer : formattedTimer;

  bool get activeCanResend => otpFlowIsForgotPassword.value
      ? canResendForgotOtp.value
      : canResend.value;

  bool get activeIsSubmitting => otpFlowIsForgotPassword.value
      ? isVerifyingForgotOtp.value
      : isVerifyingOtp.value;

  void selectActiveOtpBox(int index) {
    if (otpFlowIsForgotPassword.value) {
      if (index >= 0 && index < 6) currentForgotOtpIndex.value = index;
    } else {
      selectOtpBox(index);
    }
  }

  void inputActiveOtpDigit(String digit) {
    if (otpFlowIsForgotPassword.value) {
      inputForgotOtpDigit(digit);
    } else {
      inputOtpDigit(digit);
    }
  }

  void deleteActiveOtpDigit() {
    if (otpFlowIsForgotPassword.value) {
      deleteForgotOtpDigit();
    } else {
      deleteOtpDigit();
    }
  }

  void resendActiveOtp() {
    if (otpFlowIsForgotPassword.value) {
      resendForgotOtp();
    } else {
      resendOtp();
    }
  }

  /// Called by the "Verify & Continue" button on the shared OTP screen.
  Future<void> continueFromOtpScreen() async {
    if (otpFlowIsForgotPassword.value) {
      final code = forgotOtpDigits.join();
      if (code.length < 6) {
        Get.snackbar(
          'Incomplete Code',
          'Please enter the full 6-digit verification code.',
          backgroundColor: AppColors.error,
          colorText: Colors.white,
        );
        return;
      }
      isVerifyingForgotOtp.value = true;
      await Future.delayed(const Duration(milliseconds: 500));
      isVerifyingForgotOtp.value = false;
      // OTP confirmed — go back to Forgot Password screen, which is already
      // showing the "set new password" step underneath.
      Get.back();
    } else {
      await verifyOtp();
    }
  }

  Future<void> login() async {
    final email = loginEmailController.text.trim();
    final pass = loginPasswordController.text.trim();

    if (email.isEmpty) {
      Get.snackbar(
        'Required Field',
        'Please enter your Gmail address.',
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
      return;
    }

    if (!GetUtils.isEmail(email)) {
      Get.snackbar(
        'Invalid Email',
        'Please enter a valid Gmail address.',
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

    try {
      try {
        final userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: pass,
        );
        final user = userCredential.user;
        await storageService.setBool(StorageKeys.isLoggedIn, true);
        await storageService.setString(
          StorageKeys.userName,
          user?.displayName ?? email.split('@')[0],
        );
        Get.offAllNamed(Routes.HOME);
        return;
      } catch (e) {
        debugPrint('Firebase email login exception: $e');
      }

      Get.snackbar(
        'Login Failed',
        'Your Gmail address or password is incorrect.',
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
    } catch (e) {
      debugPrint('Login error: $e');
    } finally {
      isLoggingIn.value = false;
    }
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

    otpDigits.assignAll(['', '', '', '', '', '']);
    currentOtpIndex.value = 0;
    startResendTimer();

    otpFlowIsForgotPassword.value = false;
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

  void _startForgotResendTimer() {
    _forgotTimer?.cancel();
    forgotResendCountdown.value = 45;
    canResendForgotOtp.value = false;
    _forgotTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (forgotResendCountdown.value > 0) {
        forgotResendCountdown.value--;
      } else {
        canResendForgotOtp.value = true;
        timer.cancel();
      }
    });
  }

  String get formattedForgotTimer {
    final mins = (forgotResendCountdown.value ~/ 60).toString().padLeft(2, '0');
    final secs = (forgotResendCountdown.value % 60).toString().padLeft(2, '0');
    return '$mins:$secs';
  }

  void inputForgotOtpDigit(String digit) {
    if (currentForgotOtpIndex.value < 6) {
      forgotOtpDigits[currentForgotOtpIndex.value] = digit;
      currentForgotOtpIndex.value++;
    }
  }

  void deleteForgotOtpDigit() {
    if (currentForgotOtpIndex.value > 0) {
      currentForgotOtpIndex.value--;
      forgotOtpDigits[currentForgotOtpIndex.value] = '';
    }
  }

  Future<void> sendForgotPasswordOtp() async {
    final input = forgotPasswordInputController.text.trim();
    if (input.isEmpty) {
      Get.snackbar(
        'Required',
        'Please enter your phone number or email.',
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
      return;
    }
    isSendingForgotOtp.value = true;
    await Future.delayed(const Duration(milliseconds: 800));
    isSendingForgotOtp.value = false;
    forgotOtpDigits.assignAll(['', '', '', '', '', '']);
    currentForgotOtpIndex.value = 0;
    _startForgotResendTimer();

    // Navigate to forgot password OTP screen
    Get.toNamed(Routes.FORGOT_PASSWORD_OTP);

    Get.snackbar(
      'OTP Sent',
      'A 6-digit code was sent to $input',
      backgroundColor: AppColors.primary,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
    );
  }

  void resendForgotOtp() {
    if (!canResendForgotOtp.value) return;
    _startForgotResendTimer();
    Get.snackbar(
      'Code Resent',
      'A new OTP has been sent.',
      backgroundColor: AppColors.primary,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
    );
  }

  Future<void> verifyForgotOtp() async {
    final code = forgotOtpDigits.join();
    if (code.length < 6) {
      Get.snackbar(
        'Incomplete OTP',
        'Please enter the full 6-digit code.',
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
      return;
    }

    isVerifyingForgotOtp.value = true;
    await Future.delayed(const Duration(milliseconds: 800));
    isVerifyingForgotOtp.value = false;

    // OTP verified - navigate to reset password screen
    Get.toNamed(Routes.RESET_PASSWORD);

    Get.snackbar(
      'Verified!',
      'OTP confirmed. Please set your new password.',
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
    );
  }

  Future<void> resetPassword() async {
    final newPass = forgotNewPasswordController.text.trim();
    final confirmPass = forgotConfirmPasswordController.text.trim();

    if (newPass.length < 6) {
      Get.snackbar(
        'Weak Password',
        'Password must be at least 6 characters.',
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
      return;
    }
    if (newPass != confirmPass) {
      Get.snackbar(
        'Mismatch',
        'Passwords do not match.',
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
      return;
    }

    isResettingPassword.value = true;
    await Future.delayed(const Duration(milliseconds: 900));
    isResettingPassword.value = false;

    // Clear all fields
    forgotPasswordInputController.clear();
    forgotNewPasswordController.clear();
    forgotConfirmPasswordController.clear();
    forgotOtpDigits.assignAll(['', '', '', '', '', '']);
    currentForgotOtpIndex.value = 0;

    // Navigate back to login screen
    Get.until((route) => route.settings.name == Routes.LOGIN);

    // Show success message
    Get.snackbar(
      'Success!',
      'Your password has been reset. Please log in.',
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
    );
  }

  void socialLogin(String provider) async {
    if (provider.toLowerCase() == 'google') {
      await signInWithGoogle();
    } else {
      isLoggingIn.value = true;
      await Future.delayed(const Duration(milliseconds: 600));
      isLoggingIn.value = false;
      await storageService.setBool(StorageKeys.isLoggedIn, true);
      await storageService.setString(StorageKeys.userName, '$provider User');
      Get.offAllNamed(Routes.HOME);
    }
  }

  Future<void> signInWithGoogle() async {
    isLoggingIn.value = true;
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email', 'profile'],
      );

      // Disconnect previous session to force Gmail account selection dialog
      try {
        await googleSignIn.signOut();
      } catch (_) {}

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        // User cancelled Google account picker
        isLoggingIn.value = false;
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );
      final user = userCredential.user;

      await storageService.setBool(StorageKeys.isLoggedIn, true);
      await storageService.setString(
        StorageKeys.userName,
        user?.displayName ?? googleUser.displayName ?? 'Google User',
      );
      if (user?.email != null || googleUser.email.isNotEmpty) {
        await storageService.setString(
          StorageKeys.userPhone,
          user?.email ?? googleUser.email,
        );
      }

      Get.snackbar(
        'Google Login',
        'Logged in as ${user?.displayName ?? googleUser.displayName}!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      Get.offAllNamed(Routes.HOME);
    } catch (e) {
      debugPrint('Google Sign-In Error details: $e');
      Get.snackbar(
        'Google Sign-In Failed',
        'Please try again. If this continues, check Firebase Google Sign-In setup.',
        backgroundColor: AppColors.error,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoggingIn.value = false;
    }
  }

  String get formattedTwoFactorTimer {
    final m = (twoFactorResendSeconds.value ~/ 60).toString().padLeft(2, '0');
    final s = (twoFactorResendSeconds.value % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  Future<void> fetchTwoFactorStatus() async {}

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
    _timer?.cancel();
    _forgotTimer?.cancel();
    _twoFactorTimer?.cancel();
    loginEmailController.dispose();
    loginPasswordController.dispose();
    regFullNameController.dispose();
    regPhoneController.dispose();
    regEmailController.dispose();
    regPasswordController.dispose();
    regConfirmPasswordController.dispose();
    forgotPasswordInputController.dispose();
    forgotNewPasswordController.dispose();
    forgotConfirmPasswordController.dispose();
    super.onClose();
  }
}
