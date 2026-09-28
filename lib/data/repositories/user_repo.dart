import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../core/config/urls.dart';
import '../../core/network/network_response.dart';
import '../../core/services/network_service.dart';
import '../models/user_profile_model.dart';

class UserRepo {
  final NetworkService _networkService = Get.find<NetworkService>();

  /// Get current user profile
  Future<NetworkResponse> getProfile() async {
    return await _networkService.get(Urls.profile);
  }

  /// Parse profile response
  UserProfileModel? parseProfile(NetworkResponse response) {
    if (response.isSuccess && response.responseData != null) {
      try {
        final data = response.responseData!['data'];
        if (data is Map<String, dynamic>) {
          return UserProfileModel.fromJson(data);
        }
      } catch (e) {
        debugPrint('Error parsing user profile: $e');
      }
    }
    return null;
  }

  /// Update user profile
  Future<NetworkResponse> updateProfile({
    String? name,
    String? phone,
    String? bio,
    String? address,
    String? city,
    String? avatarUrl,
  }) async {
    final body = <String, dynamic>{};
    if (name != null) body['name'] = name;
    if (phone != null) body['phone'] = phone;
    if (bio != null) body['bio'] = bio;
    if (address != null) body['address'] = address;
    if (city != null) body['city'] = city;
    if (avatarUrl != null) body['avatarUrl'] = avatarUrl;

    return await _networkService.put(Urls.updateProfile, body: body);
  }



  /// Upload avatar image
  Future<NetworkResponse> uploadAvatar(String base64Image) async {
    return await _networkService.post(
      Urls.uploadAvatar,
      body: {'image': base64Image},
    );
  }

  /// Change password
  Future<NetworkResponse> changePassword({
    String? currentPassword,
    required String newPassword,
  }) async {
    final body = <String, dynamic>{
      'newPassword': newPassword,
      if (currentPassword != null && currentPassword.isNotEmpty)
        'currentPassword': currentPassword,
    };

    return await _networkService.put(Urls.changePassword, body: body);
  }
}
