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
    super.initState();
    initHive();
    _data = getData();
  }

  Future<void> initHive() async {
    final documentDirectory = await getApplicationDocumentsDirectory();
    try {
      await Hive.initFlutter(documentDirectory.path);
      await Hive.openBox('data');
    } catch (error) {
      print("Hive initialization error: $error");
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
          allData.add(ToDo(value['id'], value['topic'],
              bool.parse(value['isfinish'].toString())));
        }
      }

      return allData;
    } catch (error) {
      print("Error while accessing data: $error");
      // Show error message to the user
      return [];
    }
  }

  Future<void> clearData() async {
    var data = Hive.box('data');
    await data.clear();
    print('Data cleared successfully');
  }

  // Method to delete the ToDo

  Future<void> _showDeleteDialog(String id) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete ToDo'),
          content: Text('Are you sure you want to delete this ToDo?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _deleteToDo(id); // Call the method to delete the ToDo
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _deleteToDo(String id) async {
    try {
      var data = Hive.box('data');
      await data.delete(id);
      print('ToDo deleted successfully');
      setState(() {
        _data = getData();
      });
    } catch (error) {
      print('Error deleting ToDo: $error');
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
                return Card(
                  child: GestureDetector(
                    onLongPress: () {
                      _showDeleteDialog(todo.id);
                    },
                    child: ListTile(
                      leading: Checkbox(
                        value: todo.isfinish,
                        onChanged: (bool? value) {
                          setState(() {
                            todo.isfinish = !todo.isfinish;
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
