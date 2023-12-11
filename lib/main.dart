import 'package:flutter/material.dart';
import 'package:todoflutter/screen/addToDo.dart';
import 'package:todoflutter/screen/readtodo.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ReadToDo()
    );
  }
}
