import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class TodoVars {
  String id;
  String title;
  String description;

  TodoVars({
    required this.id,
    required this.title,
    required this.description,
  });
}

class TodoService {
  static CollectionReference todosRef =
      FirebaseFirestore.instance.collection('todos');

  static Future<void> addTodo(TodoVars todo) async {
    try {
      await todosRef.add({
        'title': todo.title,
        'description': todo.description,
      });
      debugPrint('Todo added successfully');
    } catch (e) {
      debugPrint('Error adding todo: $e');
    }
  }

  static Stream<List<TodoVars>> fetchTodos() {
    try {
      return todosRef.snapshots().map((snapshot) {
        return snapshot.docs.map((doc) {
          return TodoVars(
            id: doc.id,
            title: doc['title'],
            description: doc['description'],
          );
        }).toList();
      });
    } catch (e) {
      debugPrint('Error fetching todos: $e');
      return Stream.value([]);
    }
  }

  static Future<void> updateTodo(TodoVars todo) async {
    try {
      await todosRef.doc(todo.id).update({
        'title': todo.title,
        'description': todo.description,
      });
      debugPrint('Todo updated successfully');
    } catch (e) {
      debugPrint('Error updating todo: $e');
    }
  }

  static Future<void> deleteTodo(String todoId) async {
    try {
      await todosRef.doc(todoId).delete();
      debugPrint('Todo deleted successfully');
    } catch (e) {
      debugPrint('Error deleting todo: $e');
    }
  }
}
