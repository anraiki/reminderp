import 'package:isar/isar.dart';
import 'pattern.dart';

part 'reminder.g.dart';

@embedded
class Override {
  late int momentOffset;
  late String action; // 'skip', 'replace'
  Moment? moment;
}

@collection
class Reminder {
  Id id = Isar.autoIncrement;

  String? body;

  late DateTime createdAt;

  DateTime? updatedAt;

  String? convexId;

  int? triggerId;

  int? patternId;

  int? listId;

  List<Override> overrides = [];
}
