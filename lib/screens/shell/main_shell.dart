import 'package:flutter/material.dart';

import '../courses/courses_screen.dart';
import '../focus/focus_screen.dart';
import '../history/history_screen.dart';
import '../home/home_screen.dart';
import '../tasks/tasks_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  void _selectTab(int index) {
    setState(() {
      _index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: [
          HomeScreen(onSelectTab: _selectTab),
          TasksScreen(onSelectTab: _selectTab),
          FocusScreen(onSelectTab: _selectTab),
          CoursesScreen(onSelectTab: _selectTab),
          HistoryScreen(onSelectTab: _selectTab),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: _selectTab,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.checklist_outlined),
            selectedIcon: Icon(Icons.checklist),
            label: 'Tasks',
          ),
          NavigationDestination(
            icon: Icon(Icons.timer_outlined),
            selectedIcon: Icon(Icons.timer),
            label: 'Focus',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book),
            label: 'Courses',
          ),
          NavigationDestination(
            icon: Icon(Icons.history),
            selectedIcon: Icon(Icons.history_toggle_off),
            label: 'History',
          ),
        ],
      ),
    );
  }
}
