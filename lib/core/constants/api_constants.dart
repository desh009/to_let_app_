import 'package:to_let_app_abandon/core/config/urls.dart';

class ApiConstants {
  // Connection timeout in milliseconds
  static const int connectionTimeout = 30000;
  static const int receiveTimeout = 30000;

  // Build URL
  static String buildUrl(String endpoint) {
    // If endpoint already starts with http, return as-is
    if (endpoint.startsWith('http://') || endpoint.startsWith('https://')) {
      return endpoint;
    }
    
    // Remove leading slash if present to avoid double slashes
    final cleanEndpoint = endpoint.startsWith('/') ? endpoint.substring(1) : endpoint;
    
    return '${Urls.baseUrl}/$cleanEndpoint';
  }

  // Build URL with query parameters
  static String buildUrlWithParams(String endpoint, Map<String, dynamic> queryParams) {
    final baseUrl = buildUrl(endpoint);
    
    if (queryParams.isEmpty) {
      return baseUrl;
    }

    final queryString = queryParams.entries
        .where((entry) => entry.value != null)
        .map((entry) => '${entry.key}=${Uri.encodeComponent(entry.value.toString())}')
        .join('&');

    return '$baseUrl?$queryString';
  }
}
