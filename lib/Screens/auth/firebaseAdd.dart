import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseAdd {
  static Future<void> addUserData(
      {required String name,
      String? profileUrl = '',
      required String userEmail}) async {
    try {
      await FirebaseFirestore.instance
          .collection('User')
          .doc(FirebaseAuth.instance.currentUser!.email)
          .set(
        {
          'name': name,
          'email': FirebaseAuth.instance.currentUser!.email,
          'url': profileUrl
        },
      );
    } catch (e) {
      debugPrint('inside Adduser: ${e.toString()}');
    }
  }

  static Future<QuerySnapshot<Map<String, dynamic>>> getUserEmailUrl(
      {required String userEmail}) {
    return FirebaseFirestore.instance
        .collection('User')
        .where('email', isEqualTo: userEmail)
        .get();
  }
}
