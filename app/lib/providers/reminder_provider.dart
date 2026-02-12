import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

import '../models/reminder.dart';
import '../models/reminder_list.dart';
import '../models/trigger.dart';
import '../services/db_service.dart';

final dbServiceProvider = Provider<DbService>((ref) {
  throw UnimplementedError('Must be overridden in ProviderScope');
});

final allRemindersProvider = FutureProvider<List<Reminder>>((ref) {
  final db = ref.watch(dbServiceProvider);
  return db.getAllReminders();
});

final allTriggersProvider = FutureProvider<List<Trigger>>((ref) {
  final db = ref.watch(dbServiceProvider);
  return db.getAllTriggers();
});

final allReminderListsProvider = FutureProvider<List<ReminderList>>((ref) {
  final db = ref.watch(dbServiceProvider);
  return db.getAllReminderLists();
});

/// Map from normalized date -> list of reminders for that day.
/// When a list is selected, only shows reminders belonging to that list.
final remindersByDateProvider =
    FutureProvider<Map<DateTime, List<Reminder>>>((ref) async {
  final reminders = await ref.watch(allRemindersProvider.future);
  final db = ref.watch(dbServiceProvider);
  final selectedListId = ref.watch(selectedListProvider);

  final map = <DateTime, List<Reminder>>{};
  for (final r in reminders) {
    if (selectedListId != null && r.listId != selectedListId) continue;
    if (r.triggerId == null) continue;
    final trigger = await db.getTrigger(r.triggerId!);
    if (trigger == null) continue;
    final day = DateTime.utc(trigger.at.year, trigger.at.month, trigger.at.day);
    map.putIfAbsent(day, () => []).add(r);
  }
  return map;
});

final remindersForDateProvider =
    FutureProvider.family<List<Reminder>, DateTime>((ref, date) async {
  final map = await ref.watch(remindersByDateProvider.future);
  final key = DateTime.utc(date.year, date.month, date.day);
  return map[key] ?? [];
});

final selectedDateProvider = StateProvider<DateTime>((ref) {
  final now = DateTime.now();
  return DateTime.utc(now.year, now.month, now.day);
});

final calendarFormatProvider = StateProvider<CalendarFormat>((ref) {
  return CalendarFormat.month;
});

/// The currently selected reminder list for filtering.
/// null means "All Reminders".
final selectedListProvider = StateProvider<int?>((ref) => null);
