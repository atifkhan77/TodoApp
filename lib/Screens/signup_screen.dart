import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ndialog/ndialog.dart';
import 'package:todo_app/Screens/todo_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  var fullNameConroller = TextEditingController();
  var emailConroller = TextEditingController();
  var passwordConroller = TextEditingController();
  var confirmConroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Signup Screen'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                controller: fullNameConroller,
                decoration: InputDecoration(hintText: 'Name'),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: emailConroller,
                decoration: InputDecoration(hintText: 'Email'),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: passwordConroller,
                obscureText: true,
                decoration: InputDecoration(hintText: 'Password'),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: confirmConroller,
                obscureText: true,
                decoration: InputDecoration(hintText: 'Confirm Password'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  var fullName = fullNameConroller.text.trim();
                  var email = emailConroller.text.trim();
                  var password = passwordConroller.text.trim();
                  var confirm = confirmConroller.text.trim();
                  if (fullName.isEmpty ||
                      email.isEmpty ||
                      password.isEmpty ||
                      confirm.isEmpty) {
                    Fluttertoast.showToast(msg: 'please fill all the fields');
                    return;
                  }
                  if (password.length < 6) {
                    Fluttertoast.showToast(
                        msg: 'password showld be minimium 6 characters');
                    return;
                  }
                  if (password != confirm) {
                    Fluttertoast.showToast(msg: 'password not matched');
                    return;
                  }
                  ProgressDialog progressDialog = ProgressDialog(
                    context,
                    title: const Text('signing up '),
                    message: const Text('Please wait'),
                  );

                  progressDialog.show();
                  try {
                    FirebaseAuth auth = FirebaseAuth.instance;
                    UserCredential userCredential =
                        await auth.createUserWithEmailAndPassword(
                            email: email, password: password);

                    if (userCredential.user != null) {
                      //store in realtime dataBase!!!(to learn)

                      Fluttertoast.showToast(msg: 'successfully register');
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => ToDoScreen(),
                        ),
                      );
                    } else {
                      Fluttertoast.showToast(msg: 'signup Failed!');
                    }

                    progressDialog.dismiss();
                  } on FirebaseAuthException catch (e) {
                    progressDialog.dismiss();

                    if (e.code == 'email-already-in-use') {
                      Fluttertoast.showToast(msg: 'Email already in use');
                    } else if (e.code == 'weak-password') {
                      Fluttertoast.showToast(msg: 'weak Password');
                    }
                  } catch (e) {
                    Fluttertoast.showToast(msg: 'something went wrong');
                  }
                },
                child: const Text('Sign Up'),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
