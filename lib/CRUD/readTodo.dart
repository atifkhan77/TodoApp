import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:todo_app/CRUD/servicesTodo.dart';

class ReadTodoScreen extends StatefulWidget {
  const ReadTodoScreen({Key? key}) : super(key: key);

  @override
  State<ReadTodoScreen> createState() => _ReadTodoScreenState();
}

class _ReadTodoScreenState extends State<ReadTodoScreen> {
  List<TodoVars> todos = [];

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  void _loadTodos() async {
    try {
      List<TodoVars> fetchedTodos = await TodoService.fetchTodos();
      setState(() {
        todos = fetchedTodos.cast<TodoVars>();
      });
    } catch (e) {
      debugPrint('Error fetching todos: $e');
      Fluttertoast.showToast(
          msg: 'Error fetching todos. Please try again later.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
      ),
      body: todos.isEmpty
          ? const Center(
              child: Text('No todos available.'),
            )
          : ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                TodoVars todo = todos[index];
                return ListTile(
                  title: Text(todo.title),
                  subtitle: Text(todo.description),
                );
              },
            ),
    );
  }
}
