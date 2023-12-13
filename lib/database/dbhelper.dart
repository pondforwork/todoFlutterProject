import 'dart:ui';

import 'package:hive_flutter/adapters.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todoflutter/model/todo.dart';

class DbHelper {
  Future<void> initHive() async {
    final documentDirectory = await getApplicationDocumentsDirectory();
    try {
      await Hive.initFlutter(documentDirectory.path);
      Hive.registerAdapter(ColorAdapter());
      await Hive.openBox('data');
      // await clearData();
    } catch (error) {
      print("Hive initialization error: $error");
    }
  }

  void someFunction() {
    print("Function");
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
        if (value != null && value['isfinish'] == false) {
          allData.add(ToDo(value['id'], value['topic'],
              bool.parse(value['isfinish'].toString()), value['color']));
        }
      }
      return allData;
    } catch (error) {
      print("Error while accessing data: $error");
      return [];
    }
  }

  Future<void> clearData() async {
    var data = Hive.box('data');
    await data.clear();
    print('Data cleared successfully');
  }

  void deleteToDo(String id) async {
    try {
      var data = Hive.box('data');
      await data.delete(id);
      print('ToDo deleted successfully');
    } catch (error) {
      print('Error deleting ToDo: $error');
    }
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

  Future<void> addData(
      String id, String topic, bool isfinish, Color color) async {
    var data = Hive.box('data');
    data.put(
        id, {'id': id, 'topic': topic, 'isfinish': isfinish, 'color': color});
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
}
