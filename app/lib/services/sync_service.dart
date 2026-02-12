import 'dart:convert';

import 'package:convex_flutter/convex_flutter.dart';

import '../models/reminder.dart';
import '../models/reminder_list.dart';
import '../models/trigger.dart';
import 'db_service.dart';

class SyncService {
  final ConvexClient _convex;
  final DbService _db;

  bool _enabled = false;

  bool get isEnabled => _enabled;

  SyncService({
    required ConvexClient convex,
    required DbService db,
  })  : _convex = convex,
        _db = db;

  void enable() {
    _enabled = true;
  }

  void disable() {
    _enabled = false;
  }

  // ---------------------------------------------------------------------------
  // Push — local → Convex
  // ---------------------------------------------------------------------------

  Future<void> pushReminderList(ReminderList list) async {
    if (!_enabled) return;

    final now = DateTime.now();
    list.updatedAt = now;
    await _db.updateReminderList(list);

    if (list.convexId != null) {
      await _convex.mutation(
        name: 'reminderLists:update',
        args: {
          'id': list.convexId,
          'name': list.name,
          'iconName': list.iconName,
        },
      );
    } else {
      final result = await _convex.mutation(
        name: 'reminderLists:create',
        args: {
          'name': list.name,
          'iconName': list.iconName,
        },
      );
      list.convexId = result as String;
      await _db.updateReminderList(list);
    }
  }

  Future<void> pushTrigger(Trigger trigger) async {
    if (!_enabled) return;

    final now = DateTime.now();
    trigger.updatedAt = now;
    await _db.updateTrigger(trigger);

    if (trigger.convexId != null) {
      await _convex.mutation(
        name: 'triggers:update',
        args: {
          'id': trigger.convexId,
          'at': trigger.at.millisecondsSinceEpoch,
          'every': trigger.every,
          'times': trigger.times,
        },
      );
    } else {
      final result = await _convex.mutation(
        name: 'triggers:create',
        args: {
          'at': trigger.at.millisecondsSinceEpoch,
          'every': trigger.every,
          'times': trigger.times,
        },
      );
      trigger.convexId = result as String;
      await _db.updateTrigger(trigger);
    }
  }

  Future<void> pushReminder(Reminder reminder) async {
    if (!_enabled) return;

    final now = DateTime.now();
    reminder.updatedAt = now;
    await _db.updateReminder(reminder);

    // Resolve local IDs → Convex IDs
    String? convexTriggerId;
    if (reminder.triggerId != null) {
      final trigger = await _db.getTrigger(reminder.triggerId!);
      convexTriggerId = trigger?.convexId;
    }

    String? convexListId;
    if (reminder.listId != null) {
      final list = await _db.getReminderList(reminder.listId!);
      convexListId = list?.convexId;
    }

    final overridesJson = reminder.overrides
        .map((o) {
          final map = <String, dynamic>{
            'momentOffset': o.momentOffset,
            'action': o.action,
          };
          if (o.moment != null) {
            map['moment'] = {
              'offset': o.moment!.offset,
              'voices': o.moment!.voices
                  .map((v) {
                    final vm = <String, dynamic>{'type': v.type};
                    if (v.intensity != null) vm['intensity'] = v.intensity;
                    if (v.duration != null) vm['duration'] = v.duration;
                    if (v.repeat != null) vm['repeat'] = v.repeat;
                    if (v.gap != null) vm['gap'] = v.gap;
                    if (v.pattern != null) vm['pattern'] = v.pattern;
                    if (v.escalationStep != null) {
                      vm['escalationStep'] = v.escalationStep;
                    }
                    if (v.escalationEvery != null) {
                      vm['escalationEvery'] = v.escalationEvery;
                    }
                    if (v.escalationMax != null) {
                      vm['escalationMax'] = v.escalationMax;
                    }
                    return vm;
                  })
                  .toList(),
            };
          }
          return map;
        })
        .toList();

    if (reminder.convexId != null) {
      await _convex.mutation(
        name: 'reminders:update',
        args: {
          'id': reminder.convexId,
          'body': reminder.body,
          'triggerId': convexTriggerId,
          'listId': convexListId,
          'overrides': overridesJson,
        },
      );
    } else {
      final result = await _convex.mutation(
        name: 'reminders:create',
        args: {
          'body': reminder.body,
          'triggerId': convexTriggerId,
          'listId': convexListId,
          'overrides': overridesJson,
        },
      );
      reminder.convexId = result as String;
      await _db.updateReminder(reminder);
    }
  }

