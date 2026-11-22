import 'package:flutter/material.dart';

import '../../data/course_data.dart';
import '../../data/session_data.dart';
import '../../data/task_data.dart';
import '../../models/course.dart';
import '../../models/task.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';
import '../../utils/date_formatter.dart';
import '../../widgets/app_dialogs.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/section_header.dart';
import '../../widgets/session_tile.dart';
import '../../widgets/task_card.dart';
import '../tasks/task_detail_screen.dart';
import '../tasks/task_form_screen.dart';
import 'course_form_screen.dart';

class CourseDetailScreen extends StatefulWidget {
  const CourseDetailScreen({super.key, required this.course});

  final Course course;

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  late Course _course;

  @override
  void initState() {
    super.initState();
    _course = widget.course;
  }

  Future<void> _edit() async {
    await Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => CourseFormScreen(course: _course),
      ),
    );
    if (!mounted) return;
    setState(() {
      _course = CourseData.findById(_course.id) ?? _course;
    });
  }

  Future<void> _delete() async {
    final confirmed = await AppDialogs.confirm(
      context,
      title: 'Delete ${_course.code}?',
      message: 'This course and all of its tasks will be removed.',
    );
    if (!confirmed || !mounted) return;
    CourseData.courses.removeWhere((course) => course.id == _course.id);
    TaskData.tasks.removeWhere((task) => task.courseId == _course.id);
    AppDialogs.snack(context, '${_course.code} deleted');
    Navigator.pop(context);
  }

  Future<void> _openTask(Task task) async {
    await Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => TaskDetailScreen(task: task),
      ),
    );
    if (!mounted) return;
    setState(() {});
  }

  Future<void> _addTask() async {
    await Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => TaskFormScreen(initialCourseId: _course.id),
      ),
    );
    if (!mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final tasks = TaskData.forCourse(_course.id);
    final pending = tasks.where((task) => !task.isDone).length;
    final sessions = SessionData.newestFirst
        .where((session) => session.courseId == _course.id)
        .take(3)
        .toList();
    final studied = SessionData.minutesForCourse(_course.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(_course.code),
        actions: [
          IconButton(
            tooltip: 'Edit course',
            icon: const Icon(Icons.edit_outlined),
            onPressed: _edit,
          ),
          IconButton(
            tooltip: 'Delete course',
            icon: const Icon(Icons.delete_outline),
            onPressed: _delete,
          ),
        ],
      ),
      body: ListView(
        padding: AppSpacing.screenPadding,
        children: [
          Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSpacing.radius),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(height: 12, color: _course.color),
                Padding(
                  padding: AppSpacing.cardPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_course.name, style: AppTextStyles.title),
                      const SizedBox(height: AppSpacing.md),
                      Row(
                        children: [
                          _Stat(value: '${tasks.length}', label: 'Tasks'),
                          _Stat(value: '$pending', label: 'Pending'),
                          _Stat(
                            value: DateFormatter.duration(studied),
                            label: 'Studied',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          SectionHeader(
            title: 'Tasks in this course',
            actionLabel: 'Add task',
            onAction: _addTask,
          ),
          const SizedBox(height: AppSpacing.sm),
          if (tasks.isEmpty)
            const EmptyState(
              icon: Icons.task_alt,
              message: 'No tasks for this course yet.',
            )
          else
            for (final task in tasks)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: TaskCard(
                  key: ValueKey(task.id),
                  task: task,
                  onTap: () => _openTask(task),
                  onToggleDone: (value) {
                    setState(() {
                      task.isDone = value ?? false;
                    });
                  },
                ),
              ),
          const SizedBox(height: AppSpacing.md),
          const SectionHeader(title: 'Recent focus sessions'),
          if (sessions.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
              child: Text(
                'No sessions recorded for this course.',
                style: AppTextStyles.bodyMuted,
              ),
            )
          else
            for (final session in sessions)
              SessionTile(session: session, showDate: true),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(value, style: AppTextStyles.heading),
          ),
          Text(label, style: AppTextStyles.caption),
        ],
      ),
    );
  }
}
