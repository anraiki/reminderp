import 'package:isar/isar.dart';

part 'todo.g.dart';

@embedded
class TodoItem {
  late String text;
  bool completed = false;
}

@collection
class Todo {
  Id id = Isar.autoIncrement;

  @Index()
  late int reminderId;

  List<TodoItem> items = [];
}
