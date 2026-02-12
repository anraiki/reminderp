import 'package:flutter/material.dart';

import '../models/reminder.dart';
import 'reminder_tile.dart';

class DayRemindersList extends StatelessWidget {
  const DayRemindersList({super.key, required this.reminders});

  final List<Reminder> reminders;

  @override
  Widget build(BuildContext context) {
    if (reminders.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(
            'No reminders for this day',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.5),
                ),
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: reminders.length,
      itemBuilder: (context, index) =>
          ReminderTile(reminder: reminders[index]),
    );
  }
}
