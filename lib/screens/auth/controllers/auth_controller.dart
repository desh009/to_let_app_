import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/storage_keys.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/services/network_service.dart';
import '../../../data/repositories/auth_repo.dart';
import '../../../data/models/auth/login_response_model.dart';
import '../../../routes/app_routes.dart';

class AuthController extends GetxController {
  final StorageService storageService = Get.find<StorageService>();
  final AuthRepo _authRepo = AuthRepo();
  final NetworkService _networkService = Get.find<NetworkService>();
  final SupabaseClient _supabase = Supabase.instance.client;
  final LocalAuthentication _localAuth = LocalAuthentication();
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  // Biometric
  final RxBool isBiometricAvailable = false.obs;
  final RxBool isBiometricEnabled = false.obs;
  final RxString biometricType = ''.obs; // 'fingerprint' or 'face'
  final RxString deviceId = ''.obs; // Unique device identifier
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
  final RxString forgotResetToken = ''.obs;
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

    // Check biometric availability
    checkBiometricAvailability();
    loadBiometricSettings();
    _getDeviceId();
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
      final response = await _authRepo.login(email: email, password: pass);
      isLoggingIn.value = false;

      if (response.isSuccess && response.responseData != null) {
        final loginModel = LoginResponseModel.fromJson(response.responseData!);

        if (loginModel.success && loginModel.data != null) {
          // Save token
          _networkService.setAuthToken(loginModel.data!.token);
          if (loginModel.data!.refreshToken != null) {
            await storageService.setString(
              StorageKeys.refreshToken,
              loginModel.data!.refreshToken!,
            );
          }

          // Save user data
          await storageService.setBool(StorageKeys.isLoggedIn, true);
          final user = loginModel.data!.user;
          await storageService.setString(StorageKeys.userName, user.name);
          await storageService.setString(StorageKeys.userEmail, user.email);
          await storageService.setString(StorageKeys.userId, user.id);
          if (user.phone != null) {
            await storageService.setString(StorageKeys.userPhone, user.phone!);
          }

          // If biometric is enabled for this email, keep token fresh
          final bioEmail = storageService.getString(StorageKeys.biometricEmail);
          final bioEnabled =
              storageService.getBool(StorageKeys.biometricEnabled) ?? false;
          if (bioEnabled &&
              bioEmail != null &&
              bioEmail.trim().toLowerCase() ==
                  user.email.trim().toLowerCase()) {
            await storageService.setString(
              StorageKeys.biometricAuthToken,
              loginModel.data!.token,
            );
            if (loginModel.data!.refreshToken != null) {
              await storageService.setString(
                StorageKeys.biometricRefreshToken,
                loginModel.data!.refreshToken!,
              );
            }
          }

          // Navigate to home
          Get.offAllNamed(Routes.HOME);

          Get.snackbar(
            'Success!',
            loginModel.message,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP,
          );

          // Removed: Auto biometric dialog (will be in profile screen instead)
        } else {
          Get.snackbar(
            'Login Failed',
            loginModel.message,
            backgroundColor: AppColors.error,
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP,
          );
        }
      } else {
        Get.snackbar(
          'Login Failed',
          response.errorMessage ?? 'Your email or password is incorrect.',
          backgroundColor: AppColors.error,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      isLoggingIn.value = false;
      debugPrint('Login error: $e');
      Get.snackbar(
        'Error',
        'An unexpected error occurred',
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
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

    try {
      // Call API - Send OTP
      final response = await _authRepo.registerSendOtp(
        email: regEmailController.text.trim(),
        fullName: name,
        phone: phone,
        password: pass,
      );

      isRegistering.value = false;

      if (response.isSuccess) {
        // Parse model
        final otpModel = _authRepo.parseRegisterOtpResponse(response);

        if (otpModel != null) {
          // OTP sent successfully
          targetPhoneNumber.value = otpModel.email;
          otpDigits.assignAll(['', '', '', '', '', '']);
          currentOtpIndex.value = 0;
          startResendTimer();
          otpFlowIsForgotPassword.value = false;

          // Navigate to OTP screen
          Get.toNamed(Routes.REGISTRATION_OTP);

          Get.snackbar(
            'OTP Sent',
            otpModel.message,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP,
          );
        }
      } else {
        // Show error
        Get.snackbar(
          'Registration Failed',
          response.errorMessage ?? 'Failed to send OTP. Please try again.',
          backgroundColor: AppColors.error,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      isRegistering.value = false;
      Get.snackbar(
        'Error',
        'An unexpected error occurred',
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
    }
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

    try {
      // Call API - Verify OTP (Passing required fields for backend validation and account creation)
      final response = await _authRepo.registerVerifyOtp(
        email: regEmailController.text.trim(),
        otp: code,
        name: regFullNameController.text.trim(),
        password: regPasswordController.text.trim(),
      );

      isVerifyingOtp.value = false;

      if (response.isSuccess) {
        // Parse response model
        final verifyResponse = _authRepo.parseVerifyOtpResponse(response);

        if (verifyResponse != null && verifyResponse.data != null) {
          // Save tokens
          if (verifyResponse.data!.idToken.isNotEmpty) {
            _networkService.setAuthToken(verifyResponse.data!.idToken);
          }
          if (verifyResponse.data!.refreshToken.isNotEmpty) {
            await storageService.setString(
              StorageKeys.refreshToken,
              verifyResponse.data!.refreshToken,
            );
          }

          // Save user data
          await storageService.setBool(StorageKeys.isLoggedIn, true);

          final user = verifyResponse.data!.user;
          await storageService.setString(StorageKeys.userName, user.name);
          await storageService.setString(StorageKeys.userEmail, user.email);
          await storageService.setString(
            StorageKeys.userId,
            user.id ?? user.uid,
          );
          if (user.phone != null && user.phone!.isNotEmpty) {
            await storageService.setString(StorageKeys.userPhone, user.phone!);
          }

          // Navigate to home
          Get.offAllNamed(Routes.HOME);

          Get.snackbar(
            'Success!',
            verifyResponse.message,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP,
          );
        }
      } else {
        Get.snackbar(
          'Verification Failed',
          response.errorMessage ?? 'Invalid OTP. Please try again.',
          backgroundColor: AppColors.error,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      isVerifyingOtp.value = false;
      Get.snackbar(
        'Error',
        'An unexpected error occurred',
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
    }
  }

  Future<void> resendOtp() async {
    if (!canResend.value) return;

    try {
      // Call API - Resend OTP
      final response = await _authRepo.registerResendOtp(
        email: regEmailController.text.trim(),
      );

      if (response.isSuccess) {
        // Parse model
        final resendModel = _authRepo.parseResendOtpResponse(response);

        if (resendModel != null) {
          startResendTimer();

          Get.snackbar(
            'Success!',
            resendModel.message,
            backgroundColor: AppColors.primary,
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP,
          );
        }
      } else {
        Get.snackbar(
          'Error',
          response.errorMessage ?? 'Failed to resend OTP',
          backgroundColor: AppColors.error,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An unexpected error occurred',
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
    }
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
    try {
      final response = await _authRepo.forgotPasswordSendOtp(email: input);
      isSendingForgotOtp.value = false;

      if (response.isSuccess) {
        forgotOtpDigits.assignAll(['', '', '', '', '', '']);
        currentForgotOtpIndex.value = 0;
        _startForgotResendTimer();

        // Navigate to forgot password OTP screen
        Get.toNamed(Routes.FORGOT_PASSWORD_OTP);

        Get.snackbar(
          'OTP Sent',
          response.errorMessage ?? 'A 6-digit code was sent to $input',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      } else {
        Get.snackbar(
          'Failed',
          response.errorMessage ?? 'Failed to send OTP. Please try again.',
          backgroundColor: AppColors.error,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      isSendingForgotOtp.value = false;
      Get.snackbar(
        'Error',
        'An unexpected error occurred.',
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
    }
  }

  void resendForgotOtp() async {
    if (!canResendForgotOtp.value) return;
    final input = forgotPasswordInputController.text.trim();
    try {
      final response = await _authRepo.forgotPasswordSendOtp(email: input);
      if (response.isSuccess) {
        _startForgotResendTimer();
        Get.snackbar(
          'Code Resent',
          'A new OTP has been sent successfully.',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      } else {
        Get.snackbar(
          'Failed',
          response.errorMessage ?? 'Failed to resend OTP.',
          backgroundColor: AppColors.error,
          colorText: Colors.white,
        );
      }
    } catch (_) {}
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
    try {
      final input = forgotPasswordInputController.text.trim();
      final response = await _authRepo.forgotPasswordVerifyOtp(
        email: input,
        otp: code,
      );
      isVerifyingForgotOtp.value = false;

      if (response.isSuccess) {
        // Store the reset token for the next step
        forgotResetToken.value =
            response.responseData?['resetToken']?.toString() ?? '';

        // OTP verified - navigate to reset password screen
        Get.toNamed(Routes.RESET_PASSWORD);

        Get.snackbar(
          'Verified!',
          'OTP confirmed. Please set your new password.',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 3),
        );
      } else {
        Get.snackbar(
          'Verification Failed',
          response.errorMessage ?? 'Invalid OTP code. Please try again.',
          backgroundColor: AppColors.error,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      isVerifyingForgotOtp.value = false;
      Get.snackbar(
        'Error',
        'An unexpected error occurred.',
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
    }
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
    try {
      final input = forgotPasswordInputController.text.trim();
      final token = forgotResetToken.value;
      final response = await _authRepo.forgotPasswordReset(
        email: input,
        resetToken: token,
        newPassword: newPass,
      );
      isResettingPassword.value = false;

      if (response.isSuccess) {
        // Clear all fields
        forgotPasswordInputController.clear();
        forgotNewPasswordController.clear();
        forgotConfirmPasswordController.clear();
        forgotOtpDigits.assignAll(['', '', '', '', '', '']);
        currentForgotOtpIndex.value = 0;
        forgotResetToken.value = '';

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
      } else {
        Get.snackbar(
          'Reset Failed',
          response.errorMessage ?? 'Failed to reset password. Try again.',
          backgroundColor: AppColors.error,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      isResettingPassword.value = false;
      Get.snackbar(
        'Error',
        'An unexpected error occurred.',
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
    }
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

  /// Sign in with Supabase using Native Google Sign-In
  Future<void> signInWithGoogle() async {
    isLoggingIn.value = true;

    try {
      // Load Google Client ID from environment
      final webClientId = dotenv.env['GOOGLE_CLIENT_ID'];

      if (webClientId == null || webClientId.isEmpty) {
        throw const AuthException(
          'Google Client ID not configured in .env file',
        );
      }

      final GoogleSignIn googleSignIn = GoogleSignIn(
        serverClientId: webClientId,
      );

      // Google Sign-In
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        isLoggingIn.value = false;
        return; // User cancelled
      }

      // Google authentication
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final String? idToken = googleAuth.idToken;
      final String? accessToken = googleAuth.accessToken;

      if (idToken == null) {
        throw const AuthException('Could not retrieve ID token from Google.');
      }

      if (accessToken == null) {
        throw const AuthException(
          'Could not retrieve access token from Google.',
        );
      }

      // Supabase login
      final AuthResponse response = await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      final user = response.user;

      if (user != null) {
        await storageService.setBool(StorageKeys.isLoggedIn, true);

        await storageService.setString(
          StorageKeys.userName,
          user.userMetadata?['full_name'] ??
              user.userMetadata?['name'] ??
              user.email?.split('@')[0] ??
              'User',
        );

        await storageService.setString(StorageKeys.userEmail, user.email ?? '');

        await storageService.setString(StorageKeys.userId, user.id);

        Get.snackbar(
          'Success!',
          'Logged in with Google via Supabase',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );

        Get.offAllNamed(Routes.HOME);
      } else {
        isLoggingIn.value = false;
      }
    } on AuthException catch (e) {
      isLoggingIn.value = false;
      debugPrint('Supabase Google Auth Error: ${e.message}');

      Get.snackbar(
        'Login Failed',
        e.message,
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
    } catch (e) {
      isLoggingIn.value = false;
      debugPrint('Supabase Google login error: $e');

      Get.snackbar(
        'Login Failed',
        'An unexpected error occurred. Please try again.',
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
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

  // ============================================================
  // BIOMETRIC AUTHENTICATION
  // ============================================================

  /// Get unique device ID
  Future<void> _getDeviceId() async {
    try {
      String identifier = '';

      if (GetPlatform.isAndroid) {
        final androidInfo = await _deviceInfo.androidInfo;
        identifier = androidInfo.id; // Android ID (unique per device)
      } else if (GetPlatform.isIOS) {
        final iosInfo = await _deviceInfo.iosInfo;
        identifier = iosInfo.identifierForVendor ?? ''; // iOS unique ID
      }

      deviceId.value = identifier;
      debugPrint('Device ID: $identifier');
    } catch (e) {
      debugPrint('Error getting device ID: $e');
    }
  }

  /// Check if biometric is available on device
  Future<void> checkBiometricAvailability() async {
    try {
      final bool canAuthenticateWithBiometrics =
          await _localAuth.canCheckBiometrics;
      final bool canAuthenticate =
          canAuthenticateWithBiometrics || await _localAuth.isDeviceSupported();

      isBiometricAvailable.value = canAuthenticate;

      if (canAuthenticate) {
        final List<BiometricType> availableBiometrics = await _localAuth
            .getAvailableBiometrics();

        if (availableBiometrics.contains(BiometricType.face)) {
          biometricType.value = 'face';
        } else if (availableBiometrics.contains(BiometricType.fingerprint)) {
          biometricType.value = 'fingerprint';
        } else {
          biometricType.value = 'biometric';
        }
      }
    } on PlatformException catch (e) {
      debugPrint('Biometric check error: $e');
      isBiometricAvailable.value = false;
    }
  }

  /// Load biometric settings from storage
  Future<void> loadBiometricSettings() async {
    final enabled =
        storageService.getBool(StorageKeys.biometricEnabled) ?? false;
    final currentEmail = storageService.getString(StorageKeys.userEmail);
    final bioEmail = storageService.getString(StorageKeys.biometricEmail);

    if (enabled && bioEmail != null && bioEmail.isNotEmpty) {
      if (currentEmail != null && currentEmail.isNotEmpty) {
        // User is currently logged in (e.g. in Profile screen)
        isBiometricEnabled.value =
            (bioEmail.trim().toLowerCase() ==
            currentEmail.trim().toLowerCase());
      } else {
        // No active user in session (e.g. on Login screen)
        isBiometricEnabled.value = true;
      }
    } else {
      isBiometricEnabled.value = false;
    }
  }

  /// Enable/Disable biometric login
  Future<void> toggleBiometricLogin() async {
    if (!isBiometricAvailable.value) {
      Get.snackbar(
        'সাপোর্ট করে না',
        'এই ডিভাইসে বায়োমেট্রিক সেন্সর পাওয়া যায়নি বা সক্রিয় নেই',
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
      return;
    }

    // Get current logged-in user email
    final currentEmail =
        (storageService.getString(StorageKeys.userEmail) ??
                loginEmailController.text.trim())
            .trim();

    if (currentEmail.isEmpty) {
      Get.snackbar(
        'লগইন প্রয়োজন',
        'বায়োমেট্রিক সক্রিয় করতে অনুগ্রহ করে প্রথমে একাউন্টে লগইন করুন',
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
      return;
    }

    final registeredEmail = storageService.getString(
      StorageKeys.biometricEmail,
    );
    final isAlreadyEnabled =
        storageService.getBool(StorageKeys.biometricEnabled) ?? false;

    // RULE: "akta finger print diye ektar besi account khola jabe na"
    // Check if device fingerprint is already registered with another account
    if (isAlreadyEnabled &&
        registeredEmail != null &&
        registeredEmail.isNotEmpty &&
        registeredEmail.trim().toLowerCase() != currentEmail.toLowerCase()) {
      Get.defaultDialog(
        title: 'এক ডিভাইসে একটি অ্যাকাউন্ট',
        middleText:
            'এই ডিভাইসের ফিঙ্গারপ্রিন্ট ইতিমধ্যে "$registeredEmail" অ্যাকাউন্টের সাথে যুক্ত রয়েছে।\n\nএকটি ফিঙ্গারপ্রিন্ট কেবল একটি অ্যাকাউন্টের জন্য ব্যবহার করা যাবে। নতুন অ্যাকাউন্টে যুক্ত করতে হলে প্রথমে পূর্বের অ্যাকাউন্ট থেকে ফিঙ্গারপ্রিন্ট বন্ধ করুন।',
        textConfirm: 'ঠিক আছে',
        confirmTextColor: Colors.white,
        buttonColor: AppColors.primary,
        onConfirm: () => Get.back(),
      );
      return;
    }

    if (!isBiometricEnabled.value) {
      // 1. Immediately open the biometric sensor prompt!
      final authenticated = await authenticateWithBiometric(
        reason:
            'বায়োমেট্রিক ফিঙ্গারপ্রিন্ট চালু করতে আপনার আঙ্গুল স্ক্যান করুন',
      );

      if (authenticated) {
        // Retrieve current active session data
        final authToken = storageService.getString(StorageKeys.authToken) ?? '';
        final refreshToken =
            storageService.getString(StorageKeys.refreshToken) ?? '';
        final userName = storageService.getString(StorageKeys.userName) ?? '';
        final userId = storageService.getString(StorageKeys.userId) ?? '';
        final userPhone = storageService.getString(StorageKeys.userPhone) ?? '';

        // Save biometric data for this account
        await storageService.setString(
          StorageKeys.biometricEmail,
          currentEmail,
        );
        await storageService.setString(
          StorageKeys.biometricAuthToken,
          authToken,
        );
        await storageService.setString(
          StorageKeys.biometricRefreshToken,
          refreshToken,
        );
        await storageService.setString(StorageKeys.biometricUserName, userName);
        await storageService.setString(StorageKeys.biometricUserId, userId);
        await storageService.setString(
          StorageKeys.biometricUserPhone,
          userPhone,
        );
        await storageService.setString(
          StorageKeys.biometricDeviceId,
          deviceId.value,
        );
        await storageService.setString(
          StorageKeys.biometricRegisteredAt,
          DateTime.now().toIso8601String(),
        );
        await storageService.setBool(StorageKeys.biometricEnabled, true);
        isBiometricEnabled.value = true;

        Get.snackbar(
          'সফল হয়েছে!',
          'বায়োমেট্রিক ফিঙ্গারপ্রিন্ট সফলভাবে যুক্ত হয়েছে। এখন লগইন স্ক্রিন থেকে সরাসরি ফিঙ্গারপ্রিন্ট দিয়ে লগইন করতে পারবেন।',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 4),
        );
      } else {
        isBiometricEnabled.value = false;
      }
    } else {
      // User is disabling biometric - authenticate first
      final authenticated = await authenticateWithBiometric(
        reason: 'বায়োমেট্রিক ফিঙ্গারপ্রিন্ট বন্ধ করতে স্ক্যান করুন',
      );

      if (authenticated) {
        await storageService.setBool(StorageKeys.biometricEnabled, false);
        await storageService.remove(StorageKeys.biometricEmail);
        await storageService.remove(StorageKeys.biometricAuthToken);
        await storageService.remove(StorageKeys.biometricRefreshToken);
        await storageService.remove(StorageKeys.biometricUserName);
        await storageService.remove(StorageKeys.biometricUserId);
        await storageService.remove(StorageKeys.biometricUserPhone);
        await storageService.remove(StorageKeys.biometricDeviceId);
        await storageService.remove(StorageKeys.biometricRegisteredAt);
        isBiometricEnabled.value = false;

        Get.snackbar(
          'নিষ্ক্রিয় করা হয়েছে',
          'বায়োমেট্রিক লগইন বন্ধ করা হয়েছে।',
          backgroundColor: AppColors.primary,
          colorText: Colors.white,
        );
      }
    }
  }

  /// Authenticate with biometric
  Future<bool> authenticateWithBiometric({
    String reason = 'Authenticate to login',
  }) async {
    try {
      final bool didAuthenticate = await _localAuth.authenticate(
        localizedReason: reason,
        biometricOnly: true,
        persistAcrossBackgrounding: true,
      );

      return didAuthenticate;
    } on PlatformException catch (e) {
      debugPrint('Biometric authentication error: $e');

      if (e.code == 'NotAvailable') {
        Get.snackbar(
          'Not Available',
          'Biometric authentication is not available',
          backgroundColor: AppColors.error,
          colorText: Colors.white,
        );
      } else if (e.code == 'NotEnrolled') {
        Get.snackbar(
          'Not Enrolled',
          'Please enroll biometric authentication in device settings',
          backgroundColor: AppColors.error,
          colorText: Colors.white,
        );
      }

      return false;
    }
  }

  /// Login with biometric (For users who already enabled it)
  Future<void> loginWithBiometric() async {
    if (!isBiometricAvailable.value) {
      Get.snackbar(
        'Not Avaailable',
        'এই ডিভাইসে বায়োমেট্রিক অথেনটিকেশন সক্রিয় নেই',
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
      return;
    }

    final isEnabled =
        storageService.getBool(StorageKeys.biometricEnabled) ?? false;
    final savedEmail = storageService.getString(StorageKeys.biometricEmail);
    final savedToken = storageService.getString(StorageKeys.biometricAuthToken);

    if (!isEnabled || savedEmail == null || savedEmail.isEmpty) {
      Get.defaultDialog(
        title: 'Biometric Not Enabled',
        middleText:
            'এই ডিভাইসে কোনো অ্যাকাউন্টের বায়োমেট্রিক ফিঙ্গারপ্রিন্ট চালু করা নেই।\n\nঅনুগ্রহ করে প্রথমে ইমেইল ও পাসওয়ার্ড দিয়ে লগইন করে প্রোফাইল থেকে ফিঙ্গারপ্রিন্ট চালু করুন।',
        textConfirm: 'OK',
        confirmTextColor: Colors.white,
        buttonColor: AppColors.primary,
        onConfirm: () => Get.back(),
      );
      return;
    }

    // Verify device ID if set
    final savedDeviceId = storageService.getString(
      StorageKeys.biometricDeviceId,
    );
    if (savedDeviceId != null &&
        savedDeviceId.isNotEmpty &&
        deviceId.value.isNotEmpty &&
        savedDeviceId != deviceId.value) {
      Get.snackbar(
        'নিরাপত্তা সতর্কতা',
        'এই ফিঙ্গারপ্রিন্টটি ভিন্ন ডিভাইসের জন্য নিবন্ধিত। অনুগ্রহ করে পাসওয়ার্ড দিয়ে লগইন করুন।',
        backgroundColor: AppColors.error,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
      return;
    }

    // Open biometric sensor prompt!
    final authenticated = await authenticateWithBiometric(
      reason: 'আপনার অ্যাকাউন্টে ($savedEmail) লগইন করতে ফিঙ্গারপ্রিন্ট দিন',
    );

    if (authenticated) {
      // 1. Restore auth token if we have it
      if (savedToken != null && savedToken.isNotEmpty) {
        _networkService.setAuthToken(savedToken);
        await storageService.setString(StorageKeys.authToken, savedToken);
      }

      // 2. Restore refresh token
      final savedRefreshToken = storageService.getString(
        StorageKeys.biometricRefreshToken,
      );
      if (savedRefreshToken != null && savedRefreshToken.isNotEmpty) {
        await storageService.setString(
          StorageKeys.refreshToken,
          savedRefreshToken,
        );
      }

      // 3. Restore user profile data
      final savedName =
          storageService.getString(StorageKeys.biometricUserName) ?? 'User';
      final savedId =
          storageService.getString(StorageKeys.biometricUserId) ?? '';
      final savedPhone =
          storageService.getString(StorageKeys.biometricUserPhone) ?? '';

      await storageService.setString(StorageKeys.userEmail, savedEmail);
      await storageService.setString(StorageKeys.userName, savedName);
      await storageService.setString(StorageKeys.userId, savedId);
      if (savedPhone.isNotEmpty) {
        await storageService.setString(StorageKeys.userPhone, savedPhone);
      }
      await storageService.setBool(StorageKeys.isLoggedIn, true);

      // 4. Try refreshing token in background if possible
      // _networkService.refreshToken();

      // 5. Navigate to Home
      Get.offAllNamed(Routes.HOME);

      Get.snackbar(
        'স্বাগতম!',
        '$savedName, ফিঙ্গারপ্রিন্ট দিয়ে সফলভাবে লগইন করা হয়েছে।',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
      );
    }
  }

  /// Get biometric icon based on type
  IconData get biometricIcon {
    switch (biometricType.value) {
      case 'face':
        return Icons.face;
      case 'fingerprint':
        return Icons.fingerprint;
      default:
        return Icons.lock;
    }
  }

  /// Get biometric text
  String get biometricText {
    switch (biometricType.value) {
      case 'face':
        return 'Face ID';
      case 'fingerprint':
        return 'Fingerprint';
      default:
        return 'Biometric';
    }
  }

  /// Test biometric (for debugging/setup)
  Future<bool> testBiometric() async {
    if (!isBiometricAvailable.value) {
      Get.snackbar(
        'Not Available',
        'Biometric is not available on this device',
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
      return false;
    }

    final result = await authenticateWithBiometric(
      reason: 'Test your ${biometricText.toLowerCase()}',
    );

    if (result) {
      Get.snackbar(
        'Success!',
        '$biometricText is working! ✓',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    }

    return result;
  }
}
