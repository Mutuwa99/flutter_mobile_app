// task_list_page.dart
import 'package:flutter/material.dart';

class TaskListPage extends StatelessWidget {
  final String title;
  final List<String> tasks;

  TaskListPage({required this.title, required this.tasks});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(tasks[index]),
            // Add functionality to update the status here if needed
          );
        },
      ),
    );
  }
}
