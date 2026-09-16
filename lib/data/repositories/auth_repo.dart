import 'package:get/get.dart';
import '../../core/config/urls.dart';
import '../../core/network/network_response.dart';
import '../../core/services/network_service.dart';
import '../models/register_otp_model.dart';
import '../models/verify_otp_model.dart';

class AuthRepo {
  final NetworkService _networkService = Get.find<NetworkService>();

  // Register - Send OTP
  Future<NetworkResponse> registerSendOtp({
    required String email,
    required String fullName,
    required String phone,
    required String password,
  }) async {
    return await _networkService.post(
      Urls.registerSendOtp,
      body: {
        'email': email,
        'name': fullName,
        'phone': phone,
        'password': password,
      },
    );
  }

  // Parse Register OTP Response
  RegisterOtpModel? parseRegisterOtpResponse(NetworkResponse response) {
    if (response.isSuccess && response.responseData != null) {
      return RegisterOtpModel.fromJson(response.responseData!);
    }
    return null;
  }

  // Register - Verify OTP
  Future<NetworkResponse> registerVerifyOtp({
    required String email,
    required String otp,
  }) async {
    return await _networkService.post(
      Urls.registerVerifyOtp,
      body: {'email': email, 'otp': otp},
    );
  }

  // Parse Verify OTP Response
  VerifyOtpModel? parseVerifyOtpResponse(NetworkResponse response) {
    if (response.isSuccess && response.responseData != null) {
      return VerifyOtpModel.fromJson(response.responseData!);
    }
    return null;
  }

  // Register - Resend OTP
  Future<NetworkResponse> registerResendOtp({required String email}) async {
    return await _networkService.post(
      Urls.registerResendOtp,
      body: {'email': email},
    );
  }

  // Parse Resend OTP Response (same structure as send OTP)
  RegisterOtpModel? parseResendOtpResponse(NetworkResponse response) {
    if (response.isSuccess && response.responseData != null) {
      return RegisterOtpModel.fromJson(response.responseData!);
    }
    return null;
  }

  // Login
  Future<NetworkResponse> login({
    required String email,
    required String password,
  }) async {
    return await _networkService.post(
      Urls.login,
      body: {'email': email, 'password': password},
    );
  }

  // Forgot Password - Send OTP
  Future<NetworkResponse> forgotPasswordSendOtp({required String email}) async {
    return await _networkService.post(
      Urls.forgotPasswordSendOtp,
      body: {'email': email},
    );
  }

  // Forgot Password - Verify OTP
  Future<NetworkResponse> forgotPasswordVerifyOtp({
    required String email,
    required String otp,
  }) async {
    return await _networkService.post(
      Urls.forgotPasswordVerifyOtp,
      body: {'email': email, 'otp': otp},
    );
  }

  // Reset Password
  Future<NetworkResponse> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    return await _networkService.post(
      Urls.resetPassword,
      body: {'email': email, 'otp': otp, 'new_password': newPassword},
    );
  }

  // Logout
  Future<NetworkResponse> logout() async {
    final response = await _networkService.post(Urls.logout);
    if (response.isSuccess) {
      _networkService.clearAuthToken();
    }
    return response;
  }
}
