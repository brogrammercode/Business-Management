import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:gas/main.dart';

class LocalNotification {
  static const String _defaultKey = 'default';
  static const String _defaultCN = 'default_CN';
  static const String _defaultCD = 'default_CD';

  static const AndroidNotificationDetails _defaultAndroidND =
      AndroidNotificationDetails(
        _defaultKey,
        _defaultCN,
        channelDescription: _defaultCD,
        importance: Importance.high,
        priority: Priority.high,
        styleInformation: DefaultStyleInformation(true, true),
        fullScreenIntent: true,
      );
  static const NotificationDetails _defaultND = NotificationDetails(
    android: _defaultAndroidND,
  );

  static late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  // Initialize FlutterLocalNotificationsPlugin instance
  static Future<void> initialize() async {
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();
    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );
    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          onDidReceiveBackgroundNotificationResponse,
      onDidReceiveBackgroundNotificationResponse:
          onDidReceiveBackgroundNotificationResponse,
    );

    // Request permissions if needed (only necessary for iOS)
    await _requestPermissions();
  }

  // Handle notification selection
  @pragma('vm:entry-point')
  static Future<void> onDidReceiveBackgroundNotificationResponse(
    NotificationResponse res,
  ) async {
    final BuildContext? context = navigatorKey.currentContext;
    String? actionId = res.actionId ?? 'FLUTTER_NOTIFICATION_CLICK';

    if (context != null) {
      switch (actionId) {
        default:
          break;
      }
    } else {
      log('null: context=$context, actionId=$actionId');
    }
  }

  // Request permissions (iOS only)
  static Future<void> _requestPermissions() async {
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }

  Future<void> defaultNotify({
    required int id,
    required String title,
    required String body,
    required String payload,
  }) async {
    await _flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      _defaultND,
      payload: payload,
    );
  }

  // Remove notification by id
  Future<void> removeNotification(int notificationId) async {
    await _flutterLocalNotificationsPlugin.cancel(notificationId);
  }

  // Remove notification by id
  Future<void> removeAll() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }
}
