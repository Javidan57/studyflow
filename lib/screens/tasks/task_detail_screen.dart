import 'package:flutter/material.dart';

import '../../models/task.dart';

class TaskDetailScreen extends StatelessWidget {
  const TaskDetailScreen({super.key, required this.task});

  final Task task;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Task details')),
      body: Center(
        child: const Text('Coming soon'),
      ),
    );
  }
}
