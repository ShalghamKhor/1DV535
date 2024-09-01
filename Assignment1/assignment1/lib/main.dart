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
      title: 'Personal Card Example',
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Personal card"),
          titleTextStyle: GoogleFonts.lato(
              textStyle: Theme.of(context).textTheme.headlineSmall,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic),
          backgroundColor: Color.fromARGB(255, 198, 171, 245),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage("assets/images/ronaldo.png"),
              ),
              const SizedBox(height: 10),
              Text(
                'Cristiano Ronaldo',
                style: GoogleFonts.pacifico(
                  textStyle: Theme.of(context).textTheme.headlineMedium,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 10),
              const Card(
                elevation: 5,
                margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Football Player at Al-Nassr FC',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.email, color: Colors.black),
                          SizedBox(width: 10),
                          Text('E-mail: cristiano.ronaldo@gmail.com'),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.phone, color: Colors.black),
                          SizedBox(width: 10),
                          Text('Phone: +351 431 - 42 68 10'),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.web, color: Colors.black),
                          SizedBox(width: 10),
                          Text('Web: https://www.cristianoronaldo.com/#cr7'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
