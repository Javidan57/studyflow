import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.onSelectTab});

  final ValueChanged<int> onSelectTab;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: const Text('Coming soon'),
      ),
    );
  }
}
