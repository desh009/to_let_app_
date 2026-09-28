import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:to_let_app_abandon/core/config/urls.dart';
import '../constants/storage_keys.dart';
import '../network/network_client.dart';
import '../network/network_response.dart';
import '../../routes/app_routes.dart';
import 'storage_service.dart';

class NetworkService extends GetxService {
  late NetworkClient _networkClient;
  final StorageService _storageService = Get.find<StorageService>();

  @override
  void onInit() {
    super.onInit();
    _initNetworkClient();
  }

  void _initNetworkClient() {
    _networkClient = NetworkClient(
      onUnAuthorize: _onUnAuthorize,
      commonHeaders: _getCommonHeaders,
      onRefreshToken: refreshToken,
    );
  }

  /// Common Headers for all requests
Map<String, String> _getCommonHeaders() {
  final token = _storageService.getString(StorageKeys.authToken);

  debugPrint('========== AUTH HEADER ==========');
  debugPrint('Token exists: ${token != null && token.isNotEmpty}');
  debugPrint(
    'Token preview: ${token == null || token.isEmpty ? 'NULL' : '${token.substring(0, token.length > 20 ? 20 : token.length)}...'}',
  );
  debugPrint('=================================');

  return {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    if (token != null && token.isNotEmpty)
      'Authorization': 'Bearer $token',
  };
}

  /// Handle Unauthorized (401) Response
  void _onUnAuthorize() {
    // Clear user data
    _storageService.remove(StorageKeys.authToken);
    _storageService.remove(StorageKeys.userId);
    _storageService.setBool(StorageKeys.isLoggedIn, false);

    // Show message
    Get.snackbar(
      'Session Expired',
      'Please login again',
      snackPosition: SnackPosition.BOTTOM,
    );

    // Navigate to login
    Get.offAllNamed(Routes.LOGIN);
  }

  /// Build full API URL
  String _buildUrl(String endpoint) {
    if (endpoint.startsWith('http')) {
      return endpoint; // Already a full URL
    }
    return endpoint; // URLs are already complete in urls.dart
  }

  /// GET Request with Query Parameters
  Future<NetworkResponse> get(
    String endpoint, {
    Map<String, dynamic>? queryParams,
  }) async {
    final url = _buildUrl(endpoint);
    String finalUrl = url;

    if (queryParams != null && queryParams.isNotEmpty) {
      final query = queryParams.entries
          .where((e) => e.value != null)
          .map((e) => '${e.key}=${Uri.encodeComponent(e.value.toString())}')
          .join('&');
      finalUrl = '$url?$query';
    }

    return await _networkClient.getRequest(finalUrl);
  }

  /// POST Request
  Future<NetworkResponse> post(
    String endpoint, {
    Map<String, dynamic>? body,
  }) async {
    final url = _buildUrl(endpoint);
    return await _networkClient.postRequest(url, body: body);
  }

  /// PUT Request
  Future<NetworkResponse> put(
    String endpoint, {
    Map<String, dynamic>? body,
  }) async {
    final url = _buildUrl(endpoint);
    return await _networkClient.putRequest(url, body: body);
  }

  /// PATCH Request
  Future<NetworkResponse> patch(
    String endpoint, {
    Map<String, dynamic>? body,
  }) async {
    final url = _buildUrl(endpoint);
    return await _networkClient.patchRequest(url, body: body);
  }

  /// DELETE Request
  Future<NetworkResponse> delete(String endpoint) async {
    final url = _buildUrl(endpoint);
    return await _networkClient.deleteRequest(url);
  }

  /// Set Auth Token
  void setAuthToken(String token) {
    _storageService.setString(StorageKeys.authToken, token);
  }

  /// Clear Auth Token
  void clearAuthToken() {
    _storageService.remove(StorageKeys.authToken);
  }

  /// Get Auth Token
  String? getAuthToken() {
    return _storageService.getString(StorageKeys.authToken);
  }

  /// Attempt to refresh token using the refresh token
  Future<bool> refreshToken() async {
    final refresh = _storageService.getString(StorageKeys.refreshToken);
    if (refresh == null || refresh.isEmpty) return false;

    try {
      final response = await _networkClient.postRequest(
        Urls.refreshToken,
        body: {'refreshToken': refresh},
      );

      if (response.isSuccess && response.responseData?['data'] != null) {
        final data = response.responseData!['data'];
        final newToken = data['idToken']?.toString();
        final newRefresh = data['refreshToken']?.toString();

        if (newToken != null && newToken.isNotEmpty) {
          setAuthToken(newToken);
          if (newRefresh != null && newRefresh.isNotEmpty) {
            await _storageService.setString(StorageKeys.refreshToken, newRefresh);
          }
          return true;
        }
      }
    } catch (e) {
      debugPrint('Token refresh failed: $e');
    }
    return false;
  }
}
