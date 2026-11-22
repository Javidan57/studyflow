import 'package:flutter/material.dart';

import '../../app_routes.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/app_buttons.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusLarge),
                        child: Image.asset(
                          'assets/images/studyflow_logo.png',
                          width: 140,
                          height: 140,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      const Text('StudyFlow', style: AppTextStyles.display),
                      const SizedBox(height: AppSpacing.sm),
                      const Text(
                        'Plan your courses, track every deadline and study '
                        'in focused sessions.',
                        style: AppTextStyles.bodyMuted,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      PrimaryButton(
                        label: 'Log in',
                        onPressed: () {
                          Navigator.pushNamed(context, AppRoutes.login);
                        },
                      ),
                      const SizedBox(height: AppSpacing.md),
                      SecondaryButton(
                        label: 'Create account',
                        onPressed: () {
                          Navigator.pushNamed(context, AppRoutes.signup);
                        },
                      ),
                      const SizedBox(height: AppSpacing.md),
                      const Text(
                        'Works offline. Your data stays on this device.',
                        style: AppTextStyles.caption,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
