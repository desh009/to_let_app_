class RegisterOtpModel {
  final bool success;
  final String message;
  final String email;
  final String? otp;

  RegisterOtpModel({
    required this.success,
    required this.message,
    required this.email,
    this.otp,
  });

  factory RegisterOtpModel.fromJson(Map<String, dynamic> json) {
    return RegisterOtpModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      email: json['email'] ?? '',
      otp: json['otp'],
    );
  }
}
