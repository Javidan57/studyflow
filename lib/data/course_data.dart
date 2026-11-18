import '../models/course.dart';
import '../theme/app_colors.dart';

class CourseData {
  static final List<Course> courses = [
    Course(
      id: 'c1',
      code: 'CS310',
      name: 'Mobile Application Development',
      color: AppColors.courseColors[0],
    ),
    Course(
      id: 'c2',
      code: 'MATH201',
      name: 'Linear Algebra',
      color: AppColors.courseColors[1],
    ),
    Course(
      id: 'c3',
      code: 'CS408',
      name: 'Computer Networks',
      color: AppColors.courseColors[2],
    ),
    Course(
      id: 'c4',
      code: 'HIST191',
      name: 'History of Turkey',
      color: AppColors.courseColors[3],
    ),
  ];

  static Course? findById(String? id) {
    for (final course in courses) {
      if (course.id == id) {
        return course;
      }
    }
    return null;
  }

  static String newId() => 'c${DateTime.now().millisecondsSinceEpoch}';
}
