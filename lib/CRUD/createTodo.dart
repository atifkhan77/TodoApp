import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TodoAdd {
  static Future<void> addTodo(String title, String userId) async {
    try {
      CollectionReference todosRef =
          FirebaseFirestore.instance.collection('todos');

      await todosRef.add({
        'title': title,
        'description': '',
        'userId': userId,
        'createdAt': FieldValue.serverTimestamp(),
      });
      Fluttertoast.showToast(msg: 'Todo added successfully');
    } catch (e) {
      if (e is FirebaseException) {
        String errorMessage = 'Failed to add todo: ${e.message}';
        Fluttertoast.showToast(msg: errorMessage);
      } else {
        Fluttertoast.showToast(msg: 'Failed to add todo');
      }
    }
  }
}
