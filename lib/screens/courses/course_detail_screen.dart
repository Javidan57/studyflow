import 'package:flutter/material.dart';

import '../../models/course.dart';

class CourseDetailScreen extends StatelessWidget {
  const CourseDetailScreen({super.key, required this.course});

  final Course course;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Course details')),
      body: Center(
        child: const Text('Coming soon'),
      ),
    );
  }
}
