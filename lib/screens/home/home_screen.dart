import 'package:flutter/material.dart';

import '../../app_routes.dart';
import '../../data/app_settings.dart';
import '../../data/session_data.dart';
import '../../data/task_data.dart';
import '../../models/task.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';
import '../../utils/date_formatter.dart';
import '../../widgets/app_buttons.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/section_header.dart';
import '../../widgets/stat_tile.dart';
import '../../widgets/task_card.dart';
import '../tasks/task_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.onSelectTab});

  final ValueChanged<int> onSelectTab;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 18) return 'Good afternoon';
    return 'Good evening';
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

  Future<void> _openSettings() async {
    await Navigator.pushNamed(context, AppRoutes.settings);
    if (!mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final pending = TaskData.pending;
    final dueToday =
        pending.where((task) => DateFormatter.daysFromToday(task.dueDate) == 0);
    final upcoming = pending.take(3).toList();
    final focusedToday = SessionData.minutesOn(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: const Text('StudyFlow'),
        actions: [
          IconButton(
            tooltip: 'Settings',
            icon: const Icon(Icons.settings_outlined),
            onPressed: _openSettings,
          ),
        ],
      ),
      body: ListView(
        padding: AppSpacing.screenPadding,
        children: [
          Text(
            '$_greeting, ${AppSettings.userName}',
            style: AppTextStyles.heading,
          ),
          Text(
            DateFormatter.fullDate(DateTime.now()),
            style: AppTextStyles.bodyMuted,
          ),
          const SizedBox(height: AppSpacing.md),
          const _BannerCard(),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: StatTile(
                  value: '${dueToday.length}',
                  label: 'Due today',
                  icon: Icons.event_outlined,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: StatTile(
                  value: '${pending.length}',
                  label: 'Pending',
                  icon: Icons.checklist,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: StatTile(
                  value: DateFormatter.duration(focusedToday),
                  label: 'Focused today',
                  icon: Icons.timer_outlined,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          PrimaryButton(
            label: 'Start focus session',
            icon: Icons.play_arrow,
            onPressed: () => widget.onSelectTab(2),
          ),
          const SizedBox(height: AppSpacing.lg),
          SectionHeader(
            title: 'Upcoming deadlines',
            actionLabel: 'See all',
            onAction: () => widget.onSelectTab(1),
          ),
          const SizedBox(height: AppSpacing.sm),
          if (upcoming.isEmpty)
            const EmptyState(
              icon: Icons.celebration_outlined,
              message: 'No pending tasks. Enjoy the free time!',
            )
          else
            for (final task in upcoming)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: TaskCard(
                  task: task,
                  onTap: () => _openTask(task),
                  onToggleDone: (value) {
                    setState(() {
                      task.isDone = value ?? false;
                    });
                  },
                ),
              ),
        ],
      ),
    );
  }
}

class _BannerCard extends StatelessWidget {
  const _BannerCard();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSpacing.radius),
      child: SizedBox(
        height: 140,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              AppSettings.bannerUrl,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return Container(
                  color: AppColors.primaryLight,
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(color: AppColors.primary);
              },
            ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Color(0xCC1F2333), Color(0x001F2333)],
                ),
              ),
            ),
            Positioned(
              left: AppSpacing.md,
              right: AppSpacing.md,
              bottom: AppSpacing.md,
              child: Text(
                'Small focused sessions add up. Plan one for today.',
                style: AppTextStyles.title.copyWith(
                  color: AppColors.textOnPrimary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
