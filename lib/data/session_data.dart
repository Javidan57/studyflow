import '../models/study_session.dart';

class SessionData {
  static final DateTime _now = DateTime.now();

  static DateTime _at(int daysAgo, int hour, int minute) {
    return DateTime(_now.year, _now.month, _now.day - daysAgo, hour, minute);
  }

  static final List<StudySession> sessions = [
    StudySession(
      id: 's1',
      minutes: 25,
      date: _at(0, 14, 5),
      courseId: 'c1',
      taskId: 't1',
      taskTitle: 'Step 2.2 UI implementation',
    ),
    StudySession(
      id: 's2',
      minutes: 50,
      date: _at(0, 10, 40),
      courseId: 'c2',
      taskId: 't2',
      taskTitle: 'Problem set 4',
    ),
    StudySession(
      id: 's3',
      minutes: 50,
      date: _at(1, 20, 30),
      courseId: 'c1',
      taskId: 't5',
      taskTitle: 'Midterm revision',
    ),
    StudySession(
      id: 's4',
      minutes: 25,
      date: _at(2, 16, 15),
      courseId: 'c3',
    ),
    StudySession(
      id: 's5',
      minutes: 75,
      date: _at(4, 11, 0),
      courseId: 'c4',
    ),
  ];

  static List<StudySession> get newestFirst {
    final sorted = [...sessions];
    sorted.sort((a, b) => b.date.compareTo(a.date));
    return sorted;
  }

  static bool _sameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  static int minutesOn(DateTime day) {
    return sessions
        .where((session) => _sameDay(session.date, day))
        .fold<int>(0, (sum, session) => sum + session.minutes);
  }

  static int minutesForCourse(String courseId) {
    return sessions
        .where((session) => session.courseId == courseId)
        .fold<int>(0, (sum, session) => sum + session.minutes);
  }

  static List<StudySession> forTask(String taskId) {
    return sessions.where((session) => session.taskId == taskId).toList();
  }

  static void add(StudySession session) {
    sessions.add(session);
  }

  static String newId() => 's${DateTime.now().millisecondsSinceEpoch}';
}
