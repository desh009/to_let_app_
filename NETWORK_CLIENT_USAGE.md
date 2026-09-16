# 🌐 Network Client Usage Guide

This guide shows how to use the NetworkClient pattern in your To-Let app.

## 📁 File Structure

```
lib/
├── core/
│   ├── network/
│   │   ├── network_client.dart       // HTTP client with logger
│   │   └── network_response.dart     // Response model
│   ├── services/
│   │   └── network_service.dart      // GetX service wrapper
│   └── config/
│       └── app_config.dart           // URL configuration
├── data/
│   └── repositories/
│       └── auth_repository_v2.dart   // API calls
```

## 🎯 How to Use in Controller

### Example 1: Login API Call

```dart
import 'package:get/get.dart';
import '../../data/repositories/auth_repository_v2.dart';
import '../../core/services/network_service.dart';

class AuthController extends GetxController {
  final AuthRepositoryV2 _authRepo = AuthRepositoryV2();
  final NetworkService _networkService = Get.find<NetworkService>();
  
  final RxBool isLoggingIn = false.obs;

  Future<void> login(String email, String password) async {
    try {
      isLoggingIn.value = true;
      
      // Call API
      final NetworkResponse response = await _authRepo.login(
        email: email,
        password: password,
      );
      
      // Check if successful
      if (response.isSuccess) {
        // Extract data from response
        final data = response.responseData?['data'];
        final token = data['token'];
        final user = data['user'];
        
        // Save token
        _networkService.setAuthToken(token);
        
        // Navigate to home
        Get.offAllNamed(Routes.HOME);
        
        Get.snackbar('Success', 'Login successful!');
      } else {
        // Show error message
        Get.snackbar('Error', response.errorMessage ?? 'Login failed');
      }
      
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
    
    final NetworkResponse response = await _authRepo.register(
      fullName: fullName,
      email: email,
      phone: phone,
      password: password,
    );
    
    if (response.isSuccess) {
      // Navigate to OTP screen
      Get.toNamed(Routes.REGISTRATION_OTP);
      Get.snackbar('Success', 'OTP sent to your email');
    } else {
      Get.snackbar('Error', response.errorMessage ?? 'Registration failed');
    }
    
  } catch (e) {
    Get.snackbar('Error', 'An unexpected error occurred');
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
    
    final NetworkResponse response = await _authRepo.forgotPassword(
      email: email,
    );
    
    if (response.isSuccess) {
      Get.toNamed(Routes.FORGOT_PASSWORD_OTP);
      Get.snackbar('Success', 'OTP sent to your email');
    } else {
      if (response.statusCode == 404) {
        Get.snackbar('Error', 'Email not found');
      } else {
        Get.snackbar('Error', response.errorMessage ?? 'Failed to send OTP');
      }
    }
    
  } catch (e) {
    Get.snackbar('Error', 'An unexpected error occurred');
  } finally {
    isSendingOtp.value = false;
  }
}
```

## 📦 NetworkResponse Object

```dart
class NetworkResponse {
  final int statusCode;           // HTTP status code (200, 401, 404, etc.)
  final bool isSuccess;            // true if statusCode is 200 or 201
  final Map<String, dynamic>? responseData;  // Response body as JSON
  final String? errorMessage;      // Error message if failed
}
```

### Checking Response

```dart
final response = await _authRepo.login(email: email, password: password);

// Check if successful
if (response.isSuccess) {
  print('Success: ${response.responseData}');
} else {
  print('Error: ${response.errorMessage}');
  print('Status Code: ${response.statusCode}');
}
```

## 🎨 Response Handling Patterns

### Pattern 1: Simple Success/Error

```dart
final response = await _authRepo.login(email: email, password: password);

if (response.isSuccess) {
  // Handle success
  final token = response.responseData?['data']['token'];
  _networkService.setAuthToken(token);
  Get.offAllNamed(Routes.HOME);
} else {
  // Handle error
  Get.snackbar('Error', response.errorMessage ?? 'Something went wrong');
}
```

### Pattern 2: Status Code Based

```dart
final response = await _authRepo.login(email: email, password: password);

switch (response.statusCode) {
  case 200:
  case 201:
    // Success
    Get.snackbar('Success', 'Login successful');
    break;
  case 401:
    // Unauthorized - will auto redirect to login
    Get.snackbar('Error', 'Invalid credentials');
    break;
  case 404:
    Get.snackbar('Error', 'User not found');
    break;
  case 422:
    Get.snackbar('Error', 'Validation error');
    break;
  case -1:
    Get.snackbar('Error', 'Network error - Check your internet');
    break;
  default:
    Get.snackbar('Error', response.errorMessage ?? 'Something went wrong');
}
```

