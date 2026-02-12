import 'package:isar/isar.dart';

part 'trigger.g.dart';

@collection
class Trigger {
  Id id = Isar.autoIncrement;

  late DateTime at;

  String? every; // 'daily', 'weekly', 'monthly', etc.

  int? times;

  int? patternId;

  String? convexId;

  DateTime? updatedAt;
}