  // ---------------------------------------------------------------------------
  // Pull — Convex → local (last-write-wins)
  // ---------------------------------------------------------------------------

  Future<void> pullAll() async {
    if (!_enabled) return;

    await _pullReminderLists();
    await _pullTriggers();
    await _pullReminders();
  }

  Future<void> _pullReminderLists() async {
    final result = await _convex.query('reminderLists:listByUser', {});
    if (result.isEmpty) return;

    final docs = (jsonDecode(result) as List).cast<Map<String, dynamic>>();
    final localLists = await _db.getAllReminderLists();
    final localByConvexId = <String, ReminderList>{};
    for (final l in localLists) {
      if (l.convexId != null) localByConvexId[l.convexId!] = l;
    }

    for (final doc in docs) {
      final convexId = doc['_id'] as String;
      final remoteUpdatedAt = DateTime.fromMillisecondsSinceEpoch(
        (doc['updatedAt'] as num).toInt(),
      );

      final local = localByConvexId[convexId];
      if (local != null) {
        if (local.updatedAt == null ||
            remoteUpdatedAt.isAfter(local.updatedAt!)) {
          local.name = doc['name'] as String;
          local.iconName = doc['iconName'] as String;
          local.updatedAt = remoteUpdatedAt;
          await _db.updateReminderList(local);
        }
      } else {
        // Match by name for default-seeded lists
        final byName = await _db.getReminderListByName(doc['name'] as String);
        if (byName != null && byName.convexId == null) {
          byName.convexId = convexId;
          byName.iconName = doc['iconName'] as String;
          byName.updatedAt = remoteUpdatedAt;
          await _db.updateReminderList(byName);
        } else {
          final newList = ReminderList()
            ..name = doc['name'] as String
            ..iconName = doc['iconName'] as String
            ..createdAt = DateTime.fromMillisecondsSinceEpoch(
              (doc['createdAt'] as num).toInt(),
            )
            ..updatedAt = remoteUpdatedAt
            ..convexId = convexId;
          await _db.createReminderList(newList);
        }
      }
    }
  }

  Future<void> _pullTriggers() async {
    final result = await _convex.query('triggers:listByUser', {});
    if (result.isEmpty) return;

    final docs = (jsonDecode(result) as List).cast<Map<String, dynamic>>();
    final localTriggers = await _db.getAllTriggers();
    final localByConvexId = <String, Trigger>{};
    for (final t in localTriggers) {
      if (t.convexId != null) localByConvexId[t.convexId!] = t;
    }

    for (final doc in docs) {
      final convexId = doc['_id'] as String;
      final remoteUpdatedAt = DateTime.fromMillisecondsSinceEpoch(
        (doc['updatedAt'] as num).toInt(),
      );

      final local = localByConvexId[convexId];
      if (local != null) {
        if (local.updatedAt == null ||
            remoteUpdatedAt.isAfter(local.updatedAt!)) {
          local.at = DateTime.fromMillisecondsSinceEpoch(
            (doc['at'] as num).toInt(),
          );
          local.every = doc['every'] as String?;
          local.times = doc['times'] as int?;
          local.updatedAt = remoteUpdatedAt;
          await _db.updateTrigger(local);
        }
      } else {
        final newTrigger = Trigger()
          ..at = DateTime.fromMillisecondsSinceEpoch(
            (doc['at'] as num).toInt(),
          )
          ..every = doc['every'] as String?
          ..times = doc['times'] as int?
          ..convexId = convexId
          ..updatedAt = remoteUpdatedAt;
        await _db.createTrigger(newTrigger);
      }
    }
  }

