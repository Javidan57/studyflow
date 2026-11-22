import 'package:flutter/material.dart';

import '../../data/course_data.dart';
import '../../data/session_data.dart';
import '../../data/task_data.dart';
import '../../models/task.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';
import '../../utils/date_formatter.dart';
import '../../widgets/app_buttons.dart';
import '../../widgets/app_dialogs.dart';
import '../../widgets/course_chip.dart';
import '../../widgets/priority_badge.dart';
import '../focus/focus_screen.dart';
import 'task_form_screen.dart';

class TaskDetailScreen extends StatefulWidget {
  const TaskDetailScreen({super.key, required this.task});

  final Task task;

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  late Task _task;

  @override
  void initState() {
    super.initState();
    _task = widget.task;
  }

  Future<void> _edit() async {
    await Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => TaskFormScreen(task: _task),
      ),
    );
    if (!mounted) return;
    setState(() {
      _task = TaskData.findById(_task.id) ?? _task;
    });
  }

  Future<void> _delete() async {
    final confirmed = await AppDialogs.confirm(
      context,
      title: 'Delete task?',
      message: '"${_task.title}" will be removed. This cannot be undone.',
    );
    if (!confirmed || !mounted) return;
    TaskData.tasks.removeWhere((task) => task.id == _task.id);
    AppDialogs.snack(context, 'Task deleted');
    Navigator.pop(context);
  }

  Future<void> _focus() async {
    await Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => FocusScreen(linkedTask: _task),
      ),
    );
    if (!mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final course = CourseData.findById(_task.courseId);
    final sessions = SessionData.forTask(_task.id);
    final minutes = sessions.fold<int>(0, (sum, s) => sum + s.minutes);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task details'),
        actions: [
          IconButton(
            tooltip: 'Edit task',
            icon: const Icon(Icons.edit_outlined),
            onPressed: _edit,
          ),
          IconButton(
            tooltip: 'Delete task',
            icon: const Icon(Icons.delete_outline),
            onPressed: _delete,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: CourseChip(course: course),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(_task.title, style: AppTextStyles.heading),
              const SizedBox(height: AppSpacing.md),
              _InfoRow(
                icon: Icons.calendar_today_outlined,
                label: 'Due',
                child: Text(
                  '${DateFormatter.fullDate(_task.dueDate)} · '
                  '${DateFormatter.time(_task.dueDate)}',
                  style: AppTextStyles.cardTitle,
                ),
              ),
              _InfoRow(
                icon: Icons.flag_outlined,
                label: 'Priority',
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: PriorityBadge(priority: _task.priority),
                ),
              ),
              _InfoRow(
                icon: Icons.check_circle_outline,
                label: 'Status',
                child: Text(
                  _task.isDone ? 'Completed' : 'Pending',
                  style: AppTextStyles.cardTitle.copyWith(
                    color: _task.isDone ? AppColors.success : AppColors.warning,
                  ),
                ),
              ),
              _InfoRow(
                icon: Icons.notifications_outlined,
                label: 'Reminder',
                child: Text(
                  _task.remindDayBefore ? 'One day before' : 'Off',
                  style: AppTextStyles.cardTitle,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              const Text('NOTES', style: AppTextStyles.label),
              const SizedBox(height: AppSpacing.xs),
              Text(
                _task.notes.isEmpty ? 'No notes added.' : _task.notes,
                style: _task.notes.isEmpty
                    ? AppTextStyles.bodyMuted
                    : AppTextStyles.body,
              ),
              const SizedBox(height: AppSpacing.lg),
              PrimaryButton(
                label: _task.isDone ? 'Mark as pending' : 'Mark as completed',
                icon: _task.isDone ? Icons.undo : Icons.check,
                onPressed: () {
                  setState(() {
                    _task.isDone = !_task.isDone;
                  });
                },
              ),
              const SizedBox(height: AppSpacing.sm),
              SecondaryButton(
                label: 'Focus on this task',
                icon: Icons.timer_outlined,
                onPressed: _focus,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                '${sessions.length} focus sessions on this task · '
                '${DateFormatter.duration(minutes)}',
                style: AppTextStyles.caption,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.child,
  });

  final IconData icon;
  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.textSecondary),
          const SizedBox(width: 12),
          SizedBox(
            width: 76,
            child: Text(label, style: AppTextStyles.bodyMuted),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}
