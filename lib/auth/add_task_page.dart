import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddTaskPage extends StatefulWidget {
  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  String selectedStatus = 'Assigned';
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _clientController = TextEditingController();

  // Reference to the Firestore collection
  final CollectionReference jobCollection = FirebaseFirestore.instance.collection('job');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Task'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Task Title',
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
              ),
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedStatus,
              onChanged: (value) {
                setState(() {
                  selectedStatus = value!;
                });
              },
              items: ['Assigned'].map((status) {
                return DropdownMenuItem<String>(
                  value: status,
                  child: Text(status),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'Status',
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _clientController,
              decoration: InputDecoration(
                labelText: 'Client',
              ),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // Save task to Firestore
                saveTaskToFirestore();
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                primary: Colors.blue[800],
                textStyle: TextStyle(fontSize: 18, color: Colors.red), // Set text color to white
               
              ),
              child: Text('Save Task'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> saveTaskToFirestore() async {
    try {
      await jobCollection.add({
        'title': _titleController.text,
        'description': _descriptionController.text,
        'status': selectedStatus,
        'client': _clientController.text,
      });

      // Task saved successfully, navigate back
      String successfullyMessage = 'successfully saved task';
      
      // Show success message using a snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(successfullyMessage),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.of(context).pop();
    } catch (e) {
      print('Error saving task: $e');
      // Handle error (show a snackbar, dialog, etc.)
      String errorMessage = 'Error saving task';
      
      // Show error message using a snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
