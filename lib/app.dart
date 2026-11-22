import 'package:flutter/material.dart';

import 'app_routes.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/auth/welcome_screen.dart';
import 'screens/settings/settings_screen.dart';
import 'screens/shell/main_shell.dart';
import 'theme/app_theme.dart';

class StudyFlowApp extends StatelessWidget {
  const StudyFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StudyFlow',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: AppRoutes.welcome,
      routes: {
        AppRoutes.welcome: (context) => const WelcomeScreen(),
        AppRoutes.login: (context) => const LoginScreen(),
        AppRoutes.signup: (context) => const SignupScreen(),
        AppRoutes.main: (context) => const MainShell(),
        AppRoutes.settings: (context) => const SettingsScreen(),
      },
    );
  }
}
