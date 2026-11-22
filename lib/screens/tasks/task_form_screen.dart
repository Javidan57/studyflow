import 'package:flutter/material.dart';

import '../../models/task.dart';

class TaskFormScreen extends StatelessWidget {
  const TaskFormScreen({super.key, this.task, this.initialCourseId});

  final Task? task;
  final String? initialCourseId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New task')),
      body: Center(
        child: const Text('Coming soon'),
      ),
    );
  }
}
