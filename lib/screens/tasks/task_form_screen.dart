import 'package:flutter/material.dart';

import '../../data/course_data.dart';
import '../../data/task_data.dart';
import '../../models/task.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_theme.dart';
import '../../utils/date_formatter.dart';
import '../../utils/validators.dart';
import '../../widgets/app_buttons.dart';
import '../../widgets/app_dialogs.dart';
import '../../widgets/app_dropdown_field.dart';

class TaskFormScreen extends StatefulWidget {
  const TaskFormScreen({super.key, this.task, this.initialCourseId});

  final Task? task;
  final String? initialCourseId;

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  static const List<String> _priorities = ['Low', 'Medium', 'High'];

  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();

  String _title = '';
  String _notes = '';
  String? _courseId;
  DateTime? _dueDate;
  String _priority = 'Medium';
  bool _remindDayBefore = true;

  bool get _isEditing => widget.task != null;

  @override
  void initState() {
    super.initState();
    final task = widget.task;
    if (task != null) {
      _courseId = task.courseId;
      _dueDate = task.dueDate;
      _priority = task.priority;
      _remindDayBefore = task.remindDayBefore;
      _dateController.text = DateFormatter.fullDate(task.dueDate);
    } else if (CourseData.findById(widget.initialCourseId) != null) {
      _courseId = widget.initialCourseId;
    }
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final today = DateFormatter.dayOnly(DateTime.now());
    final initial = _dueDate == null || _dueDate!.isBefore(today)
        ? today
        : _dueDate!;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: today,
      lastDate: DateTime(today.year + 2, 12, 31),
    );
    if (!mounted || picked == null) return;
    setState(() {
      _dueDate = DateTime(picked.year, picked.month, picked.day, 23, 59);
      _dateController.text = DateFormatter.fullDate(picked);
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();

    final task = Task(
      id: widget.task?.id ?? TaskData.newId(),
      title: _title,
      courseId: _courseId!,
      dueDate: _dueDate!,
      priority: _priority,
      notes: _notes,
      isDone: widget.task?.isDone ?? false,
      remindDayBefore: _remindDayBefore,
    );
    TaskData.replace(task);

    final courseCode = CourseData.findById(task.courseId)?.code ?? '';
    await AppDialogs.success(
      context,
      title: _isEditing ? 'Task updated' : 'Task saved',
      message: '"${task.title}" was saved to $courseCode.',
    );
    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isEditing ? 'Edit task' : 'New task')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  initialValue: widget.task?.title,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: AppTheme.input(
                    label: 'Title *',
                    hint: 'e.g. Problem set 5',
                    icon: Icons.edit_outlined,
                  ),
                  validator: (value) => Validators.maxLength(value, 'Title', 60),
                  onSaved: (value) => _title = value!.trim(),
                ),
                const SizedBox(height: AppSpacing.md),
                AppDropdownField<String>(
                  label: 'Course *',
                  icon: Icons.menu_book_outlined,
                  initialValue: _courseId,
                  options: [
                    for (final course in CourseData.courses)
                      DropdownOption(
                        value: course.id,
                        label: '${course.code} · ${course.name}',
                      ),
                  ],
                  validator: (value) =>
                      value == null ? 'Please choose a course' : null,
                  onSaved: (value) => _courseId = value,
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _dateController,
                  readOnly: true,
                  onTap: _pickDate,
                  decoration: AppTheme.input(
                    label: 'Due date *',
                    hint: 'Choose a date',
                    icon: Icons.calendar_today_outlined,
                  ),
                  validator: (value) =>
                      _dueDate == null ? 'Please choose a due date' : null,
                ),
                const SizedBox(height: AppSpacing.md),
                const Text('Priority', style: AppTextStyles.label),
                const SizedBox(height: AppSpacing.sm),
                SegmentedButton<String>(
                  segments: [
                    for (final priority in _priorities)
                      ButtonSegment<String>(
                        value: priority,
                        label: Text(priority),
                      ),
                  ],
                  selected: {_priority},
                  showSelectedIcon: false,
                  onSelectionChanged: (selection) {
                    setState(() {
                      _priority = selection.first;
                    });
                  },
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  initialValue: widget.task?.notes,
                  maxLines: 3,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: AppTheme.input(
                    label: 'Notes',
                    hint: 'Optional details',
                  ),
                  onSaved: (value) => _notes = value?.trim() ?? '',
                ),
                const SizedBox(height: AppSpacing.sm),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  secondary: const Icon(Icons.notifications_outlined),
                  title: const Text('Remind me one day before'),
                  value: _remindDayBefore,
                  onChanged: (value) {
                    setState(() {
                      _remindDayBefore = value;
                    });
                  },
                ),
                const SizedBox(height: AppSpacing.md),
                PrimaryButton(
                  label: _isEditing ? 'Save changes' : 'Save task',
                  onPressed: _save,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
