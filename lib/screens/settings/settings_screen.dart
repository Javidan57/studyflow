import 'package:flutter/material.dart';

import '../../app_routes.dart';
import '../../data/app_settings.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/app_buttons.dart';
import '../../widgets/app_dialogs.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Future<void> _logOut() async {
    final confirmed = await AppDialogs.confirm(
      context,
      title: 'Log out?',
      message: 'You will return to the welcome screen.',
      confirmLabel: 'Log out',
    );
    if (!confirmed || !mounted) return;
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.welcome,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: AppSpacing.screenPadding,
        children: [
          const _ProfileCard(),
          const SizedBox(height: AppSpacing.lg),
          const Text('FOCUS TIMER', style: AppTextStyles.label),
          _MinutesSlider(
            label: 'Focus length',
            value: AppSettings.focusMinutes,
            min: 5,
            max: 60,
            divisions: 11,
            onChanged: (value) {
              setState(() {
                AppSettings.focusMinutes = value;
              });
            },
          ),
          _MinutesSlider(
            label: 'Short break',
            value: AppSettings.shortBreakMinutes,
            min: 1,
            max: 15,
            divisions: 14,
            onChanged: (value) {
              setState(() {
                AppSettings.shortBreakMinutes = value;
              });
            },
          ),
          _MinutesSlider(
            label: 'Long break',
            value: AppSettings.longBreakMinutes,
            min: 5,
            max: 30,
            divisions: 5,
            onChanged: (value) {
              setState(() {
                AppSettings.longBreakMinutes = value;
              });
            },
          ),
          const SizedBox(height: AppSpacing.md),
          const Text('NOTIFICATIONS', style: AppTextStyles.label),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Deadline reminders'),
            subtitle: const Text('One day before a task is due'),
            value: AppSettings.deadlineReminders,
            onChanged: (value) {
              setState(() {
                AppSettings.deadlineReminders = value;
              });
            },
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Timer end alert'),
            subtitle: const Text('When a focus session or break ends'),
            value: AppSettings.timerAlerts,
            onChanged: (value) {
              setState(() {
                AppSettings.timerAlerts = value;
              });
            },
          ),
          const SizedBox(height: AppSpacing.lg),
          SecondaryButton(
            label: 'Log out',
            icon: Icons.logout,
            color: AppColors.danger,
            onPressed: _logOut,
          ),
        ],
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radius),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          ClipOval(
            child: Image.network(
              AppSettings.avatarUrl,
              width: 64,
              height: 64,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 64,
                  height: 64,
                  color: AppColors.primaryLight,
                  child: const Icon(Icons.person, color: AppColors.primary),
                );
              },
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppSettings.userName,
                  style: AppTextStyles.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  AppSettings.email,
                  style: AppTextStyles.bodyMuted,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MinutesSlider extends StatelessWidget {
  const _MinutesSlider({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.onChanged,
  });

  final String label;
  final int value;
  final int min;
  final int max;
  final int divisions;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: AppSpacing.sm),
          child: Row(
            children: [
              Expanded(child: Text(label, style: AppTextStyles.body)),
              Text('$value min', style: AppTextStyles.cardTitle),
            ],
          ),
        ),
        Slider(
          value: value.toDouble(),
          min: min.toDouble(),
          max: max.toDouble(),
          divisions: divisions,
          label: '$value min',
          onChanged: (newValue) => onChanged(newValue.round()),
        ),
      ],
    );
  }
}
