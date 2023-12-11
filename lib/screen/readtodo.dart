import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todoflutter/model/todo.dart';
import 'package:todoflutter/screen/addToDo.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ReadToDo extends StatefulWidget {
  const ReadToDo({Key? key}) : super(key: key);

  @override
  State<ReadToDo> createState() => _ReadToDoState();
}

class _ReadToDoState extends State<ReadToDo> {
  late Future<List<ToDo>> _data;

  @override
  void initState() {
    print("init");
    super.initState();
    initHive();
    _data = getData();
  }

  Future<void> initHive() async {
    final documentDirectory = await getApplicationDocumentsDirectory();
    try {
      await Hive.initFlutter(documentDirectory.path);
      await Hive.openBox('data');
      print("Hive initialized successfully");
    } catch (error) {
      print("Hive initialization error: $error");
      // Show error message to the user
    }
  }

  Future<List<ToDo>> getData() async {
    try {
      final documentDirectory = await getApplicationDocumentsDirectory();
      await Hive.initFlutter(documentDirectory.path);
      await Hive.openBox('data');
      var data = Hive.box('data');
      List<dynamic> values = data.values.toList();
      List<ToDo> allData = [];

      for (dynamic value in values) {
        if (value != null) {
          print("ID: ${value['id']}");
          print("Topic: ${value['topic']}");
          allData.add(ToDo(
            value['id'],
            value['topic'],
            bool.parse(value['isfinish'].toString())
          ));
        }
      }

      return allData;
    } catch (error) {
      print("Error while accessing data: $error");
      // Show error message to the user
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("To Do"),
      ),
      body: Center(
        child: FutureBuilder<List<ToDo>>(
          future: _data,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              List<Widget> cards = snapshot.data!.map((todo) {
                return Card(
                  child: ListTile(
                   leading: Checkbox(
                      value: todo.isfinish,
                      onChanged: (bool? value) {
                        setState(() {
                          value = false;
                        });
                      },
                    ),
                    title: Container(
                      width: 300,
                      height: 100,
                      padding: const EdgeInsets.all(8.0),
                      color: Colors.green,
                      child: Center(
                        child: Text(todo.topic),
                      ),
                    ),
                  ),
                );
              }).toList();

              return Column(
                children: cards,
              );
            }
          },
        ),
      ),
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
