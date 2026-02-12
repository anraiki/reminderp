import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../models/reminder.dart';
import '../models/reminder_list.dart';
import '../models/location.dart';
import '../models/image_attachment.dart';
import '../models/todo.dart';
import '../models/pattern.dart';
import '../models/trigger.dart';

class DbService {
  late final Isar _isar;

  Isar get isar => _isar;

  Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open(
      [
        ReminderSchema,
        ReminderListSchema,
        LocationSchema,
        ImageAttachmentSchema,
        TodoSchema,
        PatternSchema,
        TriggerSchema,
      ],
      directory: dir.path,
    );
    await _seedDefaultLists();
  }

  Future<void> _seedDefaultLists() async {
    final count = await _isar.reminderLists.count();
    if (count > 0) return;

    final defaults = [
      ('Personal', 'person_outline'),
      ('Work', 'work_outline'),
      ('Shopping', 'shopping_cart_outlined'),
      ('Health', 'favorite_outline'),
    ];

    await _isar.writeTxn(() async {
      for (final (name, icon) in defaults) {
        final list = ReminderList()
          ..name = name
          ..iconName = icon
          ..createdAt = DateTime.now();
        await _isar.reminderLists.put(list);
      }
    });
  }

  // --- Reminder CRUD ---

  Future<int> createReminder(Reminder reminder) {
    return _isar.writeTxn(() => _isar.reminders.put(reminder));
  }

  Future<Reminder?> getReminder(int id) {
    return _isar.reminders.get(id);
  }

  Future<List<Reminder>> getAllReminders() {
    return _isar.reminders.where().findAll();
  }

  Future<int> updateReminder(Reminder reminder) {
    return _isar.writeTxn(() => _isar.reminders.put(reminder));
  }

  Future<bool> deleteReminder(int id) {
    return _isar.writeTxn(() => _isar.reminders.delete(id));
  }

  // --- Location CRUD ---

  Future<int> createLocation(Location location) {
    return _isar.writeTxn(() => _isar.locations.put(location));
  }

  Future<List<Location>> getLocationsForReminder(int reminderId) {
    return _isar.locations
        .filter()
        .reminderIdEqualTo(reminderId)
        .findAll();
  }

  Future<bool> deleteLocation(int id) {
    return _isar.writeTxn(() => _isar.locations.delete(id));
  }

  // --- ImageAttachment CRUD ---

  Future<int> createImageAttachment(ImageAttachment attachment) {
    return _isar.writeTxn(() => _isar.imageAttachments.put(attachment));
  }

  Future<List<ImageAttachment>> getAttachmentsForReminder(int reminderId) {
    return _isar.imageAttachments
        .filter()
        .reminderIdEqualTo(reminderId)
        .findAll();
  }

  Future<bool> deleteImageAttachment(int id) {
    return _isar.writeTxn(() => _isar.imageAttachments.delete(id));
  }

  // --- Todo CRUD ---

  Future<int> createTodo(Todo todo) {
    return _isar.writeTxn(() => _isar.todos.put(todo));
  }

  Future<Todo?> getTodoForReminder(int reminderId) {
    return _isar.todos
        .filter()
        .reminderIdEqualTo(reminderId)
        .findFirst();
  }

  Future<int> updateTodo(Todo todo) {
    return _isar.writeTxn(() => _isar.todos.put(todo));
  }

  Future<bool> deleteTodo(int id) {
    return _isar.writeTxn(() => _isar.todos.delete(id));
  }

  // --- Pattern CRUD ---

  Future<int> createPattern(Pattern pattern) {
    return _isar.writeTxn(() => _isar.patterns.put(pattern));
  }

  Future<Pattern?> getPattern(int id) {
    return _isar.patterns.get(id);
  }

  Future<List<Pattern>> getAllPatterns() {
    return _isar.patterns.where().findAll();
  }

  Future<List<Pattern>> getLocalPatterns() {
    return _isar.patterns.filter().isLocalEqualTo(true).findAll();
  }

  Future<int> updatePattern(Pattern pattern) {
    return _isar.writeTxn(() => _isar.patterns.put(pattern));
  }

  Future<bool> deletePattern(int id) {
    return _isar.writeTxn(() => _isar.patterns.delete(id));
  }

  // --- Trigger CRUD ---

  Future<int> createTrigger(Trigger trigger) {
    return _isar.writeTxn(() => _isar.triggers.put(trigger));
  }

  Future<Trigger?> getTrigger(int id) {
    return _isar.triggers.get(id);
  }

  Future<List<Trigger>> getAllTriggers() {
    return _isar.triggers.where().findAll();
  }

  Future<int> updateTrigger(Trigger trigger) {
    return _isar.writeTxn(() => _isar.triggers.put(trigger));
  }

  Future<bool> deleteTrigger(int id) {
    return _isar.writeTxn(() => _isar.triggers.delete(id));
  }

  // --- ReminderList CRUD ---

  Future<int> createReminderList(ReminderList list) {
    return _isar.writeTxn(() => _isar.reminderLists.put(list));
  }

  Future<ReminderList?> getReminderList(int id) {
    return _isar.reminderLists.get(id);
  }

  Future<List<ReminderList>> getAllReminderLists() {
    return _isar.reminderLists.where().findAll();
  }

  Future<ReminderList?> getReminderListByName(String name) {
    return _isar.reminderLists.filter().nameEqualTo(name).findFirst();
  }

  Future<int> updateReminderList(ReminderList list) {
    return _isar.writeTxn(() => _isar.reminderLists.put(list));
  }

  Future<bool> deleteReminderList(int id) {
    return _isar.writeTxn(() => _isar.reminderLists.delete(id));
  }

  Future<void> unassignRemindersFromList(int listId) async {
    final reminders =
        await _isar.reminders.filter().listIdEqualTo(listId).findAll();
    if (reminders.isEmpty) return;
    await _isar.writeTxn(() async {
      for (final r in reminders) {
        r.listId = null;
        await _isar.reminders.put(r);
      }
    });
  }

  Future<void> close() async {
    await _isar.close();
  }
}
