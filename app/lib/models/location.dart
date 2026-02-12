import 'package:isar/isar.dart';

part 'location.g.dart';

@collection
class Location {
  Id id = Isar.autoIncrement;

  @Index()
  late int reminderId;

  String? label;

  late double latitude;

  late double longitude;

  double? radius;
}
