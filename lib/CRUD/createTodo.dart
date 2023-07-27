import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TodoAdd {
  static Future<void> addTodo(String title) async {
    try {
      CollectionReference todosRef =
          FirebaseFirestore.instance.collection('todos');

      await todosRef.add({
        'title': title,
        'description': '', // You can add more fields if required
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Todo added successfully
      Fluttertoast.showToast(msg: 'Todo added successfully');
    } catch (e) {
      Fluttertoast.showToast(msg: 'not added');
    }
  }
}
