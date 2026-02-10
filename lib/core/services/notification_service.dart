// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter/material.dart';

// import 'package:alnas_app/core/utils/app_router.dart';

// // Background message handler must be a top-level function
// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   debugPrint('Handling a background message: ${message.messageId}');
// }

// class NotificationService {
//   // Singleton instance
//   static final NotificationService _instance = NotificationService._internal();

//   factory NotificationService() {
//     return _instance;
//   }

//   NotificationService._internal();

//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
//   final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   Future<void> init() async {
//     // Request permission
//     await requestPermission();

//     // Initialize Local Notifications
//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('@mipmap/ic_launcher');

//     final DarwinInitializationSettings initializationSettingsDarwin =
//         DarwinInitializationSettings(
//           requestAlertPermission: false,
//           requestBadgePermission: false,
//           requestSoundPermission: false,
//         );

//     final InitializationSettings initializationSettings =
//         InitializationSettings(
//           android: initializationSettingsAndroid,
//           iOS: initializationSettingsDarwin,
//         );

//     await _flutterLocalNotificationsPlugin.initialize(
//       onDidReceiveNotificationResponse: (NotificationResponse response) {
//         debugPrint('Notification tapped with payload: ${response.payload}');
//         // Handle notification tap logic here
//         AppRouter().router.push('/track-request');
//       },
//       settings: initializationSettings,
//     );

//     // Set background handler
//     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

//     // Foreground message handler
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       debugPrint('Got a message whilst in the foreground!');
//       debugPrint('Message data: ${message.data}');

//       if (message.notification != null) {
//         debugPrint(
//           'Message also contained a notification: ${message.notification}',
//         );
//         _showLocalNotification(message);
//       }
//     });

//     // Message opened app handler
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       debugPrint('A new onMessageOpenedApp event was published!');
//       // Handle navigation logic here
//       AppRouter().router.push('/track-request');
//     });

//     // Check if app was opened from terminated state
//     RemoteMessage? initialMessage = await FirebaseMessaging.instance
//         .getInitialMessage();

//     if (initialMessage != null) {
//       debugPrint('App opened from terminated state via notification');
//       AppRouter().router.push('/track-request');
//     }

//     // Validating token
//     try {
//       String? token = await _firebaseMessaging.getToken();
//       debugPrint('FCM Token: $token');
//     } catch (e) {
//       debugPrint('Error getting FCM token: $e');
//     }
//   }

//   Future<void> requestPermission() async {
//     NotificationSettings settings = await _firebaseMessaging.requestPermission(
//       alert: true,
//       announcement: false,
//       badge: true,
//       carPlay: false,
//       criticalAlert: false,
//       provisional: false,
//       sound: true,
//     );

//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       debugPrint('User granted permission');
//     } else if (settings.authorizationStatus ==
//         AuthorizationStatus.provisional) {
//       debugPrint('User granted provisional permission');
//     } else {
//       debugPrint('User declined or has not accepted permission');
//     }
//   }

//   Future<void> _showLocalNotification(RemoteMessage message) async {
//     RemoteNotification? notification = message.notification;
//     AndroidNotification? android = message.notification?.android;

//     if (notification != null && android != null) {
//       // Create a high importance channel for Android
//       const AndroidNotificationChannel channel = AndroidNotificationChannel(
//         'high_importance_channel', // id
//         'High Importance Notifications', // title
//         description:
//             'This channel is used for important notifications.', // description
//         importance: Importance.max,
//       );

//       await _flutterLocalNotificationsPlugin
//           .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin
//           >()
//           ?.createNotificationChannel(channel);

//       await _flutterLocalNotificationsPlugin.show(
//         id: notification.hashCode,
//         title: notification.title,
//         body: notification.body,
//         notificationDetails: NotificationDetails(
//           android: AndroidNotificationDetails(
//             channel.id,
//             channel.name,
//             channelDescription: channel.description,
//             icon: android.smallIcon,
//             // other properties...
//           ),
//         ),
//       );
//     }
//   }
// }
