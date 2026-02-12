import 'package:isar/isar.dart';

part 'pattern.g.dart';

@embedded
class Voice {
  late String type; // 'vibration', 'sound', 'flash', etc.
  double? intensity;
  double? duration;
  int? repeat;
  double? gap;
  String? pattern;
  double? escalationStep;
  double? escalationEvery;
  double? escalationMax;
}

@embedded
class Moment {
  late int offset; // seconds from trigger time
  List<Voice> voices = [];
}

@collection
class Pattern {
  Id id = Isar.autoIncrement;

  @Index()
  late String name;

  late bool isLocal;

  String? convexId;

  List<Moment> moments = [];
}
