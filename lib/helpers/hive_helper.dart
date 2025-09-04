import 'package:hive_flutter/hive_flutter.dart';

class HiveDBHelper {
  static const String alarmBox = "alarmBox";

  static Future<void> initHive() async {
    await Hive.initFlutter();
    await Hive.openBox<Map>(alarmBox);
  }

  static Future<int> saveAlarm(DateTime alarmTime) async {
    final box = Hive.box<Map>(alarmBox);
    final id = DateTime.now().millisecondsSinceEpoch.remainder(100000);
    await box.put(id, {"id": id, "time": alarmTime.toIso8601String()});
    return id;
  }

  static List<Map> getAllAlarms() {
    final box = Hive.box<Map>(alarmBox);
    return box.values.cast<Map>().toList();
  }

  static Future<void> deleteAlarm(int id) async {
    final box = Hive.box<Map>(alarmBox);
    await box.delete(id);
  }
}
