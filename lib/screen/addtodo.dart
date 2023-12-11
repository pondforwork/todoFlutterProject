import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todoflutter/model/todo.dart';
import 'package:uuid/uuid.dart';

class AddToDO extends StatefulWidget {
  const AddToDO({super.key});

  @override
  State<AddToDO> createState() => _AddToDOState();
}

class _AddToDOState extends State<AddToDO> {
  @override
  void initState() {
    super.initState();
    initHive();
  }

  Future<void> initHive() async {
    await Hive.initFlutter();
    await Hive.openBox('data');
    var data = Hive.box('data');
    print(data.get(0));
  }

  Future<void> addData(int id, String topic, bool finish, bool archive) async {
    var data = Hive.box('data');
    data.put(id, {'topic': topic, 'finish': finish, 'archive': archive});
  }

  Future<void> getData() async {
    var data = Hive.box('data');
    
    var allData =
        data.values.toList(); //\ Convert iterable to list for easier handling
    print(allData);
  }

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
          ToDo todo = ToDo(0, enteredText, false, false);
          // addData(0, todo.topic, todo.finish, todo.archive);
          // addData(1, "Test2", todo.finish, todo.archive);

          getData();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
