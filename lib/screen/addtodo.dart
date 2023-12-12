import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
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
  // Hive.init(documentDirectory.path);
  @override
  void initState() {
    super.initState();
    initHive();
    // selectedColorIndex = 0;
  }

  Future<void> initHive() async {
    final documentDirectory = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(documentDirectory.path);
    await Hive.openBox('data');
  }

  Future<void> addData(String id, String topic, bool isfinish) async {
    var data = Hive.box('data');
    data.put(id, {'id': id, 'topic': topic, 'isfinish': isfinish});
  }

  Future<List<ToDo>> getData() async {
    var data = Hive.box('data');
    // Get the list of values
    List<dynamic> values = data.values.toList();
    // Convert each value to a ToDo object
    List<ToDo> allData = [];
    for (dynamic value in values) {
      // Check if value is not null to avoid errors if the box is empty
      if (value != null) {
        // Access all properties of the value and print them
        print("ID: ${value['id']}");
        print("Topic: ${value['topic']}");
        // Add the object to the list
        allData.add(ToDo(value['id'], value['topic'],
            bool.parse(value['isfinish'].toString())));
      }
    }
    return allData;
  }

  // Future<List<ToDo>> getDataReturn() async {
  //   var data = Hive.box('data');
  //   List<ToDo> allData = [];
  //   for (var key in data.keys) {
  //     var todoData = data.get(key);
  //     if (todoData != null) {
  //       allData.add(
  //           ToDo(todoData['id'].toString(), todoData['topic'], true, true));
  //     }
  //   }
  //   allData.forEach((todo) => print(todo));

  //   print(allData[0].toString());
  //   return allData;
  // }

  Future<void> clearData() async {
    var data = Hive.box('data');
    await data.clear();
    print('Data cleared successfully');
  }

  Future<Map<String, dynamic>> getDataById(String id) async {
    var data = Hive.box('data');
    var todoData = data.get(id);

    if (todoData != null) {
      print('ToDo with ID $id: $todoData');
      return {'id': id, ...todoData};
    } else {
      print('ToDo with ID $id not found');
      return {}; // Return an empty map or handle it accordingly
    }
  }

  var topicController = TextEditingController();

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
          ToggleButtons(
            onPressed: (int index) {
              setState(() {
                selectedColorIndex = index;
              });
            },
            isSelected:
                List.generate(3, (index) => index == selectedColorIndex),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipOval(
                  child: Material(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(1000),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          selectedColorIndex = 0;
                        });
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipOval(
                  child: Material(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(1000),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          selectedColorIndex = 1;
                        });
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipOval(
                  child: Material(
                    color: Colors.lightGreen,
                    borderRadius: BorderRadius.circular(1000),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          selectedColorIndex = 2; 
                        });
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          String id = const Uuid().v4();
          String enteredText = topicController.text;
          print("Entered Text: $enteredText");
          ToDo todo = ToDo(id, enteredText, false);
          addData(todo.id, todo.topic, todo.isfinish);
          // getDataReturn();
          // getDataById('ee068d29-d1f0-469d-8d57-0d0fecc9dfe2');
          // getData();
          // clearData();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
