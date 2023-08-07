import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth/cloud.dart';
import 'auth/firebaseAdd.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? file;
  String? imgUrl;
  FilePickerResult? result;
  bool? isShowfileImage = true;
  String? imgeUrl;
  String userEmail = FirebaseAuth.instance.currentUser!.email.toString();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
          future: FirebaseAdd.getUserEmailUrl(
            userEmail: userEmail.trim(),
          ),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.connectionState == ConnectionState.none) {
              return const Text('return no data');
            } else if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                return SizedBox(
                    height: 250,
                    width: double.infinity,
                    child: ListView.separated(
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 80),
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    debugPrint(
                                        'CURRENT USER ID ARE: ${FirebaseAuth.instance.currentUser!.uid}');
                                    result =
                                        await FilePicker.platform.pickFiles();
                                    file = File(
                                      result!.files.single.path.toString(),
                                    );
                                    imgUrl =
                                        await CloudFirebaseStorage.uploadImage(
                                      file!,
                                      DateTime.now()
                                          .millisecondsSinceEpoch
                                          .toString(),
                                    );
                                    await FirebaseFirestore.instance
                                        .collection('User')
                                        .doc(userEmail)
                                        .update({'url': imgUrl});
                                    setState(() {
                                      isShowfileImage = true;
                                    });
                                  },
                                  child: isShowfileImage == true
                                      ? SizedBox(
                                          height: 120,
                                          width: 120,
                                          child: ClipOval(
                                            child: Container(
                                              height: 50,
                                              width: 50,
                                              child: CircleAvatar(
                                                backgroundImage: NetworkImage(
                                                  snapshot.data!.docs[index]
                                                      ['url'],
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      : const CircularProgressIndicator(),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  snapshot.data!.docs[index]['name'],
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  snapshot.data!.docs[index]['email'],
                                  style: const TextStyle(
                                      fontSize: 8, color: Colors.blue),
                                ),
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const Center(
                              child: CircularProgressIndicator());
                        },
                        itemCount: snapshot.data!.docs.length));
              }
            }
            debugPrint(
                'THe DATA ARE AVAALIABLE:${snapshot.connectionState == ConnectionState.done}');
            return Center(
              child: Text(
                snapshot.data!.docs[0]['email'].toString(),
              ),
            );
          },
        ),
      ),
    );
  }
}
