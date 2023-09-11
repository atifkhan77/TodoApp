import 'package:flutter/material.dart';
import 'package:todo_app/Screens/login_screen.dart';
import 'package:todo_app/Widgets/button.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(201, 240, 232, 0.973),
        body: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 200,
              ),
              const Center(
                child: SizedBox(
                  height: 165,
                  width: 195,
                  child: Image(
                    image: AssetImage('lib/images/phone.png'),
                  ),
                ),
              ),
              const Text(
                'Get things done with Todo',
                style: TextStyle(
                    shadows: [
                      Shadow(
                        color: Colors.black,
                        blurRadius: 1.0,
                        offset: Offset(1.0, 1.0),
                      ),
                    ],
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                padding: const EdgeInsets.all(17),
                height: 110,
                width: 350,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(217, 243, 238, 0.973),
                  border: Border.all(width: 1.5, color: Colors.black),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 3.0,
                      spreadRadius: 3.0,
                      offset: Offset(
                        2.0,
                        2.0,
                      ),
                    ),
                  ],
                ),
                child: const Text(
                  'Streamline your day with our intuitive todo app, seamlessly organizing tasks and boosting productivity. Your ultimate tool for efficient task management',
                  style: TextStyle(fontSize: 15),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
                child: const CustomButton(
                    height: 50, width: 350, text: "Get Started"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
