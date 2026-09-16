class RegisterOtpResponseModel {
  final bool success;
  final String message;
  final String email;
  final String? otp; // For testing/debugging only

  RegisterOtpResponseModel({
    required this.success,
    required this.message,
    required this.email,
    this.otp,
  });

  factory RegisterOtpResponseModel.fromJson(Map<String, dynamic> json) {
    return RegisterOtpResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      email: json['email'] ?? '',
      otp: json['otp'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'email': email,
      if (otp != null) 'otp': otp,
    };
  }

  @override
  String toString() {
    return 'RegisterOtpResponseModel(success: $success, message: $message, email: $email)';
  }
}