  Future<void> _pullReminders() async {
    final result = await _convex.query('reminders:listByUser', {});
    if (result.isEmpty) return;

    final docs = (jsonDecode(result) as List).cast<Map<String, dynamic>>();
    final localReminders = await _db.getAllReminders();
    final localByConvexId = <String, Reminder>{};
    for (final r in localReminders) {
      if (r.convexId != null) localByConvexId[r.convexId!] = r;
    }

    // Build reverse maps: convexId → local Id
    final localTriggers = await _db.getAllTriggers();
    final triggerConvexToLocal = <String, int>{};
    for (final t in localTriggers) {
      if (t.convexId != null) triggerConvexToLocal[t.convexId!] = t.id;
    }

    final localLists = await _db.getAllReminderLists();
    final listConvexToLocal = <String, int>{};
    for (final l in localLists) {
      if (l.convexId != null) listConvexToLocal[l.convexId!] = l.id;
    }

    for (final doc in docs) {
      final convexId = doc['_id'] as String;
      final remoteUpdatedAt = DateTime.fromMillisecondsSinceEpoch(
        (doc['updatedAt'] as num).toInt(),
      );

      final convexTriggerId = doc['triggerId'] as String?;
      final convexListId = doc['listId'] as String?;
      final localTriggerId = convexTriggerId != null
          ? triggerConvexToLocal[convexTriggerId]
          : null;
      final localListId =
          convexListId != null ? listConvexToLocal[convexListId] : null;

      final local = localByConvexId[convexId];
      if (local != null) {
        if (local.updatedAt == null ||
            remoteUpdatedAt.isAfter(local.updatedAt!)) {
          local.body = doc['body'] as String?;
          local.triggerId = localTriggerId;
          local.listId = localListId;
          local.updatedAt = remoteUpdatedAt;
          await _db.updateReminder(local);
        }
      } else {
        final newReminder = Reminder()
          ..body = doc['body'] as String?
          ..createdAt = DateTime.fromMillisecondsSinceEpoch(
            (doc['createdAt'] as num).toInt(),
          )
          ..triggerId = localTriggerId
          ..listId = localListId
          ..convexId = convexId
          ..updatedAt = remoteUpdatedAt;
        await _db.createReminder(newReminder);
      }
    }
  }

  // ---------------------------------------------------------------------------
  // Delete — remove from Convex
  // ---------------------------------------------------------------------------

  Future<void> deleteReminder(Reminder reminder) async {
    if (!_enabled || reminder.convexId == null) return;
    await _convex.mutation(
      name: 'reminders:remove',
      args: {'id': reminder.convexId},
    );
  }

  Future<void> deleteTrigger(Trigger trigger) async {
    if (!_enabled || trigger.convexId == null) return;
    await _convex.mutation(
      name: 'triggers:remove',
      args: {'id': trigger.convexId},
    );
  }

  Future<void> deleteReminderList(ReminderList list) async {
    if (!_enabled || list.convexId == null) return;
    await _convex.mutation(
      name: 'reminderLists:remove',
      args: {'id': list.convexId},
    );
  }

  // ---------------------------------------------------------------------------
  // Full sync
  // ---------------------------------------------------------------------------

  Future<void> pushAll() async {
    if (!_enabled) return;

    final lists = await _db.getAllReminderLists();
    for (final list in lists) {
      await pushReminderList(list);
    }

    final triggers = await _db.getAllTriggers();
    for (final trigger in triggers) {
      await pushTrigger(trigger);
    }

    final reminders = await _db.getAllReminders();
    for (final reminder in reminders) {
      await pushReminder(reminder);
    }
  }

  Future<void> syncAll() async {
    if (!_enabled) return;
    await pullAll();
    await pushAll();
  }
}
