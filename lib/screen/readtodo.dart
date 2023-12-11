import 'package:flutter/material.dart';
import 'package:todoflutter/screen/addToDo.dart';

class ReadToDo extends StatefulWidget {
  const ReadToDo({super.key});

  @override
  State<ReadToDo> createState() => _ReadToDoState();
}

class _ReadToDoState extends State<ReadToDo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("To Do"),
      ),
      body: Center(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddToDO()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
