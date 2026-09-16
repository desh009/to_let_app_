# 🔧 URL Configuration Guide

This guide explains how to configure API URLs for your To-Let app.

## 📁 Configuration File Location

```
lib/core/config/app_config.dart
```

## 🌍 Environment Setup

### Step 1: Choose Environment

Open `app_config.dart` and change the `currentEnvironment`:

```dart
static const Environment currentEnvironment = Environment.development;
```

Available environments:
- `Environment.development` - For development
- `Environment.staging` - For staging/testing
- `Environment.production` - For live production
- `Environment.local` - For local machine testing

### Step 2: Configure URLs

Update the URL for each environment:

```dart
// 🛠️ Development - Your dev server
static const String developmentBaseUrl = 'http://192.168.0.100:8000/api/v1';

// 🧪 Staging - Your staging server  
static const String stagingBaseUrl = 'https://staging-api.tolet.com/api/v1';

// 🚀 Production - Your live server
static const String productionBaseUrl = 'https://api.tolet.com/api/v1';

// 💻 Local - Testing on your computer
static const String localBaseUrl = 'http://localhost:8000/api/v1';
```

## 📱 Local Network Configuration

### For Android Emulator:

```dart
// Use 10.0.2.2 instead of localhost
static const String localBaseUrl = 'http://10.0.2.2:8000/api/v1';
```

### For Real Android Device (Same WiFi):

```dart
// Use your computer's local IP address
static const String developmentBaseUrl = 'http://192.168.0.100:8000/api/v1';
```

**How to find your local IP:**

**Windows:**
```bash
ipconfig
# Look for IPv4 Address under WiFi adapter
```

**Mac/Linux:**
```bash
ifconfig
# Look for inet address
```

### For iOS Simulator:

```dart
// Use localhost or your machine's IP
static const String localBaseUrl = 'http://localhost:8000/api/v1';
```

## 🔐 HTTPS Configuration

For production, always use HTTPS:

```dart
static const String productionBaseUrl = 'https://api.tolet.com/api/v1';
```

For development with self-signed certificate, you may need to allow cleartext traffic.

### Android - Allow HTTP (Development Only)

Add to `android/app/src/main/AndroidManifest.xml`:

```xml
<application
    android:usesCleartextTraffic="true"
    ...>
```

**⚠️ Warning:** Remove this in production!

### iOS - Allow HTTP (Development Only)

Add to `ios/Runner/Info.plist`:

```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```

**⚠️ Warning:** Remove this in production!

## 🎯 Quick Setup Examples

### Example 1: Using Laravel Backend (Local)

```dart
static const Environment currentEnvironment = Environment.local;
static const String localBaseUrl = 'http://10.0.2.2:8000/api/v1';
```

### Example 2: Using Node.js Backend (Local)

```dart
static const Environment currentEnvironment = Environment.local;
static const String localBaseUrl = 'http://192.168.0.105:3000/api/v1';
```

### Example 3: Production Ready

```dart
static const Environment currentEnvironment = Environment.production;
static const String productionBaseUrl = 'https://api.toletapp.com/api/v1';
```

### Example 4: Testing with ngrok

```dart
static const Environment currentEnvironment = Environment.development;
static const String developmentBaseUrl = 'https://abc123.ngrok.io/api/v1';
```

## 🧪 Testing Your Configuration

### Method 1: Check Console Output

When app starts in development mode, you'll see:

```
╔════════════════════════════════════════╗
║      APP CONFIGURATION                 ║
╠════════════════════════════════════════╣
║ Environment: Development               ║
║ Base URL: http://192.168.0.100:8000/... ║
║ API Version: v1                        ║
║ App Version: 1.0.0                     ║
╚════════════════════════════════════════╝
```

### Method 2: Test API Call

Create a test screen:

```dart
import 'package:get/get.dart';
import '../core/config/app_config.dart';

class TestScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('API Test')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Environment: ${AppConfig.currentEnvironment.displayName}'),
            SizedBox(height: 10),
            Text('Base URL: ${AppConfig.baseUrl}'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Test API call here
                try {
                  final response = await Get.find<ApiService>().get('/health');
                  Get.snackbar('Success', 'API is working!');
                } catch (e) {
                  Get.snackbar('Error', e.toString());
                }
              },
              child: Text('Test API Connection'),
            ),
          ],
        ),
      ),
    );
  }
}
```

## 🔄 Switching Between Environments

### During Development:

1. Open `app_config.dart`
2. Change `currentEnvironment`
3. Hot restart the app (not hot reload)

```dart
// For local testing
static const Environment currentEnvironment = Environment.local;

// For development server
static const Environment currentEnvironment = Environment.development;

// For production testing
static const Environment currentEnvironment = Environment.production;
```

## 📦 Build Configurations

### For different build flavors (Advanced):

You can create multiple app configurations:

```dart
// app_config_dev.dart
class AppConfig {
  static const environment = Environment.development;
  static const baseUrl = 'http://dev-api.tolet.com/api/v1';
}

// app_config_prod.dart
class AppConfig {
  static const environment = Environment.production;
  static const baseUrl = 'https://api.tolet.com/api/v1';
}
```

## 🐛 Troubleshooting

### Issue 1: "Unable to connect to API"

**Solution:**
- Check if backend server is running
- Verify IP address is correct
- Check firewall settings
- For Android emulator, use `10.0.2.2` instead of `localhost`

### Issue 2: "SSL Handshake Failed"

**Solution:**
- Use HTTP for development (add cleartext traffic permission)
- For production, ensure SSL certificate is valid

### Issue 3: "Network Error - SocketException"

**Solution:**
- Check internet/WiFi connection
- Verify backend server is accessible
- Check if port is correct (8000, 3000, etc.)

### Issue 4: "Connection Timeout"

**Solution:**
- Increase timeout in `app_config.dart`:
```dart
static const int connectionTimeout = 60000; // 60 seconds
```

## 📝 Best Practices

1. ✅ **Never commit production URLs** in public repositories
2. ✅ **Use environment variables** for sensitive data
3. ✅ **Always use HTTPS** in production
4. ✅ **Test API connection** before deploying
5. ✅ **Remove cleartext traffic** permission in production
6. ✅ **Use different ports** for different environments
7. ✅ **Document your API endpoints**

## 🚀 Deployment Checklist

Before deploying to production:

- [ ] Set `currentEnvironment = Environment.production`
- [ ] Update `productionBaseUrl` with live URL
- [ ] Remove `usesCleartextTraffic="true"` from Android
- [ ] Remove `NSAllowsArbitraryLoads` from iOS
- [ ] Test all API endpoints
- [ ] Enable SSL certificate
- [ ] Test on real devices
- [ ] Update API version if needed

## 💡 Tips

- Use **ngrok** to test local backend with real devices
- Use **Postman** to test API endpoints before integration
- Keep a **separate config file** for team members
- Use **.gitignore** to exclude local config files
- Create a **health check endpoint** (`/health`) on backend
- Log all API calls in development mode

## 🔗 Related Files

- `lib/core/config/app_config.dart` - Main configuration
- `lib/core/constants/api_constants.dart` - API endpoints
- `lib/core/services/api_service.dart` - API client
- `API_USAGE.md` - How to use API service

---

**Need help?** Check the backend API documentation or contact the backend team.
