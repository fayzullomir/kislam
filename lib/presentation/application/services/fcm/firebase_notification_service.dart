import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:koreaislam/core/log/logger/app_log.dart';

/// Unified notification service for FCM and local notifications
/// Handles initialization, token management, and system notification display
class FirebaseNotificationService {
  static final FirebaseNotificationService _instance = FirebaseNotificationService._internal();
  factory FirebaseNotificationService() => _instance;
  FirebaseNotificationService._internal();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
  FlutterLocalNotificationsPlugin();

  String? _fcmToken;
  String? get fcmToken => _fcmToken;

  bool _initialized = false;
  Function(RemoteMessage)? _onNotificationTapped;

  /// Initialize notification service
  /// Must be called before using any notification features
  Future<void> initialize({
    Function(RemoteMessage)? onNotificationTapped,
  }) async {
    if (_initialized) {
      AppLog.w('Notification service already initialized');
      return;
    }

    _onNotificationTapped = onNotificationTapped;

    try {
      // Step 1: Initialize local notifications
      await _initializeLocalNotifications();

      // Step 2: Request FCM permissions (iOS)
      // await _requestPermission();

      // Step 3: Get FCM token
      _fcmToken = await _getFCMToken();
      AppLog.i('✅ FCM Token: $_fcmToken');

      // Step 4: Configure foreground notification presentation
      await _configureForegroundNotification();

      // Step 5: Setup message handlers
      _setupMessageHandlers();

      // Step 6: Listen for token refresh
      _listenToTokenRefresh();

      _initialized = true;
      AppLog.i('✅ Notification service initialized successfully');
    } catch (e, s) {
      AppLog.e('❌ ERROR initializing notification service', error: e, stackTrace: s);
    }
  }

