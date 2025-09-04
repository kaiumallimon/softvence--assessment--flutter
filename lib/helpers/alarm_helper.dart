import 'package:alarm/alarm.dart';
import 'package:assessment/helpers/hive_helper.dart';
import 'package:assessment/helpers/notification_helper.dart';

class AlarmHelper {
  static Future<void> initialize() async {
    await Alarm.init();
    // Optional: Set default ringtone, vibration, etc.
  }

  static Future<void> setAlarm(DateTime alarmTime) async {
    final id = await HiveDBHelper.saveAlarm(alarmTime);

    final alarmSettings = AlarmSettings(
      id: id,
      dateTime: alarmTime,
      assetAudioPath: 'assets/alarm.mp3',
      loopAudio: true,
      vibrate: true,
      volumeSettings: VolumeSettings.fade(
        volume: 1.0,
        fadeDuration: const Duration(seconds: 2),
      ),
      notificationSettings: NotificationSettings(
        title: 'Alarm',
        body: 'Tap to stop the alarm',
      ),
      androidFullScreenIntent: true,
      androidStopAlarmOnTermination: false,
      warningNotificationOnKill: true,
    );

    await Alarm.set(alarmSettings: alarmSettings);
  }

  static Future<void> deleteAlarm(int id) async {
    await Alarm.stop(id);
    await HiveDBHelper.deleteAlarm(id);

    // Post-alarm notification
    await NotificationHelper.showInstantNotification(
      id: id + 1000,
      title: "Alarm Dismissed",
      body: "Your alarm has been dismissed",
      isAlarm: false,
    );
  }

  static Future<void> stopAlarm(int id) async {
    await Alarm.stop(id);

    // Show post-alarm notification
    await NotificationHelper.showInstantNotification(
      id: id + 1000,
      title: "Alarm Stopped",
      body: "Your alarm has been stopped",
      isAlarm: false,
    );
  }
}
