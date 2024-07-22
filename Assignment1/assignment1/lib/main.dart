import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Circular Image Example',
      home: Scaffold(
        appBar: AppBar(
          title: Text("Personal card"),
          titleTextStyle: GoogleFonts.lato(
              textStyle: Theme.of(context).textTheme.displayLarge,
              fontSize: 48,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic),
          backgroundColor: Colors.lightBlue,
        ),
        body: const Column(children: [
          Spacer(
            flex: 1,
          ),
          Center(
            child: CircleAvatar(
              radius: 100,
              backgroundImage: AssetImage("assets/images/ronaldo.png"),
            ),
          ),
          Spacer(
            flex: 3,
          )
        ]),
      ),
    );
  }
}
