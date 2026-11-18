import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

class PriorityBadge extends StatelessWidget {
  const PriorityBadge({super.key, required this.priority});

  final String priority;

  static Color colorFor(String priority) {
    if (priority == 'High') return AppColors.priorityHigh;
    if (priority == 'Low') return AppColors.priorityLow;
    return AppColors.priorityMedium;
  }

  @override
  Widget build(BuildContext context) {
    final color = colorFor(priority);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
        border: Border.all(color: color),
      ),
      child: Text(priority, style: AppTextStyles.caption.copyWith(color: color)),
    );
  }
}
