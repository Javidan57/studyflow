class Task {
  Task({
    required this.id,
    required this.title,
    required this.courseId,
    required this.dueDate,
    this.priority = 'Medium',
    this.notes = '',
    this.isDone = false,
    this.remindDayBefore = true,
  });

  final String id;
  final String title;
  final String courseId;
  final DateTime dueDate;
  final String priority;
  final String notes;
  final bool remindDayBefore;
  bool isDone;
}
