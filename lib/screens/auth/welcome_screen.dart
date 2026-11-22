import 'package:flutter/material.dart';

import '../../app_routes.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Welcome')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.pushNamed(context, AppRoutes.main),
          child: const Text('Enter app'),
        ),
      ),
    );
  }
}
