import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksString = prefs.getString('tasks');
    
    if (tasksString != null) {
      final List<dynamic> decodedTasks = jsonDecode(tasksString);
      setState(() {
        tasks = decodedTasks.map((task) => Task.fromJson(task)).toList();
      });
    } else {
      // Hardcoded list fallback
      setState(() {
        tasks = [
          Task(title: 'Assignment 1', courseCode: 'CS101', dueDate: DateTime.now().add(const Duration(days: 2))),
          Task(title: 'Project Proposal', courseCode: 'CS102', dueDate: DateTime.now().add(const Duration(days: 5))),
          Task(title: 'Midsem Exam', courseCode: 'CS103', dueDate: DateTime.now().add(const Duration(days: 10))),
        ];
      });
      _saveTasks();
    }
  }

  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedTasks = jsonEncode(tasks.map((task) => task.toJson()).toList());
    await prefs.setString('tasks', encodedTasks);
  }

  void _toggleTaskComplete(int index) {
    setState(() {
      tasks[index].isComplete = !tasks[index].isComplete;
    });
    _saveTasks();
  }

  void _showAddTaskDialog() {
    final titleController = TextEditingController();
    final courseCodeController = TextEditingController();
    DateTime? selectedDate;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Add New Task'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(labelText: 'Title'),
                  ),
                  TextField(
                    controller: courseCodeController,
                    decoration: const InputDecoration(labelText: 'Course Code'),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text(selectedDate == null 
                        ? 'No date selected' 
                        : DateFormat('dd/MM/yyyy').format(selectedDate!)),
                      const Spacer(),
                      TextButton(
                        onPressed: () async {
                          final pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100),
                          );
                          if (pickedDate != null) {
                            setDialogState(() {
                              selectedDate = pickedDate;
                            });
                          }
                        },
                        child: const Text('Select Date'),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    if (titleController.text.isNotEmpty && 
                        courseCodeController.text.isNotEmpty && 
                        selectedDate != null) {
                      setState(() {
                        tasks.add(Task(
                          title: titleController.text,
                          courseCode: courseCodeController.text,
                          dueDate: selectedDate!,
                        ));
                      });
                      _saveTasks();
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          }
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
      ),
      body: tasks.isEmpty
          ? const Center(child: Text('No tasks found.'))
          : ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return ListTile(
                  title: Text(task.title),
                  subtitle: Text('${task.courseCode} - ${DateFormat('dd/MM/yyyy').format(task.dueDate)}'),
                  trailing: Checkbox(
                    value: task.isComplete,
                    onChanged: (value) {
                      _toggleTaskComplete(index);
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
