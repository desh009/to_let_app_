class VerifyOtpResponseModel {
  final bool success;
  final String message;
  final UserData? data;

  VerifyOtpResponseModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory VerifyOtpResponseModel.fromJson(Map<String, dynamic> json) {
    return VerifyOtpResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? UserData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      if (data != null) 'data': data!.toJson(),
    };
  }
}

class UserData {
  final String? token;
  final String? refreshToken;
  final User? user;

  UserData({
    this.token,
    this.refreshToken,
    this.user,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      token: json['token'],
      refreshToken: json['refresh_token'],
      user: json['user'] != null ? User.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (token != null) 'token': token,
      if (refreshToken != null) 'refresh_token': refreshToken,
      if (user != null) 'user': user!.toJson(),
    };
  }
}

class User {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? avatar;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.avatar,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? json['_id'] ?? '',
      name: json['name'] ?? json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      avatar: json['avatar'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      if (phone != null) 'phone': phone,
      if (avatar != null) 'avatar': avatar,
    };
  }
}
