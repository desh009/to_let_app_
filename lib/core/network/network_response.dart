class NetworkResponse {
  final int statusCode;
  final bool isSuccess;
  final Map<String, dynamic>? responseData;
  final String? errorMessage;

  NetworkResponse({
    required this.isSuccess,
    required this.statusCode,
    this.responseData,
    this.errorMessage,
  });

  @override
  String toString() {
    return 'NetworkResponse(statusCode: $statusCode, isSuccess: $isSuccess, responseData: $responseData, errorMessage: $errorMessage)';
  }
}
