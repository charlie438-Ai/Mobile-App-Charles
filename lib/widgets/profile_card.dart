import 'package:flutter/material.dart';
import '../models/student.dart';

class ProfileCard extends StatelessWidget {
  final Student student;

  const ProfileCard({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Card(
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
    );
  }
}
