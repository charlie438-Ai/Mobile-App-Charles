import 'package:flutter/material.dart';
import '../models/student.dart';
import 'task_list_screen.dart';

class ProfileScreen extends StatelessWidget {
  final Student student = Student(
    name: 'Elikem Awuttey',
    studentId: '10912345',
    programme: 'Computer Science',
    level: 300,
  );

  ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Profile'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                child: Text(
                  student.name.substring(0, 1).toUpperCase(),
                  style: const TextStyle(fontSize: 40),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text('Name: ${student.name}', style: const TextStyle(fontSize: 18)),
                      const SizedBox(height: 8),
                      Text('ID: ${student.studentId}', style: const TextStyle(fontSize: 18)),
                      const SizedBox(height: 8),
                      Text('Programme: ${student.programme}', style: const TextStyle(fontSize: 18)),
                      const SizedBox(height: 8),
                      Text('Level: ${student.level}', style: const TextStyle(fontSize: 18)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Edit Profile functionality
                },
                child: const Text('Edit Profile'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TaskListScreen()),
                  );
                },
                child: const Text('View Tasks'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
