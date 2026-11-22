import 'package:flutter/material.dart';

import '../../app_routes.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_theme.dart';
import '../../utils/validators.dart';
import '../../widgets/app_buttons.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordHidden = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _logIn() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.main,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Log in')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('Welcome back', style: AppTextStyles.heading),
                const SizedBox(height: AppSpacing.xs),
                const Text(
                  'Log in to continue planning.',
                  style: AppTextStyles.bodyMuted,
                ),
                const SizedBox(height: AppSpacing.lg),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: AppTheme.input(
                    label: 'Email',
                    hint: 'name@sabanciuniv.edu',
                    icon: Icons.email_outlined,
                  ),
                  validator: Validators.email,
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _isPasswordHidden,
                  autocorrect: false,
                  enableSuggestions: false,
                  decoration: AppTheme.input(
                    label: 'Password',
                    icon: Icons.lock_outline,
                    suffix: IconButton(
                      tooltip: _isPasswordHidden
                          ? 'Show password'
                          : 'Hide password',
                      icon: Icon(
                        _isPasswordHidden
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordHidden = !_isPasswordHidden;
                        });
                      },
                    ),
                  ),
                  validator: Validators.password,
                ),
                const SizedBox(height: AppSpacing.lg),
                PrimaryButton(label: 'Log in', onPressed: _logIn),
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    const Text('No account?', style: AppTextStyles.bodyMuted),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                          context,
                          AppRoutes.signup,
                        );
                      },
                      child: const Text('Sign up'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
