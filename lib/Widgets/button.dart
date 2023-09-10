import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final double width;
  final double height;
  final String text;

  const CustomButton({
    Key? key,
    required this.width,
    required this.height,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color.fromARGB(248, 102, 230, 204),
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
      child: Center(
        child: Text(
          text, // Use the 'text' parameter here
          style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
