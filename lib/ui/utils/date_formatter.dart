import 'package:intl/intl.dart';

class DateFormatter {
  static final DateFormat _apiDateFormat = DateFormat('yyyy-MM-dd');

  /// Formats a DateTime to API date format (yyyy-MM-dd)
  static String formatForApi(DateTime date) {
    return _apiDateFormat.format(date);
  }

  /// Parses an API date string (yyyy-MM-dd) to DateTime
  static DateTime parseFromApi(String dateString) {
    return _apiDateFormat.parse(dateString);
  }

  /// Gets today's date formatted for API
  static String getTodayFormatted() {
    return formatForApi(DateTime.now());
  }

  /// Checks if the given date is today
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  /// Gets yesterday's date formatted for API
  static String getYesterdayFormatted() {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return formatForApi(yesterday);
  }
}
