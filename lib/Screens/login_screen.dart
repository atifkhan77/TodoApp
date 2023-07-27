import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:todo_app/Screens/signup_screen.dart';
import 'package:todo_app/Screens/todo_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Function to check if a user is registered
  Future<bool> _isUserRegistered(String email) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password:
            '', // An empty password is used just for checking user existence.
      );
      return userCredential.user != null;
    } catch (e) {
      return false;
    }
  }

  Future<void> _handleLogin() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Fluttertoast.showToast(msg: 'Email or password is empty!');
      return;
    }

    // Check if the user is registered
    bool isRegistered = await _isUserRegistered(email);
    if (!isRegistered) {
      Fluttertoast.showToast(
          msg: 'User not registered. Please register first.');
      return;
    }

    try {
      // User logged in successfully, navigate to ToDoScreen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => ToDoScreen(),
        ),
      );
    } catch (e) {
      debugPrint('Login error: $e');
      // Display error message to the user based on the specific exception
      Fluttertoast.showToast(
        msg: 'Login failed. Please check your email and password.',
      );
    }
  }

  Future<void> _handleRegistration() async {
    // Navigate to the SignupScreen for registration
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SignupScreen(),
      ),
    );

    try {
      // User registered successfully, navigate to ToDoScreen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const ToDoScreen(),
        ),
      );
    } catch (e) {
      // Display error message to the user based on the specific exception
      Fluttertoast.showToast(
        msg: 'Registration failed. Please try again later.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Screen'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                controller: _emailController,
                decoration: InputDecoration(hintText: 'Email'),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(hintText: 'Password'),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: _handleLogin,
                child: const Text('Login'),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Not registered yet? '),
                  TextButton(
                    onPressed: _handleRegistration,
                    child: const Text('Register Now'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
