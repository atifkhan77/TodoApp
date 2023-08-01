import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ndialog/ndialog.dart';
import 'package:todo_app/Screens/todo_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  var fullNameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmController = TextEditingController();

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
                controller: fullNameController,
                decoration: InputDecoration(hintText: 'Name'),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(hintText: 'Email'),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(hintText: 'Password'),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: confirmController,
                obscureText: true,
                decoration: InputDecoration(hintText: 'Confirm Password'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  var fullName = fullNameController.text.trim();
                  var email = emailController.text.trim();
                  var password = passwordController.text.trim();
                  var confirm = confirmController.text.trim();

                  if (fullName.isEmpty ||
                      email.isEmpty ||
                      password.isEmpty ||
                      confirm.isEmpty) {
                    Fluttertoast.showToast(msg: 'Please fill all the fields');
                    return;
                  }

                  if (password.length < 6) {
                    Fluttertoast.showToast(
                        msg: 'Password should be at least 6 characters');
                    return;
                  }

                  if (password != confirm) {
                    Fluttertoast.showToast(msg: 'Passwords do not match');
                    return;
                  }

                  ProgressDialog progressDialog = ProgressDialog(
                    context,
                    title: const Text('Signing up'),
                    message: const Text('Please wait'),
                  );

                  progressDialog.show();
                  try {
                    FirebaseAuth auth = FirebaseAuth.instance;
                    UserCredential userCredential =
                        await auth.createUserWithEmailAndPassword(
                            email: email, password: password);

                    if (userCredential.user != null) {
                      // Store in realtime database (To learn).

                      Fluttertoast.showToast(msg: 'Successfully registered');
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => ToDoScreen(),
                        ),
                      );
                    } else {
                      Fluttertoast.showToast(msg: 'Signup failed!');
                    }

                    progressDialog.dismiss();
                  } on FirebaseAuthException catch (e) {
                    progressDialog.dismiss();

                    if (e.code == 'email-already-in-use') {
                      Fluttertoast.showToast(msg: 'Email already in use');
                    } else if (e.code == 'weak-password') {
                      Fluttertoast.showToast(msg: 'Weak password');
                    }
                  } catch (e) {
                    Fluttertoast.showToast(msg: 'Something went wrong');
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
