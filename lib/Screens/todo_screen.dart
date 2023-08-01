import 'package:flutter/material.dart';
import 'package:todo_app/Screens/signup_screen.dart';
import 'package:todo_app/Screens/update_task_screen.dart';
import '../CRUD/servicesTodo.dart';
import 'add_task_screen.dart';

class ToDoScreen extends StatefulWidget {
  const ToDoScreen({Key? key}) : super(key: key);

  @override
  State<ToDoScreen> createState() => _ToDoScreenState();
}

class _ToDoScreenState extends State<ToDoScreen> {
  List<TodoVars> todos = [];

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  void _loadTodos() {
    try {
      Stream<List<TodoVars>> fetchedTodos =
          TodoService.fetchTodos() as Stream<List<TodoVars>>;
      setState(() {
        todos = fetchedTodos as List<TodoVars>;
      });
    } catch (e) {
      debugPrint('Error fetching todos: $e');
    }
  }

  void _updateTodo(TodoVars todo) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => UpdateTodoScreen(todo: todo),
      ),
    );
  }

  void _deleteTodo(TodoVars todo) async {
    try {
      await TodoService.deleteTodo(todo.id);
      debugPrint('Todo deleted successfully');
      _loadTodos();
    } catch (e) {
      debugPrint('Error deleting todo: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const SignupScreen(),
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
              builder: (context) => const AddTaskScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
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
                    _updateTodo(todo);
                  },
                  icon: const Icon(Icons.edit),
                ),
                IconButton(
                  onPressed: () {
                    _deleteTodo(todo);
                    _loadTodos();
                  },
                  icon: const Icon(Icons.delete),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
