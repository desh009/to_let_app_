class LoginResponseModel {
  final bool success;
  final String message;
  final LoginData? data;

  LoginResponseModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      success: json['success'] ?? (json['data'] != null),
      message: json['message'] ?? json['msg'] ?? '',
      data: json['data'] != null ? LoginData.fromJson(json['data']) : null,
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

class LoginData {
  final String token;
  final String? refreshToken;
  final LoginUser user;

  LoginData({
    required this.token,
    this.refreshToken,
    required this.user,
  });

  factory LoginData.fromJson(Map<String, dynamic> json) {
    return LoginData(
      token: json['token'] ?? '',
      refreshToken: json['refresh_token'],
      user: LoginUser.fromJson(json['user'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      if (refreshToken != null) 'refresh_token': refreshToken,
      'user': user.toJson(),
    };
  }
}

class LoginUser {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? avatar;

  LoginUser({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.avatar,
  });

  factory LoginUser.fromJson(Map<String, dynamic> json) {
    return LoginUser(
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