  /// Initialize Flutter Local Notifications plugin
  Future<void> _initializeLocalNotifications() async {
    try {
      // Android settings
      const AndroidInitializationSettings androidSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');

      // iOS settings
      const DarwinInitializationSettings iosSettings =
      DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      const InitializationSettings initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      await _localNotifications.initialize(
        initSettings,
        onDidReceiveNotificationResponse: _onLocalNotificationTapped,
      );

      // Create Android notification channel
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'fcm_default_channel',
        'FCM Notifications',
        description: 'This channel is used for Firebase notifications',
        importance: Importance.high,
        enableVibration: true,
        playSound: true,
      );

      await _localNotifications
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      AppLog.d('✅ Local notifications initialized');
    } catch (e, s) {
      AppLog.e('❌ ERROR initializing local notifications', error: e, stackTrace: s);
    }
  }

  /// Get FCM token
  Future<String?> _getFCMToken() async {
    try {
      String? token = await _fcm.getToken();
      return token;
    } catch (e, s) {
      AppLog.e('❌ ERROR getting FCM token', error: e, stackTrace: s);
      return null;
    }
  }

  /// Configure how notifications are presented when app is in foreground
  Future<void> _configureForegroundNotification() async {
    await _fcm.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  /// Setup message handlers for different app states
  void _setupMessageHandlers() {
    // Handle foreground messages - show as system notification
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      AppLog.d('📬 Foreground notification received: ${message.messageId}');
      AppLog.d('Title: ${message.notification?.title}');
      AppLog.d('Body: ${message.notification?.body}');
      AppLog.d('Data: ${message.data}');

      // Always show system notification even in foreground
      _showSystemNotification(message);
    });

    // Handle notification tap when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      AppLog.d('🔔 Background notification tapped: ${message.messageId}');
      _handleNotificationTap(message);
    });

    // Handle notification tap when app was terminated
    _handleTerminatedStateTap();
  }

  /// Show system notification using flutter_local_notifications
  /// Works for all app states: foreground, background, and terminated
  Future<void> _showSystemNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) {
      AppLog.w('⚠️ No notification payload, skipping display');
      return;
    }

    try {
      const AndroidNotificationDetails androidDetails =
      AndroidNotificationDetails(
        'fcm_default_channel',
        'FCM Notifications',
        channelDescription: 'This channel is used for Firebase notifications',
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
        enableVibration: true,
        playSound: true,
      );

      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const NotificationDetails platformDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _localNotifications.show(
        message.hashCode,
        notification.title,
        notification.body,
        platformDetails,
        payload: _encodePayload(message.data),
      );

      AppLog.d('✅ System notification displayed');
    } catch (e, s) {
      AppLog.e('❌ ERROR showing notification', error: e, stackTrace: s);
    }
  }

  /// Handle notification tap when app was terminated
  Future<void> _handleTerminatedStateTap() async {
    try {
      RemoteMessage? initialMessage = await _fcm.getInitialMessage();

      if (initialMessage != null) {
        AppLog.d('📱 App opened from terminated state: ${initialMessage.messageId}');
        _handleNotificationTap(initialMessage);
      }
    } catch (e, s) {
      AppLog.e('❌ ERROR getting initial message', error: e, stackTrace: s);
    }
  }

  /// Handle local notification tap
  void _onLocalNotificationTapped(NotificationResponse response) {
    AppLog.d('🔔 Local notification tapped: ${response.payload}');

    if (response.payload != null) {
      final data = _decodePayload(response.payload!);
      final message = RemoteMessage(
        data: data,
        messageId: DateTime.now().millisecondsSinceEpoch.toString(),
      );
      _handleNotificationTap(message);
    }
  }

  /// Handle notification tap - delegates to callback
  void _handleNotificationTap(RemoteMessage message) {
    if (_onNotificationTapped != null) {
      _onNotificationTapped!(message);
    } else {
      AppLog.w('⚠️ No notification tap handler set');
    }
  }

  /// Listen to FCM token refresh
  void _listenToTokenRefresh() {
    _fcm.onTokenRefresh.listen((newToken) {
      _fcmToken = newToken;
      AppLog.d('🔄 FCM Token refreshed: $newToken');

      // Send the new token to your backend
      _sendTokenToBackend(newToken);
    });
  }

  /// Send token to backend (implement your API call here)
  Future<void> _sendTokenToBackend(String token) async {
    try {
      AppLog.d('📤 Sending FCM token to backend: $token');
      // TODO: Implement your API call
      // await yourApiService.updateFCMToken(token);
    } catch (e, s) {
      AppLog.e('❌ ERROR sending token to backend', error: e, stackTrace: s);
    }
  }

  /// Encode notification data as payload string
  String _encodePayload(Map<String, dynamic> data) {
    if (data.isEmpty) return '';

    try {
      return data.entries.map((e) => '${e.key}:${e.value}').join(',');
    } catch (e) {
      AppLog.e('❌ ERROR encoding payload: $e');
      return '';
    }
  }

  /// Decode payload string back to map
  Map<String, dynamic> _decodePayload(String payload) {
    if (payload.isEmpty) return {};

    try {
      final Map<String, dynamic> data = {};
      final pairs = payload.split(',');

      for (final pair in pairs) {
        final parts = pair.split(':');
        if (parts.length == 2) {
          data[parts[0]] = parts[1];
        }
      }

      return data;
    } catch (e) {
      AppLog.e('❌ ERROR decoding payload: $e');
      return {};
    }
  }

  /// Subscribe to a topic
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _fcm.subscribeToTopic(topic);
      AppLog.i('✅ Subscribed to topic: $topic');
    } catch (e, s) {
      AppLog.e('❌ ERROR subscribing to topic', error: e, stackTrace: s);
    }
  }

  /// Unsubscribe from a topic
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _fcm.unsubscribeFromTopic(topic);
      AppLog.i('✅ Unsubscribed from topic: $topic');
    } catch (e, s) {
      AppLog.e('❌ ERROR unsubscribing from topic', error: e, stackTrace: s);
    }
  }

  /// Delete FCM token
  Future<void> deleteToken() async {
    try {
      await _fcm.deleteToken();
      _fcmToken = null;
      AppLog.i('✅ FCM token deleted');
    } catch (e, s) {
      AppLog.e('❌ ERROR deleting FCM token', error: e, stackTrace: s);
    }
  }

  /// Get current notification settings
  Future<NotificationSettings> getNotificationSettings() async {
    return await _fcm.getNotificationSettings();
  }

  /// Refresh FCM token manually
  Future<String?> refreshToken() async {
    try {
      await _fcm.deleteToken();
      _fcmToken = await _fcm.getToken();
      AppLog.i('✅ FCM token refreshed manually: $_fcmToken');
      return _fcmToken;
    } catch (e, s) {
      AppLog.e('❌ ERROR refreshing token', error: e, stackTrace: s);
      return null;
    }
  }
}