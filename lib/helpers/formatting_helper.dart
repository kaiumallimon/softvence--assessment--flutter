import 'package:intl/intl.dart';

class FormattingHelper {
  static String formatTime(DateTime time) {
    // 12:00 AM/PM format
    return DateFormat.jm().format(time);
  }

  static String formatDate(DateTime date) {
    // e.g., Fri 21 Sep 2023
    return DateFormat('EEE dd MMM yyyy').format(date);
  }
}
