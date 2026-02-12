import 'package:isar/isar.dart';

part 'image_attachment.g.dart';

@collection
class ImageAttachment {
  Id id = Isar.autoIncrement;

  @Index()
  late int reminderId;

  late String filePath;

  String? caption;
}
