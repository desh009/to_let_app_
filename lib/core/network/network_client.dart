import 'dart:convert';
import 'dart:ui';
import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'network_response.dart';

class NetworkClient {
  final Logger _logger = Logger();

  final Map<String, String> Function() commonHeaders;
  final VoidCallback onUnAuthorize;
  final Future<bool> Function()? onRefreshToken;
  final String _defaultMessage = 'Something went wrong';

  NetworkClient({
    required this.onUnAuthorize,
    required this.commonHeaders,
    this.onRefreshToken,
  });

  /// GET Request
  Future<NetworkResponse> getRequest(String url) async {
    try {
      Uri uri = Uri.parse(url);
      _logRequest(url, headers: commonHeaders());

      final Response response = await get(uri, headers: commonHeaders());
      _logResponse(response);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseBody = jsonDecode(response.body);
        return NetworkResponse(
          isSuccess: true,
          statusCode: response.statusCode,
          responseData: responseBody,
        );
      } else if (response.statusCode == 401) {
        try {
          final responseBody = jsonDecode(response.body);
          if (responseBody['error'] != null || responseBody['message'] != null || responseBody['msg'] != null) {
            return NetworkResponse(
              isSuccess: false,
              statusCode: response.statusCode,
              errorMessage: responseBody['error'] ?? responseBody['message'] ?? responseBody['msg'] ?? 'Unauthorized',
            );
          }
        } catch (_) {}

        if (onRefreshToken != null) {
          final refreshed = await onRefreshToken!();
          if (refreshed) {
            // Retry the request once
            return await getRequest(url);
          }
        }

        onUnAuthorize();
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
          errorMessage: 'Un-Authorize',
        );
      } else {
        try {
          final responseBody = jsonDecode(response.body);
          return NetworkResponse(
            isSuccess: false,
            statusCode: response.statusCode,
            errorMessage: responseBody['error'] ?? responseBody['message'] ?? responseBody['msg'] ?? responseBody['errorMessage'] ?? _defaultMessage,
          );
        } catch (_) {
          return NetworkResponse(
            isSuccess: false,
            statusCode: response.statusCode,
            errorMessage: _defaultMessage,
          );
        }
      }
    } on Exception catch (e) {
      return NetworkResponse(
        isSuccess: false,
        statusCode: -1,
        errorMessage: e.toString(),
      );
    }
  }

  /// POST Request
  Future<NetworkResponse> postRequest(
    String url, {
    Map<String, dynamic>? body,
  }) async {
    try {
      Uri uri = Uri.parse(url);
      _logRequest(url, headers: commonHeaders(), body: body);

      final Response response = await post(
        uri,
        headers: commonHeaders(),
        body: jsonEncode(body),
      );
      _logResponse(response);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseBody = jsonDecode(response.body);
        return NetworkResponse(
          isSuccess: true,
          statusCode: response.statusCode,
          responseData: responseBody,
        );
      } else if (response.statusCode == 401) {
        try {
          final responseBody = jsonDecode(response.body);
          if (responseBody['error'] != null || responseBody['message'] != null || responseBody['msg'] != null) {
            return NetworkResponse(
              isSuccess: false,
              statusCode: response.statusCode,
              errorMessage: responseBody['error'] ?? responseBody['message'] ?? responseBody['msg'] ?? 'Unauthorized',
            );
          }
        } catch (_) {}

        if (onRefreshToken != null) {
          final refreshed = await onRefreshToken!();
          if (refreshed) {
            // Retry the request once
            return await postRequest(url, body: body);
          }
        }
        
        onUnAuthorize();
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
          errorMessage: 'Un-Authorize',
        );
      } else {
        try {
          final responseBody = jsonDecode(response.body);
          return NetworkResponse(
            isSuccess: false,
            statusCode: response.statusCode,
            errorMessage: responseBody['error'] ?? responseBody['message'] ?? responseBody['msg'] ?? responseBody['errorMessage'] ?? _defaultMessage,
          );
        } catch (_) {
          return NetworkResponse(
            isSuccess: false,
            statusCode: response.statusCode,
            errorMessage: _defaultMessage,
          );
        }
      }
    } on Exception catch (e) {
      return NetworkResponse(
        isSuccess: false,
        statusCode: -1,
        errorMessage: e.toString(),
      );
    }
  }

  /// PUT Request
  Future<NetworkResponse> putRequest(
    String url, {
    Map<String, dynamic>? body,
  }) async {
    try {
      Uri uri = Uri.parse(url);
      _logRequest(url, headers: commonHeaders(), body: body);

      final Response response = await put(
        uri,
        headers: commonHeaders(),
        body: jsonEncode(body),
      );
      _logResponse(response);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseBody = jsonDecode(response.body);
        return NetworkResponse(
          isSuccess: true,
          statusCode: response.statusCode,
          responseData: responseBody,
        );
      } else if (response.statusCode == 401) {
        try {
          final responseBody = jsonDecode(response.body);
          if (responseBody['error'] != null || responseBody['message'] != null || responseBody['msg'] != null) {
            return NetworkResponse(
              isSuccess: false,
              statusCode: response.statusCode,
              errorMessage: responseBody['error'] ?? responseBody['message'] ?? responseBody['msg'] ?? 'Unauthorized',
            );
          }
        } catch (_) {}

        if (onRefreshToken != null) {
          final refreshed = await onRefreshToken!();
          if (refreshed) {
            // Retry the request once
            return await getRequest(url);
          }
        }

        onUnAuthorize();
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
          errorMessage: 'Un-Authorize',
        );
      } else {
        try {
          final responseBody = jsonDecode(response.body);
          return NetworkResponse(
            isSuccess: false,
            statusCode: response.statusCode,
            errorMessage: responseBody['error'] ?? responseBody['message'] ?? responseBody['msg'] ?? responseBody['errorMessage'] ?? _defaultMessage,
          );
        } catch (_) {
          return NetworkResponse(
            isSuccess: false,
            statusCode: response.statusCode,
            errorMessage: _defaultMessage,
          );
        }
      }
    } on Exception catch (e) {
      return NetworkResponse(
        isSuccess: false,
        statusCode: -1,
        errorMessage: e.toString(),
      );
    }
  }

  /// PATCH Request
  Future<NetworkResponse> patchRequest(
    String url, {
    Map<String, dynamic>? body,
  }) async {
    try {
      Uri uri = Uri.parse(url);
      _logRequest(url, headers: commonHeaders(), body: body);

      final Response response = await patch(
        uri,
        headers: commonHeaders(),
        body: jsonEncode(body),
      );
      _logResponse(response);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseBody = jsonDecode(response.body);
        return NetworkResponse(
          isSuccess: true,
          statusCode: response.statusCode,
          responseData: responseBody,
        );
      } else if (response.statusCode == 401) {
        try {
          final responseBody = jsonDecode(response.body);
          if (responseBody['error'] != null || responseBody['message'] != null || responseBody['msg'] != null) {
            return NetworkResponse(
              isSuccess: false,
              statusCode: response.statusCode,
              errorMessage: responseBody['error'] ?? responseBody['message'] ?? responseBody['msg'] ?? 'Unauthorized',
            );
          }
        } catch (_) {}

        if (onRefreshToken != null) {
          final refreshed = await onRefreshToken!();
          if (refreshed) {
            // Retry the request once
            return await getRequest(url);
          }
        }

        onUnAuthorize();
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
          errorMessage: 'Un-Authorize',
        );
      } else {
        try {
          final responseBody = jsonDecode(response.body);
          return NetworkResponse(
            isSuccess: false,
            statusCode: response.statusCode,
            errorMessage: responseBody['error'] ?? responseBody['message'] ?? responseBody['msg'] ?? responseBody['errorMessage'] ?? _defaultMessage,
          );
        } catch (_) {
          return NetworkResponse(
            isSuccess: false,
            statusCode: response.statusCode,
            errorMessage: _defaultMessage,
          );
        }
      }
    } on Exception catch (e) {
      return NetworkResponse(
        isSuccess: false,
        statusCode: -1,
        errorMessage: e.toString(),
      );
    }
  }

  /// DELETE Request
  Future<NetworkResponse> deleteRequest(String url) async {
    try {
      Uri uri = Uri.parse(url);
      _logRequest(url, headers: commonHeaders());

      final Response response = await delete(
        uri,
        headers: commonHeaders(),
      );
      _logResponse(response);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseBody = jsonDecode(response.body);
        return NetworkResponse(
          isSuccess: true,
          statusCode: response.statusCode,
          responseData: responseBody,
        );
      } else if (response.statusCode == 401) {
        try {
          final responseBody = jsonDecode(response.body);
          if (responseBody['error'] != null || responseBody['message'] != null || responseBody['msg'] != null) {
            return NetworkResponse(
              isSuccess: false,
              statusCode: response.statusCode,
              errorMessage: responseBody['error'] ?? responseBody['message'] ?? responseBody['msg'] ?? 'Unauthorized',
            );
          }
        } catch (_) {}

        if (onRefreshToken != null) {
          final refreshed = await onRefreshToken!();
          if (refreshed) {
            // Retry the request once
            return await getRequest(url);
          }
        }

        onUnAuthorize();
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
          errorMessage: 'Un-Authorize',
        );
      } else {
        try {
          final responseBody = jsonDecode(response.body);
          return NetworkResponse(
            isSuccess: false,
            statusCode: response.statusCode,
            errorMessage: responseBody['error'] ?? responseBody['message'] ?? responseBody['msg'] ?? responseBody['errorMessage'] ?? _defaultMessage,
          );
        } catch (_) {
          return NetworkResponse(
            isSuccess: false,
            statusCode: response.statusCode,
            errorMessage: _defaultMessage,
          );
        }
      }
    } on Exception catch (e) {
      return NetworkResponse(
        isSuccess: false,
        statusCode: -1,
        errorMessage: e.toString(),
      );
    }
  }

  /// Log Request Details
  void _logRequest(
    String url, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) {
    final String message = '''
    URL-> $url
    HEADERS-> $headers
    BODY-> $body
    ''';
    _logger.i(message);
  }

  /// Log Response Details
  void _logResponse(Response response) {
    final String message = '''
    URL-> ${response.request?.url}
    STATUS-CODE-> ${response.statusCode}
    HEADERS-> ${response.headers}
    BODY-> ${response.body}
    ''';
    _logger.i(message);
  }
}
