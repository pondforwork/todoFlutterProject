import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todoflutter/database/dbhelper.dart';
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
  DbHelper dbHelper = DbHelper();

  @override
  void initState() {
    super.initState();
    dbHelper.initHive();
    _data = dbHelper.getData();
    dbHelper.someFunction();
  }

  Future<void> _showDeleteDialog(String id) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete ToDo'),
          content: const Text('Are you sure you want to delete this ToDo?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                dbHelper.deleteToDo(id);
                Navigator.of(context).pop(); // Close the dialog
                setState(() {
                  _data = dbHelper.getData();
                });
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Future<void> addOrUpdateData(String id, String topic, bool isfinish) async {
    var data = Hive.box('data');
    // Check if the ID already exists
    if (data.containsKey(id)) {
      // Update only the isfinish field
      data.put(id, {'id': id, 'topic': topic, 'isfinish': isfinish});
      print('Data updated successfully for ID: $id');
    } else {
      // Add new data if the ID doesn't exist
      data.put(id, {'id': id, 'topic': topic, 'isfinish': isfinish});
      print('Data added successfully for ID: $id');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "To Do",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.yellow[600],
      ),
      backgroundColor: Colors.yellow[200],
      body: Center(
        child: FutureBuilder<List<ToDo>>(
          future: _data,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.data?.length == 0) {
              print("null");
              return const Center(
                child: Text("There's No ToDo Here"),
              );
            } else {
              print(snapshot.data.toString());
              List<Widget> cards = snapshot.data!.map((todo) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: GestureDetector(
                      onLongPress: () {
                        print(todo.id);
                        _showDeleteDialog(todo.id);
                      },
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        tileColor: Colors.blue,
                        leading: Container(
                          decoration: BoxDecoration(
                              color: Colors.white, shape: BoxShape.circle),
                          // color: Colors.white,
                          child: Checkbox(
                            value: todo.isfinish,
                            onChanged: (bool? value) {
                              setState(() {
                                todo.isfinish = !todo.isfinish;
                              });
                              Future.delayed(Duration(seconds: 2), () {
                                setState(() {
                                  addOrUpdateData(
                                      todo.id, todo.topic, todo.isfinish);
                                  _data = dbHelper.getData();
                                });
                              });
                            },
                          ),
                        ),
                        title: Container(
                          width: 300,
                          height: 70,
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(todo.topic),
                          ),
                        ),
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
        child: const Icon(Icons.add),
      ),
    );
  }
}
