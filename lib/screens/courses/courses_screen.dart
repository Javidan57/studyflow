import 'package:flutter/material.dart';

import '../../data/course_data.dart';
import '../../data/task_data.dart';
import '../../models/course.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/app_dialogs.dart';
import '../../widgets/course_card.dart';
import '../../widgets/empty_state.dart';
import 'course_detail_screen.dart';
import 'course_form_screen.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key, required this.onSelectTab});

  final ValueChanged<int> onSelectTab;

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  int _pendingFor(Course course) {
    return TaskData.tasks
        .where((task) => task.courseId == course.id && !task.isDone)
        .length;
  }

  Future<void> _addCourse() async {
    await Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (context) => const CourseFormScreen()),
    );
    if (!mounted) return;
    setState(() {});
  }

  Future<void> _openCourse(Course course) async {
    await Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => CourseDetailScreen(course: course),
      ),
    );
    if (!mounted) return;
    setState(() {});
  }

  Future<void> _deleteCourse(Course course) async {
    final taskCount =
        TaskData.tasks.where((task) => task.courseId == course.id).length;
    final confirmed = await AppDialogs.confirm(
      context,
      title: 'Delete ${course.code}?',
      message: taskCount == 0
          ? 'This course will be removed.'
          : 'This course and its $taskCount tasks will be removed.',
    );
    if (!confirmed || !mounted) return;
    setState(() {
      CourseData.courses.removeWhere((item) => item.id == course.id);
      TaskData.tasks.removeWhere((task) => task.courseId == course.id);
    });
    AppDialogs.snack(context, '${course.code} deleted');
  }

  @override
  Widget build(BuildContext context) {
    final courses = CourseData.courses;
    final pendingTotal = TaskData.pending.length;

    return Scaffold(
      appBar: AppBar(title: const Text('Courses')),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add course',
        onPressed: _addCourse,
        child: const Icon(Icons.add),
      ),
      body: courses.isEmpty
          ? Center(
              child: SingleChildScrollView(
                child: EmptyState(
                  icon: Icons.menu_book_outlined,
                  message: 'No courses yet. Add your first course to start '
                      'planning tasks.',
                  actionLabel: 'Add course',
                  onAction: _addCourse,
                ),
              ),
            )
          : CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.md,
                    AppSpacing.sm,
                    AppSpacing.md,
                    0,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${courses.length} courses · '
                            '$pendingTotal pending tasks',
                            style: AppTextStyles.bodyMuted,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        TextButton(
                          onPressed: () => widget.onSelectTab(1),
                          child: const Text('View tasks'),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.md,
                    AppSpacing.sm,
                    AppSpacing.md,
                    88,
                  ),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 220,
                      mainAxisExtent: 168,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final course = courses[index];
                        return CourseCard(
                          key: ValueKey(course.id),
                          course: course,
                          pendingCount: _pendingFor(course),
                          onTap: () => _openCourse(course),
                          onDelete: () => _deleteCourse(course),
                        );
                      },
                      childCount: courses.length,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
