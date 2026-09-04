import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

/// Top-level background message handler required by Firebase Messaging
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  log('Handling background message: ${message.messageId}');
}

class FcmService extends GetxService {
  static FcmService get to => Get.find();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  final RxnString fcmToken = RxnString();

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.max,
  );

  /// Initializes FCM permissions, local notification plugin, token fetching, and listeners
  Future<FcmService> init() async {
    await _requestPermission();
    await _initLocalNotifications();
    await _getToken();
    _setupMessageHandlers();
    return this;
  }

  /// Request notification permissions for iOS / Android 13+
  Future<void> _requestPermission() async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    log('User FCM permission status: ${settings.authorizationStatus}');

    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  /// Initialize Local Notifications plugin for Android & iOS
  Future<void> _initLocalNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    // Create channel on Android
    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);

    await _localNotifications.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        log('Local Notification Tapped with payload: ${response.payload}');
        _handleNotificationPayload(response.payload);
      },
    );
  }

  /// Get device FCM token and listen for refreshes
  Future<void> _getToken() async {
    try {
      String? token = await _messaging.getToken();
      if (token != null) {
        fcmToken.value = token;
        log('FCM Token: $token');
      }
    } catch (e) {
      log('Error getting FCM Token: $e');
    }

    _messaging.onTokenRefresh.listen((newToken) {
      fcmToken.value = newToken;
      log('FCM Token Refreshed: $newToken');
    });
  }

  /// Setup foreground, background open, and app launched message listeners
  void _setupMessageHandlers() {
    // 1. Foreground message handler
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log('Received foreground message: ${message.notification?.title}');
      _showLocalNotification(message);
    });

    // 2. Message opened app (from background state)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log('Notification opened app from background state: ${message.data}');
      _handleMessageData(message.data);
    });

    // 3. Check if app was launched from a terminated notification click
    _messaging.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        log('Notification opened app from terminated state: ${message.data}');
        _handleMessageData(message.data);
      }
    });
  }

  /// Displays local notification when message received in foreground
  void _showLocalNotification(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null) {
      _localNotifications.show(
        id: notification.hashCode,
        title: notification.title,
        body: notification.body,
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            _channel.id,
            _channel.name,
            channelDescription: _channel.description,
            icon: android?.smallIcon ?? '@mipmap/ic_launcher',
            importance: Importance.max,
            priority: Priority.high,
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: message.data.isNotEmpty ? message.data.toString() : null,
      );
    }
  }

  void _handleNotificationPayload(String? payload) {
    if (payload != null && payload.isNotEmpty) {
      // Custom notification payload handling logic
    }
  }

  void _handleMessageData(Map<String, dynamic> data) {
    // Custom navigation or deep linking logic when notification is tapped
  }

  /// Subscribe to a topic for broadcast notifications
  Future<void> subscribeToTopic(String topic) async {
    await _messaging.subscribeToTopic(topic);
    log('Subscribed to FCM topic: $topic');
  }

  /// Unsubscribe from a topic
  Future<void> unsubscribeFromTopic(String topic) async {
    await _messaging.unsubscribeFromTopic(topic);
    log('Unsubscribed from FCM topic: $topic');
  }
}
