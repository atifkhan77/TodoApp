import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _imageFile;
  String? _profilePicUrl;
  String? _userId;

  @override
  void initState() {
    super.initState();
    _userId = FirebaseAuth.instance.currentUser?.uid;
    _loadProfilePicUrl();
  }

  Future<void> _loadProfilePicUrl() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(_userId)
              .get();
      if (userSnapshot.exists) {
        setState(() {
          _profilePicUrl = userSnapshot.get('profilePicUrl') as String?;
        });
      }
    } catch (e) {
      print('Error loading profile picture: $e');
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadImage(File? imageFile) async {
    if (imageFile == null) return null;

    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('profile_pics')
          .child(fileName);
      await ref.putFile(imageFile);
      return await ref.getDownloadURL();
    } catch (e) {
      debugPrint('Error uploading image: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Screen'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back),
            color: Colors.white,
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.grey,
              backgroundImage: _imageFile != null
                  ? FileImage(_imageFile!)
                  : (_profilePicUrl != null
                      ? NetworkImage(_profilePicUrl!) // Explicit cast to String
                      : Image.asset('assets/empty_image.png').image),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Upload Profile Picture'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String? imageUrl = await _uploadImage(_imageFile);
                if (imageUrl != null) {
                  // Save the image URL to Firebase Firestore
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(_userId)
                      .update({'profilePicUrl': imageUrl});
                  setState(() {
                    _profilePicUrl = imageUrl;
                  });
                }
              },
              child: const Text('Save Profile Picture'),
            ),
          ],
        ),
      ),
    );
  }
}
