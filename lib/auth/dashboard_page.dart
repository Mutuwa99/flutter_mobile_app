import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'add_task_page.dart';
import 'completed_tasks_page.dart';
import 'assigned_tasks_page.dart';
import 'ready_for_deployment_tasks_page.dart';
import 'inprogress_tasks_page.dart';
import 'login_page.dart';
import '/widgets/bottom_navigation.dart';

class DashboardPage extends StatefulWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int completedTasks = 0;
  int assignedTasks = 0;
  int readyForDeploymentTasks = 0;

  @override
  void initState() {
    super.initState();
    _fetchTaskCounts();
  }

  Future<void> _fetchTaskCounts() async {
    try {
      QuerySnapshot completedSnapshot =
          await widget._firestore.collection('job').where('status', isEqualTo: 'Completed').get();
      QuerySnapshot assignedSnapshot =
          await widget._firestore.collection('job').where('status', isEqualTo: 'Assigned').get();
      QuerySnapshot readyForDeploymentSnapshot =
          await widget._firestore.collection('job').where('status', isEqualTo: 'Ready for Deployment').get();

      setState(() {
        completedTasks = completedSnapshot.size;
        assignedTasks = assignedSnapshot.size;
        readyForDeploymentTasks = readyForDeploymentSnapshot.size;
      });
    } catch (e) {
      print('Error fetching task counts: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Dashboard'),
        ),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await widget._auth.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              // Implement profile page navigation
              // Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: FutureBuilder<User?>(
          future: Future.value(widget._auth.currentUser),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              User? user = snapshot.data;
              return ListView(
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.grey,
                          backgroundImage: AssetImage('assets/me.png'), // Add the path to your image
                        ),
                        SizedBox(height: 10),
                        Text(
                          user?.displayName ?? 'Mutuwa',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        SizedBox(height: 5),
                        Text(
                          user?.email ?? 'user@example.com',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    title: Text('Settings'),
                    onTap: () {
                      // Handle drawer item tap
                      // Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage()));
                    },
                  ),
                  ListTile(
                    title: Text('Help'),
                    onTap: () {
                      // Handle drawer item tap
                      // Navigator.push(context, MaterialPageRoute(builder: (context) => HelpPage()));
                    },
                  ),
                ],
              );
            }
          },
        ),
      ),
      body: Column(
        children: [
          _buildTaskSection(context, 'Completed Tasks', Colors.green, CompletedTasksPage(), Icons.check, completedTasks),
          _buildTaskSection(context, 'Assigned Tasks', Colors.grey, AssignedTasksPage(), Icons.assignment, assignedTasks),
          _buildTaskSection(
              context, 'Ready for Deployment Tasks', Colors.blue, ReadyForDeploymentTasksPage(), Icons.done_all, readyForDeploymentTasks),
          SizedBox(height: 20), // Add spacing
          _buildBeautifulDashboard(),
        ],
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

  Widget _buildTaskSection(BuildContext context, String title, Color color, Widget page, IconData icon, int taskCount) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        },
        child: Card(
          elevation: 10,
          color: color,
          child: Container(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'View Tasks',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    icon,
                    color: Colors.white,
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Text(
                      taskCount.toString(),
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBeautifulDashboard() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          Divider(
            thickness: 4, // Set the thickness of the divider
            color: Colors.grey[300],
            height: 20, // Set the height of the divider
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildYearlyDashboardCard('2022', Icons.calendar_today, Colors.orange, 30),
              _buildYearlyDashboardCard('2023', Icons.calendar_today, Colors.purple, 15),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildYearlyDashboardCard(String year, IconData icon, Color color, int count) {
    return Card(
      elevation: 10,
      color: color,
      child: Container(
        width: 150, // Set a fixed width for the card
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40,
              color: Colors.white,
            ),
            SizedBox(height: 20),
            Text(
              'Year $year',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 5),
            Text(
              'Count: $count',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: DashboardPage(),
  ));
}
