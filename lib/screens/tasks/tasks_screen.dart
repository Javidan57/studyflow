import 'package:flutter/material.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key, required this.onSelectTab});

  final ValueChanged<int> onSelectTab;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tasks')),
      body: Center(
        child: const Text('Coming soon'),
      ),
    );
  }
}
