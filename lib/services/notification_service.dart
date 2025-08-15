import 'dart:async';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

import './supabase_service.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  late SupabaseService _supabaseService;
  bool _isInitialized = false;
  StreamSubscription? _messageSubscription;

  // Initialize notification service
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      _supabaseService = SupabaseService();

      // Initialize Firebase (conditionally for mobile)
      if (!kIsWeb) {
        await _initializeFirebase();
      }

      // Initialize local notifications
      await _initializeLocalNotifications();

      // Setup notification handlers
      await _setupNotificationHandlers();

      // Request permissions
      await _requestPermissions();

      _isInitialized = true;
      debugPrint('✅ Notification service initialized');
    } catch (e) {
      debugPrint('❌ Notification service initialization failed: $e');
    }
  }

  // Initialize Firebase
  Future<void> _initializeFirebase() async {
    try {
      await Firebase.initializeApp();
      debugPrint('✅ Firebase initialized');
    } catch (e) {
      debugPrint('❌ Firebase initialization failed: $e');
    }
  }

  // Initialize local notifications
  Future<void> _initializeLocalNotifications() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );
  }

  // Setup notification message handlers
  Future<void> _setupNotificationHandlers() async {
    if (kIsWeb) return;

    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Handle notification taps when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

    // Handle initial message if app was launched from notification
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _handleNotificationTap(initialMessage);
    }
  }

  // Request notification permissions
  Future<bool> _requestPermissions() async {
    try {
      if (kIsWeb) return true;

      // Request Firebase messaging permission
      final messaging = FirebaseMessaging.instance;
      final settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      // Request Android notification permission
      if (Theme.of(NavigationService.navigatorKey.currentContext!).platform ==
          TargetPlatform.android) {
        await Permission.notification.request();
      }

      final granted =
          settings.authorizationStatus == AuthorizationStatus.authorized;
      debugPrint('✅ Notification permissions: $granted');
      return granted;
    } catch (e) {
      debugPrint('❌ Request permissions failed: $e');
      return false;
    }
  }

  // Get FCM token for push notifications
  Future<String?> getFCMToken() async {
    try {
      if (kIsWeb) return null;

      final token = await FirebaseMessaging.instance.getToken();
      debugPrint('✅ FCM Token: $token');
      return token;
    } catch (e) {
      debugPrint('❌ Get FCM token failed: $e');
      return null;
    }
  }

  // Save FCM token to user profile
  Future<void> saveFCMToken() async {
    try {
      final token = await getFCMToken();
      if (token == null) return;

      final client = SupabaseService.client;
      final user = client.auth.currentUser;
      if (user == null) return;

      await client
          .from('user_profiles')
          .update({'fcm_token': token}).eq('id', user.id);

      debugPrint('✅ FCM token saved to profile');
    } catch (e) {
      debugPrint('❌ Save FCM token failed: $e');
    }
  }

  // Show local notification
  Future<void> showLocalNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    try {
      const androidDetails = AndroidNotificationDetails(
        'homesnap_pro_channel',
        'HomeSnap Pro Notifications',
        channelDescription: 'Notifications for HomeSnap Pro app',
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _localNotifications.show(
        id,
        title,
        body,
        details,
        payload: payload,
      );
    } catch (e) {
      debugPrint('❌ Show local notification failed: $e');
    }
  }

  // Create notification in Supabase
  Future<void> createNotification({
    required String userId,
    required String type,
    required String title,
    required String message,
    Map<String, dynamic>? data,
    bool isAdminNotification = false,
  }) async {
    try {
      final client = SupabaseService.client;

      await client.from('notifications').insert({
        'user_id': userId,
        'type': type,
        'title': title,
        'message': message,
        'data': data,
        'is_admin_notification': isAdminNotification,
        'created_at': DateTime.now().toIso8601String(),
      });

      debugPrint('✅ Notification created in database');
    } catch (e) {
      debugPrint('❌ Create notification failed: $e');
    }
  }

  // Send job status notification
  Future<void> sendJobStatusNotification({
    required String jobId,
    required String status,
    required String userId,
  }) async {
    String title = 'Job Status Update';
    String message = 'Your job status has been updated to $status';

    switch (status) {
      case 'processing':
        title = 'Photos Being Processed';
        message =
            'Your photos are being professionally processed. You will receive them within 16 hours.';
        break;
      case 'completed':
        title = 'Photos Ready!';
        message = 'Your professionally edited photos are ready for download.';
        break;
      case 'delivered':
        title = 'Photos Delivered';
        message =
            'Your photos have been successfully delivered to your account.';
        break;
    }

    // Create notification in database
    await createNotification(
      userId: userId,
      type: 'job_status',
      title: title,
      message: message,
      data: {'job_id': jobId, 'status': status},
    );

    // Show local notification
    await showLocalNotification(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: title,
      body: message,
      payload: jsonEncode({'job_id': jobId, 'type': 'job_status'}),
    );
  }

  // Send payment notification
  Future<void> sendPaymentNotification({
    required String userId,
    required String status,
    required double amount,
  }) async {
    String title =
        status == 'completed' ? 'Payment Successful' : 'Payment Failed';
    String message = status == 'completed'
        ? 'Your payment of \$${amount.toStringAsFixed(2)} has been processed successfully.'
        : 'Your payment of \$${amount.toStringAsFixed(2)} could not be processed. Please try again.';

    await createNotification(
      userId: userId,
      type: 'payment_${status}',
      title: title,
      message: message,
      data: {'amount': amount, 'status': status},
    );

    await showLocalNotification(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: title,
      body: message,
      payload: jsonEncode({'type': 'payment', 'status': status}),
    );
  }

  // Get notifications for user
  Future<List<Map<String, dynamic>>> getUserNotifications() async {
    try {
      final client = SupabaseService.client;
      final user = client.auth.currentUser;
      if (user == null) return [];

      final response = await client
          .from('notifications')
          .select()
          .eq('user_id', user.id)
          .order('created_at', ascending: false)
          .limit(50);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('❌ Get user notifications failed: $e');
      return [];
    }
  }

  // Mark notification as read
  Future<void> markAsRead(String notificationId) async {
    try {
      final client = SupabaseService.client;
      await client.from('notifications').update({
        'is_read': true,
        'read_at': DateTime.now().toIso8601String(),
      }).eq('id', notificationId);
    } catch (e) {
      debugPrint('❌ Mark notification as read failed: $e');
    }
  }

  // Handle foreground message
  void _handleForegroundMessage(RemoteMessage message) {
    debugPrint('📱 Received foreground message: ${message.messageId}');

    showLocalNotification(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: message.notification?.title ?? 'HomeSnap Pro',
      body: message.notification?.body ?? 'New notification',
      payload: jsonEncode(message.data),
    );
  }

  // Handle notification tap
  void _handleNotificationTap(RemoteMessage message) {
    debugPrint('📱 Notification tapped: ${message.messageId}');

    final data = message.data;
    if (data.containsKey('job_id')) {
      // Navigate to job details
      NavigationService.navigateTo('/job-tracking-notifications',
          arguments: {'job_id': data['job_id']});
    }
  }

  // Handle local notification tap
  void _onNotificationTapped(NotificationResponse response) {
    debugPrint('📱 Local notification tapped: ${response.payload}');

    if (response.payload != null) {
      try {
        final data = jsonDecode(response.payload!);
        if (data['type'] == 'job_status') {
          NavigationService.navigateTo('/job-tracking-notifications',
              arguments: {'job_id': data['job_id']});
        }
      } catch (e) {
        debugPrint('❌ Parse notification payload failed: $e');
      }
    }
  }

  bool get isReady => _isInitialized;
}

// Background message handler
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint('📱 Background message: ${message.messageId}');
}

// Navigation service for routing
class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static void navigateTo(String route, {Object? arguments}) {
    navigatorKey.currentState?.pushNamed(route, arguments: arguments);
  }
}
