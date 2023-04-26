import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String text;
  VoidCallback onPressed;
  Color colors;
  MyButton(
      {super.key,
      required this.text,
      required this.onPressed,
      required this.colors});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      color: colors,
      child: Text(text),
    );
  }
}
