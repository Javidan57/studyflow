import 'package:flutter/material.dart';

import '../data/course_data.dart';
import '../models/study_session.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import '../utils/date_formatter.dart';

class SessionTile extends StatelessWidget {
  const SessionTile({super.key, required this.session, this.showDate = false});

  final StudySession session;
  final bool showDate;

  @override
  Widget build(BuildContext context) {
    final course = CourseData.findById(session.courseId);
    final title = [
      course?.code ?? 'General study',
      if (session.taskTitle != null) session.taskTitle!,
    ].join(' · ');
    final when = showDate
        ? '${DateFormatter.dayHeader(session.date)} · ${DateFormatter.time(session.date)}'
        : '${DateFormatter.time(session.date)} · Focus';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: (course?.color ?? AppColors.primary).withAlpha(28),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
            ),
            child: Icon(
              Icons.timer_outlined,
              size: 20,
              color: course?.color ?? AppColors.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.cardTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(when, style: AppTextStyles.caption),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            DateFormatter.duration(session.minutes),
            style: AppTextStyles.cardTitle,
          ),
        ],
      ),
    );
  }
}
