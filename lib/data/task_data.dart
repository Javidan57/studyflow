import '../models/task.dart';

class TaskData {
  static final DateTime _today = DateTime.now();

  static DateTime _dayFromToday(int days) {
    return DateTime(_today.year, _today.month, _today.day + days, 23, 59);
  }

  static final List<Task> tasks = [
    Task(
      id: 't1',
      title: 'Step 2.2 UI implementation',
      courseId: 'c1',
      dueDate: _dayFromToday(3),
      priority: 'High',
      notes: 'All approved screens, shared theme files, README and the PDF.',
    ),
    Task(
      id: 't2',
      title: 'Problem set 4',
      courseId: 'c2',
      dueDate: _dayFromToday(0),
      priority: 'Medium',
      notes: 'Eigenvalues and diagonalisation, questions 1 to 8.',
    ),
    Task(
      id: 't3',
      title: 'Socket lab report',
      courseId: 'c3',
      dueDate: _dayFromToday(5),
      priority: 'Low',
    ),
    Task(
      id: 't4',
      title: 'Essay outline',
      courseId: 'c4',
      dueDate: _dayFromToday(1),
      priority: 'Medium',
      notes: 'Two pages, three primary sources.',
    ),
    Task(
      id: 't5',
      title: 'Midterm revision',
      courseId: 'c1',
      dueDate: _dayFromToday(-1),
      priority: 'High',
      isDone: true,
    ),
  ];

  static Task? findById(String id) {
    for (final task in tasks) {
      if (task.id == id) {
        return task;
      }
    }
    return null;
  }

  static List<Task> sortedByDueDate(List<Task> list) {
    final sorted = [...list];
    sorted.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    return sorted;
  }

  static List<Task> get pending {
    return sortedByDueDate(tasks.where((task) => !task.isDone).toList());
  }

  static List<Task> forCourse(String courseId) {
    return sortedByDueDate(
      tasks.where((task) => task.courseId == courseId).toList(),
    );
  }

  static void replace(Task updated) {
    final index = tasks.indexWhere((task) => task.id == updated.id);
    if (index == -1) {
      tasks.add(updated);
    } else {
      tasks[index] = updated;
    }
  }

  static String newId() => 't${DateTime.now().millisecondsSinceEpoch}';
}
