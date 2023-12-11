import 'package:flutter/material.dart';
import 'package:todoflutter/screen/addToDo.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ReadToDo extends StatefulWidget {
  const ReadToDo({super.key});
  @override
  State<ReadToDo> createState() => _ReadToDoState();
}

class _ReadToDoState extends State<ReadToDo> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("To Do"),
      ),
      body: Center(
        child: Column(children: [Card(
          child: ListTile(
            leading: Checkbox(
              value: false,
              onChanged: (bool? value) {},
            ),
            title: Container(
              width: 300,
              height: 100,
              padding: const EdgeInsets.all(8.0),
              color: Colors.green,
              child: Center(
                child: Text("Test"),
              ),
            ),
          ),
        ),],)
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
