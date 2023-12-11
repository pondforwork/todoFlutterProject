import 'package:flutter/material.dart';
import 'package:todoflutter/model/todo.dart';

class AddToDO extends StatefulWidget {
  const AddToDO({super.key});

  @override
  State<AddToDO> createState() => _AddToDOState();
}

class _AddToDOState extends State<AddToDO> {
  var topicController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("To Do"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Form(
            child: TextFormField(
              controller: topicController,
              decoration: const InputDecoration(
                labelText: "What Things To Do ?",
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please Enter Your To Do';
                }
                return null;
              },
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          String enteredText = topicController.text;
          print("Entered Text: $enteredText");
          ToDo todo = new ToDo(enteredText, false, false);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