### Pattern 3: Try-Catch with Specific Handling

```dart
try {
  final response = await _authRepo.login(email: email, password: password);
  
  if (response.isSuccess) {
    // Success handling
    final data = response.responseData?['data'];
    print('User: ${data['user']}');
  } else {
    // Error handling
    _handleError(response);
  }
} catch (e) {
  Get.snackbar('Error', 'Unexpected error: $e');
}

void _handleError(NetworkResponse response) {
  if (response.statusCode == 401) {
    Get.snackbar('Error', 'Invalid credentials');
  } else if (response.statusCode == -1) {
    Get.snackbar('Error', 'No internet connection');
  } else {
    Get.snackbar('Error', response.errorMessage ?? 'Failed');
  }
}
```

## 🔑 Token Management

### Set Token After Login

```dart
if (response.isSuccess) {
  final token = response.responseData?['data']['token'];
  _networkService.setAuthToken(token);
}
```

### Get Current Token

```dart
final token = _networkService.getAuthToken();
print('Current token: $token');
```

### Clear Token on Logout

```dart
await _authRepo.logout();
// Token is automatically cleared in logout method
```

## 📊 Logger Output

The NetworkClient automatically logs all requests and responses:

```
INFO: 
    URL-> http://192.168.0.100:8000/api/v1/auth/login
    HEADERS-> {Content-Type: application/json, Accept: application/json}
    BODY-> {email: test@example.com, password: ******}

INFO:
    URL-> http://192.168.0.100:8000/api/v1/auth/login
    STATUS-CODE-> 200
    HEADERS-> {content-type: application/json}
    BODY-> {"success":true,"data":{"token":"...",
```

## 🔄 Auto Unauthorized Handling

When API returns 401 (Unauthorized):

1. ✅ Automatically clears auth token
2. ✅ Shows "Session Expired" message
3. ✅ Redirects to login screen
4. ✅ Returns NetworkResponse with error

```dart
// You don't need to handle 401 manually
// NetworkService handles it automatically

final response = await _authRepo.getProfile();

if (response.statusCode == 401) {
  // This will already be handled automatically
  // User will be redirected to login
}
```

## 🌐 Expected Backend Response Format

### Success Response

```json
{
  "success": true,
  "msg": "Login successful",
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

### Error Response

```json
{
  "success": false,
  "msg": "Invalid credentials"
}
```

## 🔧 Creating New Repository

```dart
import 'package:get/get.dart';
import '../../core/network/network_response.dart';
import '../../core/services/network_service.dart';

class PropertyRepository {
  final NetworkService _networkService = Get.find<NetworkService>();

  // GET all properties
  Future<NetworkResponse> getProperties({int page = 1, int limit = 20}) async {
    return await _networkService.get('/properties?page=$page&limit=$limit');
  }

  // GET property details
  Future<NetworkResponse> getPropertyDetails(String id) async {
    return await _networkService.get('/properties/$id');
  }

  // POST create property
  Future<NetworkResponse> createProperty(Map<String, dynamic> data) async {
    return await _networkService.post('/properties/create', body: data);
  }

  // PUT update property
  Future<NetworkResponse> updateProperty(String id, Map<String, dynamic> data) async {
    return await _networkService.put('/properties/update/$id', body: data);
  }

  // DELETE property
  Future<NetworkResponse> deleteProperty(String id) async {
    return await _networkService.delete('/properties/delete/$id');
  }
}
```

## 🧪 Testing

```dart
// Test API connection
final response = await Get.find<NetworkService>().get('/health');

if (response.isSuccess) {
  print('✅ API is working!');
  print('Response: ${response.responseData}');
} else {
  print('❌ API error: ${response.errorMessage}');
}
```

## 📝 Notes

- ✅ All requests automatically include auth token if available
- ✅ Unauthorized (401) is handled automatically
- ✅ All requests/responses are logged via Logger
- ✅ Status codes -1 means network/exception error
- ✅ Token is saved in local storage
- ✅ Headers are automatically added

## 🆚 Old vs New Pattern

### Old Pattern (ApiService)
```dart
try {
  final response = await _apiService.get('/endpoint');
} on UnauthorizedException catch (e) {
  // Handle 401
} on NetworkException catch (e) {
  // Handle network error
}
```

### New Pattern (NetworkService)
```dart
final response = await _networkService.get('/endpoint');

if (response.isSuccess) {
  // Success
} else {
  // Check response.statusCode for specific errors
  // 401 is auto-handled
}
```

---

**Both patterns are available. Use NetworkService for the pattern you showed!** 🚀
