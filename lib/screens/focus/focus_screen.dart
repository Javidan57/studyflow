import 'dart:async';

import 'package:flutter/material.dart';

import '../../app_routes.dart';
import '../../data/app_settings.dart';
import '../../data/course_data.dart';
import '../../data/session_data.dart';
import '../../data/task_data.dart';
import '../../models/study_session.dart';
import '../../models/task.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';
import '../../utils/date_formatter.dart';
import '../../widgets/app_dialogs.dart';
import '../../widgets/course_chip.dart';
import '../history/history_screen.dart';

class FocusScreen extends StatefulWidget {
  const FocusScreen({super.key, this.onSelectTab, this.linkedTask});

  final ValueChanged<int>? onSelectTab;
  final Task? linkedTask;

  @override
  State<FocusScreen> createState() => _FocusScreenState();
}

class _FocusScreenState extends State<FocusScreen> {
  static const List<String> _modes = ['Focus', 'Short break', 'Long break'];

  Timer? _timer;
  String _mode = 'Focus';
  int? _secondsLeft;
  int _completedFocus = 0;
  String? _linkedTaskId;

  @override
  void initState() {
    super.initState();
    _linkedTaskId = widget.linkedTask?.id;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  bool get _isRunning => _timer != null;

  int get _totalSeconds {
    if (_mode == 'Short break') return AppSettings.shortBreakMinutes * 60;
    if (_mode == 'Long break') return AppSettings.longBreakMinutes * 60;
    return AppSettings.focusMinutes * 60;
  }

  int get _remaining => _secondsLeft ?? _totalSeconds;

  void _start() {
    _secondsLeft ??= _totalSeconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
    setState(() {});
  }

  void _pause() {
    _timer?.cancel();
    setState(() {
      _timer = null;
    });
  }

  void _reset() {
    _timer?.cancel();
    setState(() {
      _timer = null;
      _secondsLeft = null;
    });
  }

  void _selectMode(String mode) {
    _timer?.cancel();
    setState(() {
      _timer = null;
      _mode = mode;
      _secondsLeft = null;
    });
  }

  void _tick() {
    if (!mounted) return;
    if (_remaining <= 1) {
      _finish();
    } else {
      setState(() {
        _secondsLeft = _remaining - 1;
      });
    }
  }

  Future<void> _finish() async {
    final finishedMode = _mode;
    _timer?.cancel();
    setState(() {
      _timer = null;
      _secondsLeft = null;
    });

    if (finishedMode != 'Focus') {
      _selectMode('Focus');
      AppDialogs.snack(context, 'Break finished. Ready for the next session?');
      return;
    }

    final task = _linkedTaskId == null ? null : TaskData.findById(_linkedTaskId!);
    final course = CourseData.findById(task?.courseId);
    final minutes = AppSettings.focusMinutes;
    SessionData.add(
      StudySession(
        id: SessionData.newId(),
        minutes: minutes,
        date: DateTime.now(),
        courseId: task?.courseId,
        taskId: task?.id,
        taskTitle: task?.title,
      ),
    );
    setState(() {
      _completedFocus++;
    });

    final nextBreak = _completedFocus % AppSettings.sessionsPerRound == 0
        ? 'Long break'
        : 'Short break';
    final choice = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          icon: const Icon(Icons.timer, color: AppColors.primary, size: 40),
          title: const Text('Session complete', style: AppTextStyles.title),
          content: Text(
            '$minutes minutes of focus'
            '${course == null ? '' : ' on ${course.code}'} '
            'saved to your history.',
            style: AppTextStyles.body,
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, 'history'),
              child: const Text('View history'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, 'break'),
              child: Text('Start ${nextBreak.toLowerCase()}'),
            ),
          ],
        );
      },
    );
    if (!mounted) return;
    if (choice == 'break') {
      _selectMode(nextBreak);
      _start();
    } else if (choice == 'history') {
      _openHistory();
    }
  }

  void _openHistory() {
    final selectTab = widget.onSelectTab;
    if (selectTab != null) {
      selectTab(4);
    } else {
      Navigator.push(
        context,
        MaterialPageRoute<void>(builder: (context) => const HistoryScreen()),
      );
    }
  }

  Future<void> _openSettings() async {
    await Navigator.pushNamed(context, AppRoutes.settings);
    if (!mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final pendingTasks = TaskData.pending;
    if (_linkedTaskId != null &&
        !pendingTasks.any((task) => task.id == _linkedTaskId)) {
      _linkedTaskId = null;
    }
    final linkedTask =
        _linkedTaskId == null ? null : TaskData.findById(_linkedTaskId!);
    final progress = _secondsLeft == null
        ? 0.0
        : (1 - _remaining / _totalSeconds).clamp(0.0, 1.0).toDouble();
    final sessionNumber =
        (_completedFocus % AppSettings.sessionsPerRound) + 1;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Focus'),
        actions: [
          IconButton(
            tooltip: 'Timer settings',
            icon: const Icon(Icons.tune),
            onPressed: _openSettings,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SegmentedButton<String>(
                segments: [
                  for (final mode in _modes)
                    ButtonSegment<String>(value: mode, label: Text(mode)),
                ],
                selected: {_mode},
                showSelectedIcon: false,
                onSelectionChanged: (selection) =>
                    _selectMode(selection.first),
              ),
              const SizedBox(height: AppSpacing.md),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppSpacing.radius),
                  border: Border.all(color: AppColors.border),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String?>(
                    value: _linkedTaskId,
                    isExpanded: true,
                    icon: const Icon(Icons.link),
                    items: [
                      const DropdownMenuItem<String?>(
                        value: null,
                        child: Text('No linked task'),
                      ),
                      for (final task in pendingTasks)
                        DropdownMenuItem<String?>(
                          value: task.id,
                          child: Text(
                            task.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                    onChanged: _isRunning
                        ? null
                        : (value) {
                            setState(() {
                              _linkedTaskId = value;
                            });
                          },
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              LayoutBuilder(
                builder: (context, constraints) {
                  final size = constraints.maxWidth * 0.72 > 260
                      ? 260.0
                      : constraints.maxWidth * 0.72;
                  return Center(
                    child: SizedBox(
                      width: size,
                      height: size,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          CircularProgressIndicator(
                            value: progress,
                            strokeWidth: 10,
                            backgroundColor: AppColors.primaryLight,
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(AppSpacing.lg),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      DateFormatter.clock(_remaining),
                                      style: AppTextStyles.timer,
                                    ),
                                  ),
                                  Text(
                                    _mode == 'Focus'
                                        ? 'Session $sessionNumber of '
                                            '${AppSettings.sessionsPerRound}'
                                        : _mode,
                                    style: AppTextStyles.caption,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: AppSpacing.md),
              Center(
                child: CourseChip(
                  course: CourseData.findById(linkedTask?.courseId),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton.outlined(
                    tooltip: 'Reset',
                    iconSize: 26,
                    padding: const EdgeInsets.all(12),
                    onPressed: _reset,
                    icon: const Icon(Icons.replay),
                  ),
                  const SizedBox(width: AppSpacing.lg),
                  IconButton.filled(
                    tooltip: _isRunning ? 'Pause' : 'Start',
                    iconSize: 40,
                    padding: const EdgeInsets.all(18),
                    onPressed: _isRunning ? _pause : _start,
                    icon: Icon(_isRunning ? Icons.pause : Icons.play_arrow),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Focus ${AppSettings.focusMinutes} min · '
                'short break ${AppSettings.shortBreakMinutes} min · '
                'long break ${AppSettings.longBreakMinutes} min',
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
