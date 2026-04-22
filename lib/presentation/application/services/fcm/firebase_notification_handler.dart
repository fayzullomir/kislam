import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:koreaislam/core/log/logger/app_log.dart';

/// Handles navigation logic for notifications
/// Separates routing concerns from notification display
class FirebaseNotificationHandler {
  static final FirebaseNotificationHandler _instance =
      FirebaseNotificationHandler._internal();

  factory FirebaseNotificationHandler() => _instance;

  FirebaseNotificationHandler._internal();

  BuildContext? _context;

  /// Initialize with context for navigation
  void initialize(BuildContext context) {
    _context = context;
    AppLog.d('✅ Notification navigation handler initialized');
  }

  /// Update context when it changes (e.g., after navigation)
  void updateContext(BuildContext context) {
    _context = context;
  }

  /// Handle notification navigation based on message data
  void handleNotification(RemoteMessage message) {
    if (_context == null) {
      AppLog.w('⚠️ Navigation context is null, cannot navigate');
      return;
    }

    final data = message.data;

    if (data.isEmpty) {
      AppLog.w('⚠️ No data in notification, skipping navigation');
      return;
    }

    final type = data['type'] as String?;
    final id = data['id'] as String?;

    AppLog.d('📍 Navigation - type: $type, id: $id');

    if (type == null) {
      AppLog.w('⚠️ No type in notification data');
      return;
    }

    _navigateByType(type, id, data);
  }

  /// Navigate based on notification type
  void _navigateByType(String type, String? id, Map<String, dynamic> data) {
    switch (type) {
      case 'booking':
        _navigateToBooking(id);
        break;

      case 'tour':
        _navigateToTour(id);
        break;

      case 'message':
        _navigateToMessages(id);
        break;

      case 'chat':
        _navigateToChat(id);
        break;

      case 'notification':
        _navigateToNotifications();
        break;

      case 'profile':
        _navigateToProfile();
        break;

      case 'attendance':
        _navigateToAttendance(id);
        break;

      default:
        AppLog.w('⚠️ Unknown notification type: $type');
        _navigateToHome();
        break;
    }
  }

  /// Navigate to booking details
  void _navigateToBooking(String? id) {
    if (id == null) {
      AppLog.w('⚠️ Booking ID is null');
      return;
    }

    AppLog.d('📍 Navigating to booking: $id');
    // TODO: Implement navigation
    // Navigator.of(_context!).pushNamed('/booking-details', arguments: id);
  }

  /// Navigate to tour details
  void _navigateToTour(String? id) {
    if (id == null) {
      AppLog.w('⚠️ Tour ID is null');
      return;
    }

    AppLog.d('📍 Navigating to tour: $id');
    // TODO: Implement navigation
    // Navigator.of(_context!).pushNamed('/tour-details', arguments: id);
  }

  /// Navigate to messages or specific conversation
  void _navigateToMessages(String? conversationId) {
    AppLog.d('📍 Navigating to messages: $conversationId');
    // TODO: Implement navigation
    // if (conversationId != null) {
    //   Navigator.of(_context!).pushNamed('/conversation', arguments: conversationId);
    // } else {
    //   Navigator.of(_context!).pushNamed('/messages');
    // }
  }

  /// Navigate to chat
  void _navigateToChat(String? chatId) {
    AppLog.d('📍 Navigating to chat: $chatId');
    // TODO: Implement navigation
    // Navigator.of(_context!).pushNamed('/chat', arguments: chatId);
  }

  /// Navigate to notifications list
  void _navigateToNotifications() {
    AppLog.d('📍 Navigating to notifications');
    // TODO: Implement navigation
    // Navigator.of(_context!).pushNamed('/notifications');
  }

  /// Navigate to profile
  void _navigateToProfile() {
    AppLog.d('📍 Navigating to profile');
    // TODO: Implement navigation
    // Navigator.of(_context!).pushNamed('/profile');
  }

  /// Navigate to attendance
  void _navigateToAttendance(String? id) {
    AppLog.d('📍 Navigating to attendance: $id');
    // TODO: Implement navigation
    // Navigator.of(_context!).pushNamed('/attendance', arguments: id);
  }

  /// Navigate to home (fallback)
  void _navigateToHome() {
    AppLog.d('📍 Navigating to home (fallback)');
    // TODO: Implement navigation
    // Navigator.of(_context!).pushNamedAndRemoveUntil('/home', (route) => false);
  }

  /// Clear context (call when app is closing)
  void dispose() {
    _context = null;
  }
}
