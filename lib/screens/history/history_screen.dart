import 'package:flutter/material.dart';

import '../../data/course_data.dart';
import '../../data/session_data.dart';
import '../../models/study_session.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';
import '../../utils/date_formatter.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/session_tile.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key, this.onSelectTab});

  final ValueChanged<int>? onSelectTab;

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String? _courseId;

  List<DateTime> get _lastSevenDays {
    final today = DateFormatter.dayOnly(DateTime.now());
    return [
      for (var i = 6; i >= 0; i--)
        DateTime(today.year, today.month, today.day - i),
    ];
  }

  Map<DateTime, List<StudySession>> _groupByDay(List<StudySession> sessions) {
    final groups = <DateTime, List<StudySession>>{};
    for (final session in sessions) {
      final day = DateFormatter.dayOnly(session.date);
      groups.putIfAbsent(day, () => []).add(session);
    }
    return groups;
  }

  @override
  Widget build(BuildContext context) {
    if (_courseId != null && CourseData.findById(_courseId) == null) {
      _courseId = null;
    }
    final sessions = SessionData.newestFirst
        .where((s) => _courseId == null || s.courseId == _courseId)
        .toList();
    final days = _lastSevenDays;
    final dailyMinutes = [
      for (final day in days)
        sessions
            .where((s) => DateFormatter.dayOnly(s.date) == day)
            .fold<int>(0, (sum, s) => sum + s.minutes),
    ];
    final weekTotal = dailyMinutes.fold<int>(0, (sum, m) => sum + m);
    final weekSessions = sessions
        .where((s) => !DateFormatter.dayOnly(s.date).isBefore(days.first))
        .length;
    final groups = _groupByDay(sessions);

    return Scaffold(
      appBar: AppBar(title: const Text('Study history')),
      body: ListView(
        padding: AppSpacing.screenPadding,
        children: [
          Container(
            padding: AppSpacing.cardPadding,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSpacing.radius),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _SummaryValue(
                        label: 'Last 7 days',
                        value: DateFormatter.duration(weekTotal),
                      ),
                    ),
                    Expanded(
                      child: _SummaryValue(
                        label: 'Sessions',
                        value: '$weekSessions',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                _WeekChart(days: days, minutes: dailyMinutes),
              ],
            ),
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
          if (sessions.isEmpty)
            EmptyState(
              icon: Icons.history,
              message: 'No focus sessions yet.',
              actionLabel: 'Start a focus session',
              onAction: () => widget.onSelectTab?.call(2),
            )
          else
            for (final entry in groups.entries) ...[
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.md),
                child: Text(
                  DateFormatter.dayHeader(entry.key).toUpperCase(),
                  style: AppTextStyles.label,
                ),
              ),
              for (final session in entry.value)
                SessionTile(key: ValueKey(session.id), session: session),
            ],
        ],
      ),
    );
  }
}

class _SummaryValue extends StatelessWidget {
  const _SummaryValue({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.caption),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(value, style: AppTextStyles.heading),
        ),
      ],
    );
  }
}

class _WeekChart extends StatelessWidget {
  const _WeekChart({required this.days, required this.minutes});

  final List<DateTime> days;
  final List<int> minutes;

  @override
  Widget build(BuildContext context) {
    final highest = minutes.fold<int>(0, (max, m) => m > max ? m : max);
    return SizedBox(
      height: 96,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < days.length; i++)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Column(
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: FractionallySizedBox(
                          heightFactor: highest == 0 ? 0 : minutes[i] / highest,
                          child: Container(
                            decoration: BoxDecoration(
                              color: i == days.length - 1
                                  ? AppColors.primary
                                  : AppColors.primaryLight,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      DateFormatter.weekdayLetter(days[i]),
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
