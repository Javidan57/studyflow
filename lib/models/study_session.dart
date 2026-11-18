class StudySession {
  StudySession({
    required this.id,
    required this.minutes,
    required this.date,
    this.courseId,
    this.taskId,
    this.taskTitle,
  });

  final String id;
  final int minutes;
  final DateTime date;
  final String? courseId;
  final String? taskId;
  final String? taskTitle;
}
