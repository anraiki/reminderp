import 'package:isar/isar.dart';

part 'reminder_list.g.dart';

@collection
class ReminderList {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String name;

  late String iconName;

  late DateTime createdAt;

  DateTime? updatedAt;

  String? convexId;
}
