import 'package:flutter/material.dart';
import 'package:todo_app/CRUD/servicesTodo.dart';

import '../models/TodoModel.dart';

class DeleteTodoScreen extends StatefulWidget {
  final Todo todo;

  const DeleteTodoScreen({Key? key, required this.todo}) : super(key: key);

  @override
  State<DeleteTodoScreen> createState() => _DeleteTodoScreenState();
}

class _DeleteTodoScreenState extends State<DeleteTodoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delete Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Do you want to delete this task?',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                try {
                  await TodoService.deleteTodo(widget.todo.id);
                  print('Todo deleted successfully');
                  Navigator.of(context).pop();
                } catch (e) {
                  print('Error deleting todo: $e');
                }
              },
              child: const Text('Delete'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Go back to the previous screen
              },
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }
}
