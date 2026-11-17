class DateFormatter {
  static const List<String> _weekdays = [
    'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun',
  ];

  static const List<String> _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  static String twoDigits(int value) => value.toString().padLeft(2, '0');

  static DateTime dayOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  static int daysFromToday(DateTime date) {
    return dayOnly(date).difference(dayOnly(DateTime.now())).inDays;
  }

  static String shortDate(DateTime date) {
    return '${_weekdays[date.weekday - 1]}, ${date.day} ${_months[date.month - 1]}';
  }

  static String fullDate(DateTime date) {
    return '${shortDate(date)} ${date.year}';
  }

  static String time(DateTime date) {
    return '${twoDigits(date.hour)}:${twoDigits(date.minute)}';
  }

  static String dueLabel(DateTime date) {
    final days = daysFromToday(date);
    if (days < 0) return 'Overdue';
    if (days == 0) return 'Due today';
    if (days == 1) return 'Due tomorrow';
    return 'Due ${shortDate(date)}';
  }

  static String dayHeader(DateTime date) {
    final days = daysFromToday(date);
    if (days == 0) return 'Today';
    if (days == -1) return 'Yesterday';
    return shortDate(date);
  }

  static String duration(int minutes) {
    if (minutes < 60) return '$minutes min';
    final hours = minutes ~/ 60;
    final rest = minutes % 60;
    return rest == 0 ? '${hours}h' : '${hours}h ${rest}m';
  }

  static String clock(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${twoDigits(minutes)}:${twoDigits(seconds)}';
  }

  static String weekdayLetter(DateTime date) {
    return _weekdays[date.weekday - 1].substring(0, 1);
  }
}
