import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:todo_app/CRUD/servicesTodo.dart';
import 'package:todo_app/Screens/login_screen.dart';
import 'package:todo_app/Screens/update_task_screen.dart';
import 'package:todo_app/Screens/add_task_screen.dart';

class ToDoScreen extends StatefulWidget {
  final String userId;

  const ToDoScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<ToDoScreen> createState() => _ToDoScreenState();
}

class _ToDoScreenState extends State<ToDoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
        actions: [
          IconButton(
            onPressed: () async {
              FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => LoginScreen(),
                ),
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddTaskScreen(
                userId: widget.userId,
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      // ignore: avoid_print

      body: StreamBuilder<List<TodoVars>>(
        stream: TodoService.fetchTodos(widget.userId),
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
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        _updateTodo(context, todo);
                      },
                      icon: const Icon(Icons.edit),
                    ),
                    IconButton(
                      onPressed: () {
                        _deleteTodo(context, todo);
                      },
                      icon: const Icon(Icons.delete),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _updateTodo(BuildContext context, TodoVars todo) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => UpdateTodoScreen(todo: todo),
      ),
    );
  }

  void _deleteTodo(BuildContext context, TodoVars todo) async {
    try {
      await TodoService.deleteTodo(todo.id);
      Fluttertoast.showToast(msg: 'Todo deleted successfully');
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error deleting todo: $e');
    }
  }
}
