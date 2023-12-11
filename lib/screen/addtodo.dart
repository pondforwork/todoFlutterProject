import 'package:flutter/material.dart';

class AddToDO extends StatefulWidget {
  const AddToDO({super.key});

  @override
  State<AddToDO> createState() => _AddToDOState();
}

class _AddToDOState extends State<AddToDO> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("To Do"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Form(
            child: TextFormField(
              decoration: const InputDecoration(
                labelText: "What Things To Do ?",
              ),
              obscureText: true,
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
    );
  }
}
