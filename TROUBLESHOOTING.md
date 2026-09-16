# 🔧 Troubleshooting Guide

## ❌ Error: "Connection refused - error: 111"

### Problem:
Cannot connect to backend API from Android Emulator.

### Solution:

#### ✅ Step 1: Use Correct URL for Android Emulator

Android Emulator **cannot** use `localhost`. Use `10.0.2.2` instead.

**Open:** `lib/core/config/app_config.dart`

**Change:**
```dart
// ❌ Wrong for Android Emulator
static const String localBaseUrl = 'http://localhost:3000/api';

// ✅ Correct for Android Emulator
static const String localBaseUrl = 'http://10.0.2.2:3000/api';
```

#### ✅ Step 2: Set Environment to Local

**In:** `lib/core/config/app_config.dart`

```dart
static const Environment currentEnvironment = Environment.local;
```

#### ✅ Step 3: Ensure Backend is Running

Make sure your Node.js backend is running on port 3000:

```bash
# In your backend directory
npm start
# or
node server.js
```

Verify it's working:
```bash
curl http://localhost:3000/api/auth/register/send-otp
```

#### ✅ Step 4: Hot Restart the App

**Important:** Hot reload won't work! You must hot restart:

```
Press R in terminal (if running via terminal)
OR
Stop app and run again
```

---

## 🌐 Different Device Configurations

### For Android Emulator:
```dart
static const String localBaseUrl = 'http://10.0.2.2:3000/api';
```

### For iOS Simulator:
```dart
static const String localBaseUrl = 'http://localhost:3000/api';
```

### For Real Android/iOS Device (Same WiFi):
```dart
// Replace with your computer's local IP
static const String developmentBaseUrl = 'http://192.168.0.XXX:3000/api';
```

**Find your local IP:**

**Windows:**
```bash
ipconfig
# Look for IPv4 Address
```

**Mac/Linux:**
```bash
ifconfig | grep "inet "
```

---

## 🔒 HTTP vs HTTPS

### Development (HTTP is OK):

HTTP cleartext traffic is already enabled in `AndroidManifest.xml`:
```xml
<application
    android:usesCleartextTraffic="true">
```

### Production (Use HTTPS):

Always use HTTPS in production:
```dart
static const String productionBaseUrl = 'https://api.tolet.com/api';
```

And remove `android:usesCleartextTraffic="true"` from AndroidManifest.xml

---

## 🧪 Testing Checklist

- [ ] Backend is running on correct port (3000)
- [ ] Using correct URL (`10.0.2.2` for Android Emulator)
- [ ] Environment is set to `Environment.local`
- [ ] App is hot restarted (not just hot reload)
- [ ] Check console logs for actual URL being called

---

## 📊 Debug Information

When app starts in development mode, you'll see:

```
╔════════════════════════════════════════╗
║      APP CONFIGURATION                 ║
╠════════════════════════════════════════╣
║ Environment: 💻 Local                  ║
║ Base URL: http://10.0.2.2:3000/api    ║
║ API Version: v1                        ║
║ App Version: 1.0.0                     ║
╚════════════════════════════════════════╝
```

Check if Base URL is correct!

---

## 🔍 Verify API Call

In logger output, check the actual URL:

```
INFO: 
    URL-> http://10.0.2.2:3000/api/auth/register/send-otp
    HEADERS-> {Content-Type: application/json, ...}
    BODY-> {email: test@gmail.com, ...}
```

If you see `http://localhost:...` instead of `http://10.0.2.2:...`, hot restart the app!

---

## 🚨 Common Mistakes

### ❌ Using localhost in Android Emulator
```dart
'http://localhost:3000/api'  // Won't work!
```

### ❌ Forgetting to Hot Restart
Hot reload won't pick up config changes. Must hot restart!

### ❌ Backend Not Running
Make sure backend is actually running on port 3000.

### ❌ Wrong Port Number
Check if your backend is running on port 3000, not 8000 or other port.

---

## ✅ Quick Fix Commands

```bash
# 1. Stop the app
# 2. Update URL in app_config.dart to: http://10.0.2.2:3000/api
# 3. Set environment to: Environment.local
# 4. Run app again
flutter run

# 5. Check backend is running
curl http://localhost:3000/api/health
```

---

## 🆘 Still Not Working?

1. **Check backend logs** - Is it receiving requests?
2. **Check Postman** - Can you call API from Postman?
3. **Check firewall** - Is port 3000 blocked?
4. **Try ngrok** - If all else fails:
   ```bash
   ngrok http 3000
   # Use ngrok URL in app_config.dart
   ```

---

## 📱 Platform-Specific Notes

### Android:
- Emulator: Use `10.0.2.2`
- Real device: Use computer's IP address
- Must have `usesCleartextTraffic="true"` for HTTP

### iOS:
- Simulator: Can use `localhost`
- Real device: Use computer's IP address
- Must configure `Info.plist` for HTTP (already done)

---

**Need more help?** Check backend logs and network inspector!
