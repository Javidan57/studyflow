import 'package:flutter/material.dart';

class Course {
  Course({
    required this.id,
    required this.code,
    required this.name,
    required this.color,
  });

  final String id;
  final String code;
  final String name;
  final Color color;
}
