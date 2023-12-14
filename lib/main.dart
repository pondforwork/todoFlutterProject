import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todoflutter/screen/readtodo.dart';

Future<void> main() async {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      theme: ThemeData(
        // Customize your theme here
        primarySwatch: Colors.blue,
       
        // Add more theme configurations as needed
      ),
      home: ReadToDo());
  }
}
