import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todoflutter/database/dbhelper.dart';
import 'package:todoflutter/model/todo.dart';
import 'package:todoflutter/screen/addToDo.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todoflutter/screen/readfinishtodo.dart';

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

  Future<void> _showFinishDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Move Finished ToDo to Archive.'),
          content: const Text('Are you sure you finished things Up?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                setState(() {
                  Navigator.of(context).pop(); // Close the dialog
                });
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.black),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                setState(() {
                  _data = dbHelper.getData();
                });
              },
              child: const Text(
                'Ok',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> addOrUpdateData(String id, String topic, bool isfinish,
      Color color, DateTime order) async {
    var data = Hive.box('data');
    // Check if the ID already exists
    if (data.containsKey(id)) {
      // Update only the isfinish field
      data.put(id, {
        'id': id,
        'topic': topic,
        'isfinish': isfinish,
        'color': color,
        'order': order
      });
      print('Data updated successfully for ID: $id');
    } else {
      // Add new data if the ID doesn't exist
      data.put(id, {
        'id': id,
        'topic': topic,
        'isfinish': isfinish,
        'color': color,
        'order': order
      });
      print('Data added successfully for ID: $id');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.archive),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ReadFinishToDo()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.check_box_rounded),
            onPressed: () {
              // Your button action goes here
              setState(() {
                _showFinishDialog();
                // _data = dbHelper.getData();
              });
            },
          ),
        ],
        title: const Text(
          "To Do",
          style: TextStyle(color: Colors.white),
        ),
        // backgroundColor: Colors.yellow[600],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: FutureBuilder<List<ToDo>>(
            future: _data,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.data?.length == 0) {
                return const Center(
                  child: Column(
                    children: [
                      SizedBox(height: 320,),
                      Text( 
                        "No To Do.",
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              } else {
                List<Widget> cards = snapshot.data!.map((todo) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            10.0), // Set the border radius
                        side: const BorderSide(
                            color: Colors.black, // i need to apply my col here
                            width: 1), // Set the border color and width
                      ),
                      child: GestureDetector(
                        onLongPress: () {
                          print(todo.id);
                          _showDeleteDialog(todo.id);
                        },
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          tileColor: todo.color,
                          leading: Checkbox(
                            activeColor: Colors
                                .white, // Set the color of the check mark when checked
                            checkColor: const Color.fromARGB(255, 8, 7,
                                7), // Set the color of the check mark
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  8.0), // Set the border radius of the checkbox box
                              side: const BorderSide(
                                  color: Color.fromARGB(255, 9, 80,
                                      138)), // Set the border color and width
                            ),
                            value: todo.isfinish,
                            onChanged: (bool? value) {
                              setState(() {
                                todo.isfinish = !todo.isfinish;
                              });
                              setState(() {
                                addOrUpdateData(todo.id, todo.topic,
                                    todo.isfinish, todo.color, todo.order);
                                // _data = dbHelper.getData();
                              });
                            },
                          ),
                          title: Container(
                            width: 300,
                            height: 50,
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(
                                todo.topic,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
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
