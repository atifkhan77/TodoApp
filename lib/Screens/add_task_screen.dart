import 'package:flutter/material.dart';
import '../CRUD/createTodo.dart'; 

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({Key? key}) : super(key: key);

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController _taskTitleController = TextEditingController();

  @override
  void dispose() {
    _taskTitleController
        .dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Task Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _taskTitleController,
              decoration: const InputDecoration(hintText: 'Enter Task'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                String taskTitle = _taskTitleController.text.trim();
                if (taskTitle.isNotEmpty) {
                  TodoAdd.addTodo(
                      taskTitle); 
                  Navigator.pop(
                      context); 
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Please enter a task'),
                      duration:
                          const Duration(seconds: 2), 
                    ),
                  );
                }
              },
              child: const Text('Save'),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
