import 'package:uuid/uuid.dart';

class ToDo {
  late String id;
  late String topic;
  late bool finish;
  late bool archive;

  ToDo(this.topic, this.finish, this.archive){
    id = Uuid().v4();
  }
}
