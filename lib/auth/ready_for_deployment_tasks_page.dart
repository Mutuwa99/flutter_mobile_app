// assigned_tasks_page.dart
import 'package:flutter/material.dart';

class ReadyForDeploymentTasksPage extends StatelessWidget {
  final List<String> assignedTasks = ['Task 4', 'Task 5', 'Task 6']; // Add your assigned tasks here

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Assigned Tasks'),
        backgroundColor: Colors.grey,
      ),
      body: ListView.builder(
        itemCount: assignedTasks.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(assignedTasks[index]),
            subtitle: Text('Status: Assigned'),
            trailing: ElevatedButton(
              onPressed: () {
                // Add logic to change status
                print('Change status button pressed for ${assignedTasks[index]}');
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.grey[800],
                textStyle: TextStyle(fontSize: 12),
              ),
              child: Text('Change Status'),
            ),
          );
        },
      ),
    );
  }
}
