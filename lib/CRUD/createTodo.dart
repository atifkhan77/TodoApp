import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TodoAdd {
  static Future<void> addTodo(String title, String userId) async {
    // Add userId argument
    try {
      CollectionReference todosRef =
          FirebaseFirestore.instance.collection('todos');

      await todosRef.add({
        'title': title,
        'description': '',
        'userId': userId, // Add userId to the data being saved
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Todo added successfully
      Fluttertoast.showToast(msg: 'Todo added successfully');
    } catch (e) {
      // Handle specific exceptions and show relevant error messages
      if (e is FirebaseException) {
        // You can handle different types of Firebase exceptions here
        String errorMessage = 'Failed to add todo: ${e.message}';
        Fluttertoast.showToast(msg: errorMessage);
      } else {
        // For other exceptions, show a generic error message
        Fluttertoast.showToast(msg: 'Failed to add todo');
      }
    }
  }
}
