import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'dart:typed_data';

class NotificationHelper {
  static final _notification = FlutterLocalNotificationsPlugin();

  /* Initialize the notification plugin */
  static Future<void> init({
    required Function(int id) onNotificationDismissed,
  }) async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iOSInit = DarwinInitializationSettings();

    /* Define an alarm notification channel */
    final AndroidNotificationChannel alarmChannel = AndroidNotificationChannel(
      'alarm_channel_id',
      'Alarms',
      description: 'Channel for alarm notifications',
      importance: Importance.max,
      enableVibration: true,
      enableLights: true,
      playSound: true,
      sound: UriAndroidNotificationSound(
        'content://settings/system/alarm_sound',
      ),
      showBadge: true,
    );

    /* Create the channel before initializing */
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(alarmChannel);

    await _notification.initialize(
      const InitializationSettings(android: androidInit, iOS: iOSInit),
      onDidReceiveNotificationResponse: (response) {
        final id = response.id ?? -1;
        if (id != -1) onNotificationDismissed(id);
      },
    );
  }

  /* Schedule a notification (alarm or regular) at a specific time */
  static Future<void> scheduledNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    bool isAlarm = false,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      isAlarm ? 'alarm_channel_id' : 'general_channel',
      isAlarm ? 'Alarms' : 'General Notifications',
      channelDescription: isAlarm
          ? 'Channel for alarm notifications'
          : 'Channel for regular notifications',
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
      sound: isAlarm
          ? UriAndroidNotificationSound('content://settings/system/alarm_sound')
          : null,
      enableVibration: true,
      vibrationPattern: Int64List.fromList([
        0,
        500,
        500,
        500,
        500,
        500,
        500,
        500,
      ]),
      enableLights: true,
      fullScreenIntent: isAlarm,
      category: AndroidNotificationCategory.alarm,
      visibility: NotificationVisibility.public,
      actions: isAlarm
          ? <AndroidNotificationAction>[
              const AndroidNotificationAction('stop', 'Stop'),
              const AndroidNotificationAction('snooze', 'Snooze'),
            ]
          : null,
      ticker: isAlarm ? 'Alarm' : null,
      ongoing: isAlarm,
      autoCancel: !isAlarm,
    );

    final iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notification.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  /// Show a notification immediately (alarm or regular)
  static Future<void> showInstantNotification({
    required int id,
    required String title,
    required String body,
    bool isAlarm = false,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      isAlarm ? 'alarm_channel' : 'general_channel',
      isAlarm ? 'Alarm Notifications' : 'General Notifications',
      channelDescription: isAlarm
          ? 'Channel for alarm notifications'
          : 'Channel for regular notifications',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      fullScreenIntent: isAlarm,
      category: isAlarm
          ? AndroidNotificationCategory.alarm
          : AndroidNotificationCategory.reminder,
      ticker: isAlarm ? 'Alarm' : null,
    );

    final iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notification.show(id, title, body, details);
  }
}
