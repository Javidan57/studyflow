import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key, this.onSelectTab});

  final ValueChanged<int>? onSelectTab;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Study history')),
      body: Center(
        child: const Text('Coming soon'),
      ),
    );
  }
}
