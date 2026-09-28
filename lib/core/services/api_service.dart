import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import '../constants/storage_keys.dart';
import 'storage_service.dart';

class ApiService extends GetxService {
  final StorageService _storageService = Get.find<StorageService>();
  
  late http.Client _client;
  String? _authToken;

  @override
  void onInit() {
    super.onInit();
    _client = http.Client();
    _loadAuthToken();
  }

  @override
  void onClose() {
    _client.close();
    super.onClose();
  }

  // Load auth token from storage
  Future<void> _loadAuthToken() async {
    _authToken = _storageService.getString(StorageKeys.authToken);
  }

  // Set auth token
  void setAuthToken(String token) {
    _authToken = token;
    _storageService.setString(StorageKeys.authToken, token);
  }

  // Clear auth token
  void clearAuthToken() {
    _authToken = null;
    _storageService.remove(StorageKeys.authToken);
  }

  // Build headers
  Map<String, String> _buildHeaders({
    bool needsAuth = true,
    Map<String, String>? additionalHeaders,
  }) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (needsAuth && _authToken != null) {
      headers['Authorization'] = 'Bearer $_authToken';
    }

    if (additionalHeaders != null) {
      headers.addAll(additionalHeaders);
    }

    return headers;
  }

  // Handle response
  dynamic _handleResponse(http.Response response) {
    final statusCode = response.statusCode;

    if (statusCode >= 200 && statusCode < 300) {
      if (response.body.isEmpty) return null;
      return json.decode(response.body);
    }

    // Handle errors
    String errorMessage = 'An error occurred';
    
    try {
      final errorBody = json.decode(response.body);
      errorMessage = errorBody['message'] ?? errorBody['error'] ?? errorMessage;
    } catch (e) {
      errorMessage = response.body.isNotEmpty 
          ? response.body 
          : 'Error: ${response.statusCode}';
    }

    // Handle specific status codes
    switch (statusCode) {
      case 400:
        throw BadRequestException(errorMessage);
      case 401:
        throw UnauthorizedException(errorMessage);
      case 403:
        throw ForbiddenException(errorMessage);
      case 404:
        throw NotFoundException(errorMessage);
      case 422:
        throw ValidationException(errorMessage);
      case 500:
        throw ServerException(errorMessage);
      default:
        throw ApiException(errorMessage, statusCode);
    }
  }

  // Handle errors
  dynamic _handleError(dynamic error) {
    if (error is SocketException) {
      throw NetworkException('No internet connection');
    } else if (error is HttpException) {
      throw NetworkException('Network error occurred');
    } else if (error is FormatException) {
      throw ApiException('Invalid response format');
    } else if (error is ApiException) {
    } else {
      throw ApiException('Unexpected error: ${error.toString()}');
    }
  }

  // GET request
  Future<dynamic> get(
    String endpoint, {
    Map<String, dynamic>? queryParams,
    bool needsAuth = true,
    Map<String, String>? headers,
  }) async {
    try {
      final url = queryParams != null
          ? ApiConstants.buildUrlWithParams(endpoint, queryParams)
          : ApiConstants.buildUrl(endpoint);

      final response = await _client
          .get(
            Uri.parse(url),
            headers: _buildHeaders(
              needsAuth: needsAuth,
              additionalHeaders: headers,
            ),
          )
          .timeout(Duration(milliseconds: ApiConstants.connectionTimeout));

      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  // POST request
  Future<dynamic> post(
    String endpoint, {
    dynamic body,
    bool needsAuth = true,
    Map<String, String>? headers,
  }) async {
    try {
      final url = ApiConstants.buildUrl(endpoint);

      final response = await _client
          .post(
            Uri.parse(url),
            headers: _buildHeaders(
              needsAuth: needsAuth,
              additionalHeaders: headers,
            ),
            body: body != null ? json.encode(body) : null,
          )
          .timeout(Duration(milliseconds: ApiConstants.connectionTimeout));

      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  // PUT request
  Future<dynamic> put(
    String endpoint, {
    dynamic body,
    bool needsAuth = true,
    Map<String, String>? headers,
  }) async {
    try {
      final url = ApiConstants.buildUrl(endpoint);

      final response = await _client
          .put(
            Uri.parse(url),
            headers: _buildHeaders(
              needsAuth: needsAuth,
              additionalHeaders: headers,
            ),
            body: body != null ? json.encode(body) : null,
          )
          .timeout(Duration(milliseconds: ApiConstants.connectionTimeout));

      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  // PATCH request
  Future<dynamic> patch(
    String endpoint, {
    dynamic body,
    bool needsAuth = true,
    Map<String, String>? headers,
  }) async {
    try {
      final url = ApiConstants.buildUrl(endpoint);

      final response = await _client
          .patch(
            Uri.parse(url),
            headers: _buildHeaders(
              needsAuth: needsAuth,
              additionalHeaders: headers,
            ),
            body: body != null ? json.encode(body) : null,
          )
          .timeout(Duration(milliseconds: ApiConstants.connectionTimeout));

      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  // DELETE request
  Future<dynamic> delete(
    String endpoint, {
    dynamic body,
    bool needsAuth = true,
    Map<String, String>? headers,
  }) async {
    try {
      final url = ApiConstants.buildUrl(endpoint);

      final response = await _client
          .delete(
            Uri.parse(url),
            headers: _buildHeaders(
              needsAuth: needsAuth,
              additionalHeaders: headers,
            ),
            body: body != null ? json.encode(body) : null,
          )
          .timeout(Duration(milliseconds: ApiConstants.connectionTimeout));

      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  // Multipart request (for file uploads)
  Future<dynamic> uploadFile(
    String endpoint, {
    required File file,
    required String fieldName,
    Map<String, String>? additionalFields,
    bool needsAuth = true,
  }) async {
    try {
      final url = ApiConstants.buildUrl(endpoint);
      final request = http.MultipartRequest('POST', Uri.parse(url));

      // Add headers
      final headers = _buildHeaders(needsAuth: needsAuth);
      headers.remove('Content-Type'); // Remove for multipart
      request.headers.addAll(headers);

      // Add file
      request.files.add(
        await http.MultipartFile.fromPath(fieldName, file.path),
      );

      // Add additional fields
      if (additionalFields != null) {
        request.fields.addAll(additionalFields);
      }

      final streamedResponse = await request.send().timeout(
            Duration(milliseconds: ApiConstants.connectionTimeout),
          );

      final response = await http.Response.fromStream(streamedResponse);

      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }
}

// Custom Exceptions
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, [this.statusCode]);

  @override
  String toString() => message;
}

class NetworkException extends ApiException {
  NetworkException(super.message);
}

class BadRequestException extends ApiException {
  BadRequestException(String message) : super(message, 400);
}

class UnauthorizedException extends ApiException {
  UnauthorizedException(String message) : super(message, 401);
}

class ForbiddenException extends ApiException {
  ForbiddenException(String message) : super(message, 403);
}

class NotFoundException extends ApiException {
  NotFoundException(String message) : super(message, 404);
}

class ValidationException extends ApiException {
  ValidationException(String message) : super(message, 422);
}

class ServerException extends ApiException {
  ServerException(String message) : super(message, 500);
}
