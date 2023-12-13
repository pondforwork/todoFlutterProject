import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todoflutter/model/todo.dart';

class DbHelper {
  Future<void> initHive() async {
    final documentDirectory = await getApplicationDocumentsDirectory();
    try {
      await Hive.initFlutter(documentDirectory.path);
      await Hive.openBox('data');
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
              bool.parse(value['isfinish'].toString())));
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
}
