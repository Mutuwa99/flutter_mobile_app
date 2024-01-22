import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_task_page.dart';
import '/widgets/bottom_navigation.dart';

class InprogressTasksPage extends StatefulWidget {
  @override
  _InprogressTasksPageState createState() => _InprogressTasksPageState();
}

class _InprogressTasksPageState extends State<InprogressTasksPage> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> _deleteTask(String taskId) async {
    try {
      await firestore.collection('job').doc(taskId).delete();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Task deleted successfully.'),
        backgroundColor: Colors.green,
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error deleting task: $e'),
        backgroundColor: Colors.red,
      ));
    }
  }

  Future<void> _editTask(String taskId, String title, String status) async {
    try {
      await firestore.collection('job').doc(taskId).update({
        'title': title,
        'status': status,
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Task edited successfully.'),
        backgroundColor: Colors.green,
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error editing task: $e'),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Assigned Tasks'),
        backgroundColor: Colors.blue,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore.collection('job').where('status', isEqualTo: 'Inprogress').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            List<QueryDocumentSnapshot> tasks = snapshot.data!.docs;

            return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                var task = tasks[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 5,
                    shadowColor: Colors.black,
                    color: Colors.grey[800], // Dark grey background
                    child: ListTile(
                      title: Text(
                        task['title'] ?? '',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      subtitle: Text(
                        'Client: ${task['client'] ?? ''}\nStatus: Inprogress',
                        style: TextStyle(color: Colors.white),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.white),
                            onPressed: () {
                              _showEditTaskModal(task.id, task['title'] ?? '', task['status'] ?? '');
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.white),
                            onPressed: () {
                              _deleteTask(task.id);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTaskPage()),
          );
        },
        backgroundColor: Colors.grey[800],
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigation(), // Use BottomNavigation here
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  void _showEditTaskModal(String taskId, String currentTitle, String currentStatus) {
    TextEditingController titleController = TextEditingController(text: currentTitle);
    String selectedStatus = currentStatus;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Edit Task',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: 'Title',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: DropdownButtonFormField(
                    value: selectedStatus,
                    items: ['Assigned', 'Inprogress', 'Completed']
                        .map((status) => DropdownMenuItem(
                              value: status,
                              child: Text(status),
                            ))
                        .toList(),
                    onChanged: (String? value) {
                      setState(() {
                        selectedStatus = value!;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Status',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      _editTask(taskId, titleController.text, selectedStatus);
                      Navigator.pop(context); 
                    },
                    style: ElevatedButton.styleFrom(
                        primary: Colors.blue, 
                        textStyle: TextStyle(color: Colors.white),
                      ),
                    child: Text('Save Changes'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
