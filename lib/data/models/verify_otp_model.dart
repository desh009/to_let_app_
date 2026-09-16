class VerifyOtpModel {
  final bool success;
  final String message;
  final VerifyOtpData? data;

  VerifyOtpModel({required this.success, required this.message, this.data});

  factory VerifyOtpModel.fromJson(Map<String, dynamic> json) {
    return VerifyOtpModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? VerifyOtpData.fromJson(json['data']) : null,
    );
  }
}

class VerifyOtpData {
  final UserInfo user;
  final String idToken;
  final String refreshToken;
  final int expiresIn;

  VerifyOtpData({
    required this.user,
    required this.idToken,
    required this.refreshToken,
    required this.expiresIn,
  });

  factory VerifyOtpData.fromJson(Map<String, dynamic> json) {
    return VerifyOtpData(
      user: UserInfo.fromJson(json['user'] ?? {}),
      idToken: json['idToken'] ?? '',
      refreshToken: json['refreshToken'] ?? '',
      expiresIn: json['expiresIn'] ?? 3600,
    );
  }
}

class UserInfo {
  final String uid;
  final String email;
  final String name;
  final String? id;
  final String? phone;

  UserInfo({
    required this.uid,
    required this.email,
    required this.name,
    this.id,
    this.phone,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      uid: json['uid'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      id: json['id'] ?? json['uid'], // Use uid as fallback for id
      phone: json['phone'],
    );
  }
}
