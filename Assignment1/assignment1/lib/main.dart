import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'First Flutter',
      home: Scaffold(
        appBar: AppBar(
          title: const Text("hello from flutter"),
        ),
        body: const Center(
          child: Text(
            'Hell Flutter!',
            textDirection: TextDirection.ltr,
          ),
        ),
      ),
    );
  }
}
