import 'package:flutter/material.dart';

import '../../data/course_data.dart';
import '../../data/task_data.dart';
import '../../models/task.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/app_dialogs.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/task_card.dart';
import 'task_detail_screen.dart';
import 'task_form_screen.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key, required this.onSelectTab});

  final ValueChanged<int> onSelectTab;

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  static const List<String> _statusFilters = ['All', 'Pending', 'Completed'];

  String _status = 'Pending';
  String? _courseId;

  List<Task> get _visibleTasks {
    final filtered = TaskData.tasks.where((task) {
      final statusMatches = _status == 'All' ||
          (_status == 'Pending' && !task.isDone) ||
          (_status == 'Completed' && task.isDone);
      final courseMatches = _courseId == null || task.courseId == _courseId;
      return statusMatches && courseMatches;
    }).toList();
    return TaskData.sortedByDueDate(filtered);
  }

  Future<void> _addTask() async {
    if (CourseData.courses.isEmpty) {
      AppDialogs.snack(context, 'Add a course before creating tasks.');
      widget.onSelectTab(3);
      return;
    }
    await Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (context) => const TaskFormScreen()),
    );
    if (!mounted) return;
    setState(() {});
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

  Future<void> _deleteTask(Task task) async {
    final confirmed = await AppDialogs.confirm(
      context,
      title: 'Delete task?',
      message: '"${task.title}" will be removed. This cannot be undone.',
    );
    if (!confirmed || !mounted) return;
    setState(() {
      TaskData.tasks.removeWhere((item) => item.id == task.id);
    });
    AppDialogs.snack(context, 'Task deleted');
  }

  @override
  Widget build(BuildContext context) {
    if (_courseId != null && CourseData.findById(_courseId) == null) {
      _courseId = null;
    }
    final tasks = _visibleTasks;

    return Scaffold(
      appBar: AppBar(title: const Text('Tasks')),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add task',
        onPressed: _addTask,
        child: const Icon(Icons.add),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.sm,
              AppSpacing.md,
              0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.xs,
                  children: [
                    for (final status in _statusFilters)
                      ChoiceChip(
                        label: Text(status),
                        selected: _status == status,
                        onSelected: (_) {
                          setState(() {
                            _status = status;
                          });
                        },
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppSpacing.radius),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String?>(
                      value: _courseId,
                      isExpanded: true,
                      icon: const Icon(Icons.filter_list),
                      items: [
                        const DropdownMenuItem<String?>(
                          value: null,
                          child: Text('All courses'),
                        ),
                        for (final course in CourseData.courses)
                          DropdownMenuItem<String?>(
                            value: course.id,
                            child: Text(
                              '${course.code} · ${course.name}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _courseId = value;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  '${tasks.length} tasks · sorted by due date',
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),
          Expanded(
            child: tasks.isEmpty
                ? SingleChildScrollView(
                    child: EmptyState(
                      icon: Icons.task_alt,
                      message: _status == 'Completed'
                          ? 'No completed tasks yet.'
                          : 'No tasks here. Tap + to add one.',
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.md,
                      AppSpacing.sm,
                      AppSpacing.md,
                      88,
                    ),
                    itemCount: tasks.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: AppSpacing.sm),
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return TaskCard(
                        key: ValueKey(task.id),
                        task: task,
                        onTap: () => _openTask(task),
                        onToggleDone: (value) {
                          setState(() {
                            task.isDone = value ?? false;
                          });
                        },
                        onDelete: () => _deleteTask(task),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
