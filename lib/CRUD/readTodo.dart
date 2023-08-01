import 'package:flutter/material.dart';
import 'package:todo_app/CRUD/servicesTodo.dart';

class ReadTodoScreen extends StatelessWidget {
  const ReadTodoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
      ),
      body: StreamBuilder<List<TodoVars>>(
        stream: TodoService.fetchTodos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            debugPrint('Error fetching todos: ${snapshot.error}');
            return const Center(
              child: Text('Error fetching todos.'),
            );
          }

          final List<TodoVars> todos = snapshot.data ?? [];

          if (todos.isEmpty) {
            return const Center(
              child: Text('No todos available.'),
            );
          }

          return ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              TodoVars todo = todos[index];
              return ListTile(
                title: Text(todo.title),
                subtitle: Text(todo.description),
              );
            },
          );
        },
      ),
    );
  }
}
