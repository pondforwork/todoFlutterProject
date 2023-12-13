import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todoflutter/database/dbhelper.dart';
import 'package:todoflutter/element/circlebutton.dart';
import 'package:todoflutter/model/todo.dart';
import 'package:uuid/uuid.dart';
import 'package:path_provider/path_provider.dart';

class AddToDO extends StatefulWidget {
  const AddToDO({super.key});
  @override
  State<AddToDO> createState() => _AddToDOState();
}

class _AddToDOState extends State<AddToDO> {
  late int selectedColorIndex = 0; // Track the selected color index
  DbHelper dbHelper = DbHelper();
  // Hive.init(documentDirectory.path);
  @override
  void initState() {
    super.initState();
    dbHelper.initHive();
    // initHive();
    // selectedColorIndex = 0;
  }

  Future<void> initHive() async {
    final documentDirectory = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(documentDirectory.path);
    await Hive.openBox('data');
  }

  // Future<void> addData(String id, String topic, bool isfinish) async {
  //   var data = Hive.box('data');
  //   data.put(id, {'id': id, 'topic': topic, 'isfinish': isfinish});
  // }

  Future<List<ToDo>> getData() async {
    var data = Hive.box('data');

    List<dynamic> values = data.values.toList();

    List<ToDo> allData = [];
    for (dynamic value in values) {
      if (value != null) {
        allData.add(ToDo(value['id'], value['topic'],
            bool.parse(value['isfinish'].toString())));
      }
    }
    return allData;
  }

  Future<void> clearData() async {
    var data = Hive.box('data');
    await data.clear();
    print('Data cleared successfully');
  }

  

  void selectColor(Color color) {
    setState(() {
      selectedColor = color;
    });
  }

  var topicController = TextEditingController();
  Color selectedColor = Colors.red; // Default color
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("To Do"),
      ),
      body: Column(
        children: [
          Padding(
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
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleColorButton(
                  color: Colors.red,
                  isSelected: selectedColor == Colors.red,
                  onPressed: () {
                    selectColor(Colors.red);
                  },
                ),
                const SizedBox(width: 16),
                CircleColorButton(
                  color: Colors.green,
                  isSelected: selectedColor == Colors.green,
                  onPressed: () {
                    selectColor(Colors.green);
                  },
                ),
                const SizedBox(width: 16),
                CircleColorButton(
                  color: Colors.blue,
                  isSelected: selectedColor == Colors.blue,
                  onPressed: () {
                    selectColor(Colors.blue);
                  },
                ),
                const SizedBox(width: 16),
                CircleColorButton(
                  color: Colors.yellow,
                  isSelected: selectedColor == Colors.yellow,
                  onPressed: () {
                    selectColor(Colors.yellow);
                  },
                ),
              ],
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          String id = const Uuid().v4();
          String enteredText = topicController.text;
          ToDo todo = ToDo(id, enteredText, false);
          dbHelper.addData(todo.id, todo.topic, todo.isfinish);
          print(selectedColor);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
