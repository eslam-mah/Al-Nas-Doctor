import 'dart:convert';
import 'dart:io';

import 'package:alnas_doctor/core/utils/pref_keys.dart';
import 'package:alnas_doctor/core/utils/shared_preferences_service.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Top-level function to handle background messages.
/// Must be a top-level function (not a class method).
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  if (kDebugMode) {
    debugPrint('FCM Background: ${message.messageId}');
    debugPrint('FCM Background Data: ${message.data}');
  }
}

/// Centralized notification service that handles:
/// - Firebase Cloud Messaging (FCM) initialization
/// - Permission requests
/// - Foreground / background / terminated message handling
/// - Local notification display
/// - FCM token retrieval & refresh
/// - Device ID retrieval
class NotificationService {
  NotificationService._();
  static final NotificationService _instance = NotificationService._();
  factory NotificationService() => _instance;

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  /// Android notification channel for high-importance notifications
  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'alnas_doctor_channel',
    'Al Nas Doctor Notifications',
    description: 'Notifications for Al Nas Doctor app',
    importance: Importance.max,
    playSound: true,
    enableVibration: true,
  );

  String? _fcmToken;
  String? _deviceId;

  /// The current FCM token
  String? get fcmToken => _fcmToken;

  /// The current device ID
  String? get deviceId => _deviceId;

  // ════════════════════════════════════════════════════
  // INITIALIZATION
  // ════════════════════════════════════════════════════

  /// Initialize the notification service.
  /// Call this once after `Firebase.initializeApp()` in main.
  Future<void> init() async {
    // 1. Register the background message handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // 2. Request permissions
    await _requestPermissions();

    // 3. Set up local notifications
    await _initLocalNotifications();

    // 4. Create the Android notification channel
    await _createNotificationChannel();

    // 5. Get the FCM token
    await _getFcmToken();

    // 6. Get the device ID
    await _getDeviceId();

    // 7. Set up foreground message listener
    _setupForegroundListener();

    // 8. Set up token refresh listener
    _setupTokenRefreshListener();

    // 9. Handle notification taps (when app was terminated or in background)
    await _handleInitialMessage();
    _setupMessageOpenedAppListener();

    // 10. Set foreground notification presentation options (iOS)
    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    if (kDebugMode) {
      debugPrint('NotificationService: Initialized successfully');
      debugPrint('NotificationService: FCM Token = $_fcmToken');
      debugPrint('NotificationService: Device ID = $_deviceId');
    }
  }

  // ════════════════════════════════════════════════════
  // PERMISSIONS
  // ════════════════════════════════════════════════════

  /// Request notification permissions from the user.
  Future<void> _requestPermissions() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (kDebugMode) {
      debugPrint(
        'NotificationService: Permission status = ${settings.authorizationStatus}',
      );
    }
  }

  // ════════════════════════════════════════════════════
  // LOCAL NOTIFICATIONS
  // ════════════════════════════════════════════════════

  Future<void> _initLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );
  }

  Future<void> _createNotificationChannel() async {
    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_channel);
  }

  /// Callback when a local notification is tapped
  void _onNotificationTapped(NotificationResponse response) {
    if (kDebugMode) {
      debugPrint(
        'NotificationService: Notification tapped: ${response.payload}',
      );
    }

    if (response.payload != null) {
      try {
        final data = jsonDecode(response.payload!);
        _handleNotificationNavigation(data);
      } catch (e) {
        if (kDebugMode) {
          debugPrint(
            'NotificationService: Error parsing notification payload: $e',
          );
        }
      }
    }
  }

  // ════════════════════════════════════════════════════
  // FCM TOKEN
  // ════════════════════════════════════════════════════

  Future<void> _getFcmToken() async {
    try {
      _fcmToken = await _messaging.getToken();
      if (kDebugMode) {
        debugPrint('NotificationService: FCM Token = $_fcmToken');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('NotificationService: Error getting FCM token: $e');
      }
    }
  }

  void _setupTokenRefreshListener() {
    _messaging.onTokenRefresh.listen((newToken) {
      _fcmToken = newToken;
      if (kDebugMode) {
        debugPrint('NotificationService: FCM Token refreshed = $newToken');
      }
      // TODO: Re-register the new token with the backend
    });
  }

  // ════════════════════════════════════════════════════
  // DEVICE ID
  // ════════════════════════════════════════════════════

  Future<void> _getDeviceId() async {
    try {
      final deviceInfo = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        _deviceId = androidInfo.id;
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        _deviceId = iosInfo.identifierForVendor;
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('NotificationService: Error getting device ID: $e');
      }
      _deviceId = 'unknown';
    }
  }

  // ════════════════════════════════════════════════════
  // MESSAGE LISTENERS
  // ════════════════════════════════════════════════════

  /// Listen for messages when the app is in the foreground.
  void _setupForegroundListener() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (kDebugMode) {
        debugPrint('NotificationService: Foreground message received');
        debugPrint('  Title: ${message.notification?.title}');
        debugPrint('  Body: ${message.notification?.body}');
        debugPrint('  Data: ${message.data}');
      }

      // Show local notification for foreground messages
      _showLocalNotification(message);
    });
  }

  /// Handle taps on notifications that opened the app from background.
  void _setupMessageOpenedAppListener() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (kDebugMode) {
        debugPrint('NotificationService: App opened from notification');
        debugPrint('  Data: ${message.data}');
      }
      _handleNotificationNavigation(message.data);
    });
  }

  /// Handle the initial message if the app was opened from a terminated state.
  Future<void> _handleInitialMessage() async {
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      if (kDebugMode) {
        debugPrint('NotificationService: App opened from terminated state');
        debugPrint('  Data: ${initialMessage.data}');
      }
      // Delay slightly to let the app finish building
      Future.delayed(const Duration(seconds: 1), () {
        _handleNotificationNavigation(initialMessage.data);
      });
    }
  }

  // ════════════════════════════════════════════════════
  // SHOW LOCAL NOTIFICATION
  // ════════════════════════════════════════════════════

  /// Display a local notification from a Firebase message.
  Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    final androidDetails = AndroidNotificationDetails(
      _channel.id,
      _channel.name,
      channelDescription: _channel.description,
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
      icon: '@mipmap/ic_launcher',
      color: const Color(0xFF0077B6),
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      id: notification.hashCode,
      title: notification.title,
      body: notification.body,
      notificationDetails: details,
      payload: jsonEncode(message.data),
    );
  }

  // ════════════════════════════════════════════════════
  // NAVIGATION
  // ════════════════════════════════════════════════════

  /// Handle navigation based on notification data.
  /// Extend this to navigate to specific screens based on the notification type.
  void _handleNotificationNavigation(Map<String, dynamic> data) {
    if (kDebugMode) {
      debugPrint('NotificationService: Navigating with data: $data');
    }

    // Example: Navigate based on notification type
    // final type = data['type'];
    // switch (type) {
    //   case 'chat':
    //     final chatId = data['chat_id'];
    //     // Navigate to chat detail
    //     break;
    //   case 'appointment':
    //     // Navigate to appointment
    //     break;
    // }
  }

  // ════════════════════════════════════════════════════
  // PUBLIC HELPERS
  // ════════════════════════════════════════════════════

  /// Get the user ID from SharedPreferences (if logged in).
  Future<String> getUserId() async {
    final prefs = await SharedPreferencesService.getInstance();
    return prefs.getString(PrefKeys.kUserId) ?? '';
  }

  /// Subscribe to a topic for targeted notifications.
  Future<void> subscribeToTopic(String topic) async {
    await _messaging.subscribeToTopic(topic);
    if (kDebugMode) {
      debugPrint('NotificationService: Subscribed to topic: $topic');
    }
  }

  /// Unsubscribe from a topic.
  Future<void> unsubscribeFromTopic(String topic) async {
    await _messaging.unsubscribeFromTopic(topic);
    if (kDebugMode) {
      debugPrint('NotificationService: Unsubscribed from topic: $topic');
    }
  }
}
