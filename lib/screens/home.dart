import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('The IQ Hub'),
      ),
      body: const Center(
        child: Text('IQ Hub Home Page'),
      ),
    );
  }
}
