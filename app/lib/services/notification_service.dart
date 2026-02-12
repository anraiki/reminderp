import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse response) {
  NotificationService.instance.handleNotificationResponse(response);
}

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const String _channelId = 'reminderp_reminders';
  static const String _channelName = 'Reminders';
  static const String _channelDescription = 'Reminder alerts';
  static const String _darwinCategoryId = 'reminder_actions';
  static const String _actionSnooze5 = 'snooze_5';
  static const String _actionSnooze15 = 'snooze_15';
  static const String _actionSnoozeCustom = 'snooze_custom';

  bool _isInitialized = false;
  int _nextId = 1000;

  Future<void> initialize() async {
    if (_isInitialized) return;
    _isInitialized = true;

    tzdata.initializeTimeZones();

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    final darwinInit = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      notificationCategories: [
        DarwinNotificationCategory(
          _darwinCategoryId,
          actions: [
            DarwinNotificationAction.plain(_actionSnooze5, 'Snooze 5m'),
            DarwinNotificationAction.plain(_actionSnooze15, 'Snooze 15m'),
            DarwinNotificationAction.text(
              _actionSnoozeCustom,
              'Snooze custom',
              buttonTitle: 'Snooze',
              placeholder: 'Minutes',
            ),
          ],
        ),
      ],
    );

    final initSettings = InitializationSettings(
      android: androidInit,
      iOS: darwinInit,
      macOS: darwinInit,
    );

    await _plugin.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: handleNotificationResponse,
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    await android?.requestNotificationsPermission();
    await android?.requestExactAlarmsPermission();

    final ios = _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    await ios?.requestPermissions(alert: true, badge: true, sound: true);

    final macos = _plugin
        .resolvePlatformSpecificImplementation<
          MacOSFlutterLocalNotificationsPlugin
        >();
    await macos?.requestPermissions(alert: true, badge: true, sound: true);
  }

  Future<void> sendImmediateTestReminder() async {
    await initialize();
    final int id = _nextId++;
    final payload = jsonEncode({'kind': 'test', 'id': id});

    await _plugin.show(
      id: id,
      title: 'Test Reminder',
      body: 'Tap snooze buttons or enter custom minutes.',
      notificationDetails: NotificationDetails(
        android: _buildAndroidDetails(),
        iOS: _buildDarwinDetails(),
        macOS: _buildDarwinDetails(),
      ),
      payload: payload,
    );
  }

  Future<void> handleNotificationResponse(NotificationResponse response) async {
    await initialize();

    final actionId = response.actionId;
    if (actionId == null) return;

    if (actionId == _actionSnooze5) {
      await _scheduleSnooze(minutes: 5);
      return;
    }
    if (actionId == _actionSnooze15) {
      await _scheduleSnooze(minutes: 15);
      return;
    }
    if (actionId == _actionSnoozeCustom) {
      final parsed = int.tryParse((response.input ?? '').trim());
      final minutes = parsed != null && parsed > 0 ? parsed : 10;
      await _scheduleSnooze(minutes: minutes);
    }
  }

  Future<void> _scheduleSnooze({required int minutes}) async {
    final int id = _nextId++;
    final payload = jsonEncode({
      'kind': 'snoozed',
      'minutes': minutes,
      'id': id,
    });

    await _plugin.zonedSchedule(
      id: id,
      scheduledDate: tz.TZDateTime.now(
        tz.local,
      ).add(Duration(minutes: minutes)),
      notificationDetails: NotificationDetails(
        android: _buildAndroidDetails(),
        iOS: _buildDarwinDetails(),
        macOS: _buildDarwinDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      title: 'Snoozed Reminder',
      body: 'Snooze finished after $minutes minute(s).',
      payload: payload,
    );
  }

  AndroidNotificationDetails _buildAndroidDetails() {
    return const AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.max,
      priority: Priority.high,
      category: AndroidNotificationCategory.reminder,
      actions: <AndroidNotificationAction>[
        AndroidNotificationAction(_actionSnooze5, 'Snooze 5m'),
        AndroidNotificationAction(_actionSnooze15, 'Snooze 15m'),
        AndroidNotificationAction(
          _actionSnoozeCustom,
          'Snooze custom',
          inputs: <AndroidNotificationActionInput>[
            AndroidNotificationActionInput(label: 'Minutes'),
          ],
        ),
      ],
    );
  }

  DarwinNotificationDetails _buildDarwinDetails() {
    return const DarwinNotificationDetails(
      categoryIdentifier: _darwinCategoryId,
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      interruptionLevel: InterruptionLevel.timeSensitive,
    );
  }
}
