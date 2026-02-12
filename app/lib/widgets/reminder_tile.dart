import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../models/reminder.dart';
import '../models/trigger.dart';
import '../providers/reminder_provider.dart';

class ReminderTile extends ConsumerWidget {
  const ReminderTile({super.key, required this.reminder});

  final Reminder reminder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(dbServiceProvider);
    final theme = Theme.of(context);

    return FutureBuilder<Trigger?>(
      future:
          reminder.triggerId != null ? db.getTrigger(reminder.triggerId!) : null,
      builder: (context, snapshot) {
        final trigger = snapshot.data;

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: ListTile(
            title: Text(
              reminder.body ?? 'Untitled',
              style: reminder.body == null
                  ? TextStyle(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                      fontStyle: FontStyle.italic,
                    )
                  : null,
            ),
            subtitle: trigger != null
                ? Text(DateFormat.jm().format(trigger.at))
                : null,
            leading: Icon(
              Icons.notifications_outlined,
              color: theme.colorScheme.primary,
            ),
          ),
        );
      },
    );
  }
}
