import 'package:flutter/material.dart';

import '../../app_routes.dart';
import '../../data/app_settings.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_theme.dart';
import '../../utils/validators.dart';
import '../../widgets/app_buttons.dart';
import '../../widgets/app_dialogs.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  String _name = '';
  String _email = '';
  bool _isPasswordHidden = true;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _createAccount() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    AppSettings.userName = _name.split(' ').first;
    AppSettings.email = _email;

    await AppDialogs.success(
      context,
      title: 'Account created',
      message: 'Welcome to StudyFlow, $_name!',
    );
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.main,
      (route) => false,
    );
  }

  Widget _visibilityButton() {
    return IconButton(
      tooltip: _isPasswordHidden ? 'Show password' : 'Hide password',
      icon: Icon(_isPasswordHidden ? Icons.visibility_off : Icons.visibility),
      onPressed: () {
        setState(() {
          _isPasswordHidden = !_isPasswordHidden;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create account')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('Create your account', style: AppTextStyles.heading),
                const SizedBox(height: AppSpacing.lg),
                TextFormField(
                  textCapitalization: TextCapitalization.words,
                  decoration: AppTheme.input(
                    label: 'Full name',
                    icon: Icons.person_outline,
                  ),
                  validator: (value) => Validators.requiredField(value, 'Name'),
                  onSaved: (value) => _name = value!.trim(),
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: AppTheme.input(
                    label: 'Email',
                    icon: Icons.email_outlined,
                  ),
                  validator: Validators.email,
                  onSaved: (value) => _email = value!.trim(),
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
                    suffix: _visibilityButton(),
                  ),
                  validator: Validators.password,
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  obscureText: _isPasswordHidden,
                  autocorrect: false,
                  enableSuggestions: false,
                  decoration: AppTheme.input(
                    label: 'Confirm password',
                    icon: Icons.lock_outline,
                  ),
                  validator: (value) => Validators.confirmPassword(
                    value,
                    _passwordController.text,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                PrimaryButton(
                  label: 'Create account',
                  onPressed: _createAccount,
                ),
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    const Text(
                      'Already have an account?',
                      style: AppTextStyles.bodyMuted,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                          context,
                          AppRoutes.login,
                        );
                      },
                      child: const Text('Log in'),
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
