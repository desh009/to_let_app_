# API Usage Guide

This document explains how to use the API service in the To-Let app.

## Setup

### 1. Configure Base URL

Open `lib/core/constants/api_constants.dart` and update the base URL:

```dart
static const String baseUrl = 'https://your-api-domain.com/api/v1';
```

For different environments:
```dart
static const String devBaseUrl = 'https://dev-api.tolet.com/api/v1';
static const String stagingBaseUrl = 'https://staging-api.tolet.com/api/v1';
static const String productionBaseUrl = 'https://api.tolet.com/api/v1';
```

### 2. API Service is Auto-Initialized

The `ApiService` is initialized in `main.dart`:
```dart
Get.put(ApiService(), permanent: true);
```

## Using API in Controllers

### Example 1: Login API Call

```dart
import 'package:get/get.dart';
import '../../data/repositories/auth_repository.dart';
import '../../core/services/api_service.dart';

class AuthController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();
  final ApiService _apiService = Get.find<ApiService>();
  
  final RxBool isLoggingIn = false.obs;

  Future<void> login(String email, String password) async {
    try {
      isLoggingIn.value = true;
      
      // Call API
      final response = await _authRepository.login(
        email: email,
        password: password,
      );
      
      // Extract token from response
      final token = response['data']['token'];
      final user = response['data']['user'];
      
      // Save token
      _apiService.setAuthToken(token);
      
      // Navigate to home
      Get.offAllNamed(Routes.HOME);
      
      Get.snackbar('Success', 'Login successful!');
      
    } on UnauthorizedException catch (e) {
      Get.snackbar('Error', e.message);
    } on NetworkException catch (e) {
      Get.snackbar('Network Error', e.message);
    } catch (e) {
      Get.snackbar('Error', 'An unexpected error occurred');
    } finally {
      isLoggingIn.value = false;
    }
  }
}
```

### Example 2: Register API Call

```dart
Future<void> register({
  required String fullName,
  required String email,
  required String phone,
  required String password,
}) async {
  try {
    isRegistering.value = true;
    
    final response = await _authRepository.register(
      fullName: fullName,
      email: email,
      phone: phone,
      password: password,
    );
    
    // Navigate to OTP screen
    Get.toNamed(Routes.REGISTRATION_OTP);
    
    Get.snackbar('Success', 'OTP sent to your email');
    
  } on ValidationException catch (e) {
    Get.snackbar('Validation Error', e.message);
  } on ApiException catch (e) {
    Get.snackbar('Error', e.message);
  } finally {
    isRegistering.value = false;
  }
}
```

### Example 3: Forgot Password

```dart
Future<void> sendForgotPasswordOtp(String email) async {
  try {
    isSendingOtp.value = true;
    
    final response = await _authRepository.forgotPassword(
      email: email,
    );
    
    Get.toNamed(Routes.FORGOT_PASSWORD_OTP);
    Get.snackbar('Success', 'OTP sent to your email');
    
  } on NotFoundException catch (e) {
    Get.snackbar('Error', 'Email not found');
  } catch (e) {
    Get.snackbar('Error', 'Failed to send OTP');
  } finally {
    isSendingOtp.value = false;
  }
}
```

## Direct API Service Usage

If you need to call an API directly without repository:

```dart
final ApiService _apiService = Get.find<ApiService>();

// GET request
Future<void> fetchData() async {
  try {
    final response = await _apiService.get(
      '/properties',
      queryParams: {'page': 1, 'limit': 10},
      needsAuth: true,
    );
    
    print('Data: $response');
  } catch (e) {
    print('Error: $e');
  }
}

// POST request
Future<void> createProperty() async {
  try {
    final response = await _apiService.post(
      '/properties/create',
      body: {
        'title': 'Beautiful Apartment',
        'price': 50000,
        'location': 'Dhaka',
      },
      needsAuth: true,
    );
    
    print('Created: $response');
  } catch (e) {
    print('Error: $e');
  }
}

// Upload file
Future<void> uploadImage(File imageFile) async {
  try {
    final response = await _apiService.uploadFile(
      '/user/upload-avatar',
      file: imageFile,
      fieldName: 'avatar',
      additionalFields: {
        'user_id': '123',
      },
      needsAuth: true,
    );
    
    print('Uploaded: $response');
  } catch (e) {
    print('Error: $e');
  }
}
```

## Error Handling

The API service throws different exceptions based on HTTP status codes:

```dart
try {
  final response = await _apiService.get('/endpoint');
} on NetworkException catch (e) {
  // No internet connection
  print('Network error: ${e.message}');
} on UnauthorizedException catch (e) {
  // 401 - Token expired, redirect to login
  Get.offAllNamed(Routes.LOGIN);
} on NotFoundException catch (e) {
  // 404 - Resource not found
  print('Not found: ${e.message}');
} on ValidationException catch (e) {
  // 422 - Validation error
  print('Validation: ${e.message}');
} on ServerException catch (e) {
  // 500 - Server error
  print('Server error: ${e.message}');
} on ApiException catch (e) {
  // Generic API error
  print('API error: ${e.message}');
}
```

## API Response Format

Expected response format from backend:

```json
{
  "success": true,
  "message": "Operation successful",
  "data": {
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "user": {
      "id": "123",
      "name": "John Doe",
      "email": "john@example.com"
    }
  }
}
```

Error response:
```json
{
  "success": false,
  "message": "Invalid credentials",
  "error": "INVALID_CREDENTIALS"
}
```

## Available Endpoints

See `lib/core/constants/api_constants.dart` for all available endpoints:

- **Auth**: login, register, verify-otp, forgot-password, reset-password
- **User**: profile, update-profile, change-password, upload-avatar
- **Properties**: list, details, create, update, delete, search, filter
- **Favorites**: add, remove, list
- **Messages**: conversations, send, get-messages
- **Notifications**: list, mark-read, delete
- **Support**: contact, report-problem, feedback
- **2FA**: enable, disable, verify

## Testing API

Use Postman or cURL to test your backend first before integrating.

Example cURL:
```bash
curl -X POST https://your-api.com/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"password123"}'
```

## Notes

- All authenticated requests automatically include `Authorization: Bearer <token>` header
- Tokens are stored in local storage and loaded on app start
- Call `_apiService.setAuthToken(token)` after successful login
- Call `_apiService.clearAuthToken()` on logout
