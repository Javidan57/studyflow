import 'package:flutter/material.dart';

import '../../data/course_data.dart';
import '../../models/course.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_theme.dart';
import '../../utils/validators.dart';
import '../../widgets/app_buttons.dart';
import '../../widgets/app_dialogs.dart';
import '../../widgets/course_card.dart';

class CourseFormScreen extends StatefulWidget {
  const CourseFormScreen({super.key, this.course});

  final Course? course;

  @override
  State<CourseFormScreen> createState() => _CourseFormScreenState();
}

class _CourseFormScreenState extends State<CourseFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _nameController = TextEditingController();
  late Color _color;

  bool get _isEditing => widget.course != null;

  @override
  void initState() {
    super.initState();
    final course = widget.course;
    _codeController.text = course?.code ?? '';
    _nameController.text = course?.name ?? '';
    _color = course?.color ?? AppColors.courseColors.first;
  }

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  String? _validateCode(String? value) {
    final error = Validators.maxLength(value, 'Course code', 10);
    if (error != null) return error;
    final code = value!.trim().toUpperCase();
    final taken = CourseData.courses.any(
      (course) => course.code == code && course.id != widget.course?.id,
    );
    return taken ? '$code already exists' : null;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final course = Course(
      id: widget.course?.id ?? CourseData.newId(),
      code: _codeController.text.trim().toUpperCase(),
      name: _nameController.text.trim(),
      color: _color,
    );
    final index = CourseData.courses.indexWhere((c) => c.id == course.id);
    if (index == -1) {
      CourseData.courses.add(course);
    } else {
      CourseData.courses[index] = course;
    }

    await AppDialogs.success(
      context,
      title: _isEditing ? 'Course updated' : 'Course added',
      message: '${course.code} · ${course.name} was saved.',
    );
    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final preview = Course(
      id: 'preview',
      code: _codeController.text.trim().isEmpty
          ? 'CODE'
          : _codeController.text.trim().toUpperCase(),
      name: _nameController.text.trim().isEmpty
          ? 'Course name'
          : _nameController.text.trim(),
      color: _color,
    );

    return Scaffold(
      appBar: AppBar(title: Text(_isEditing ? 'Edit course' : 'New course')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _codeController,
                  textCapitalization: TextCapitalization.characters,
                  decoration: AppTheme.input(
                    label: 'Course code *',
                    hint: 'e.g. CS310',
                    icon: Icons.tag,
                  ),
                  validator: _validateCode,
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _nameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: AppTheme.input(
                    label: 'Course name *',
                    hint: 'e.g. Mobile Application Development',
                    icon: Icons.menu_book_outlined,
                  ),
                  validator: (value) =>
                      Validators.maxLength(value, 'Course name', 50),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: AppSpacing.md),
                const Text('LABEL COLOUR', style: AppTextStyles.label),
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    for (final color in AppColors.courseColors)
                      _ColorDot(
                        color: color,
                        selected: color == _color,
                        onTap: () {
                          setState(() {
                            _color = color;
                          });
                        },
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                const Text('PREVIEW', style: AppTextStyles.label),
                const SizedBox(height: AppSpacing.sm),
                Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    width: 200,
                    height: 168,
                    child: CourseCard(course: preview, pendingCount: 0),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                PrimaryButton(
                  label: _isEditing ? 'Save changes' : 'Save course',
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

class _ColorDot extends StatelessWidget {
  const _ColorDot({
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: selected ? AppColors.textPrimary : AppColors.surface,
            width: 3,
          ),
        ),
        child: selected
            ? const Icon(Icons.check, color: AppColors.textOnPrimary, size: 20)
            : null,
      ),
    );
  }
}
