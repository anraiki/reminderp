import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../models/reminder_list.dart';
import '../providers/reminder_provider.dart';
import '../utils/icon_helpers.dart';
import '../widgets/day_reminders_list.dart';
import 'create_reminder_screen.dart';
import 'sign_in_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(selectedDateProvider);
    final calendarFormat = ref.watch(calendarFormatProvider);
    final remindersByDate = ref.watch(remindersByDateProvider);
    final remindersForDay = ref.watch(remindersForDateProvider(selectedDate));
    final selectedListId = ref.watch(selectedListProvider);
    final listsAsync = ref.watch(allReminderListsProvider);
    final theme = Theme.of(context);

    // Resolve selected list name for app bar title
    String appBarTitle = 'Reminderp';
    if (selectedListId != null) {
      final lists = listsAsync.valueOrNull;
      if (lists != null) {
        final match = lists.where((l) => l.id == selectedListId).firstOrNull;
        if (match != null) appBarTitle = match.name;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
        actions: [
          Builder(
            builder: (scaffoldContext) => IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () => Scaffold.of(scaffoldContext).openEndDrawer(),
            ),
          ),
        ],
      ),
      endDrawer: const _AppDrawer(),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2040, 12, 31),
            focusedDay: selectedDate,
            calendarFormat: calendarFormat,
            selectedDayPredicate: (day) => isSameDay(day, selectedDate),
            onDaySelected: (selected, focused) {
              ref.read(selectedDateProvider.notifier).state = DateTime.utc(
                selected.year,
                selected.month,
                selected.day,
              );
            },
            onFormatChanged: (format) {
              ref.read(calendarFormatProvider.notifier).state = format;
            },
            eventLoader: (day) {
              final map = remindersByDate.valueOrNull;
              if (map == null) return [];
              final key = DateTime.utc(day.year, day.month, day.day);
              return map[key] ?? [];
            },
            calendarStyle: CalendarStyle(
              defaultTextStyle: TextStyle(color: theme.colorScheme.onSurface),
              weekendTextStyle: TextStyle(color: theme.colorScheme.onSurface),
              outsideTextStyle: TextStyle(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
              ),
              markerDecoration: BoxDecoration(
                color: theme.colorScheme.primary,
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: theme.colorScheme.primary,
                shape: BoxShape.circle,
              ),
            ),
            headerStyle: HeaderStyle(
              formatButtonShowsNext: false,
              titleTextStyle: TextStyle(
                color: theme.colorScheme.onSurface,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              leftChevronIcon: Icon(
                Icons.chevron_left,
                color: theme.colorScheme.onSurface,
              ),
              rightChevronIcon: Icon(
                Icons.chevron_right,
                color: theme.colorScheme.onSurface,
              ),
              formatButtonTextStyle: TextStyle(
                color: theme.colorScheme.onSurface,
              ),
              formatButtonDecoration: BoxDecoration(
                border: Border.all(color: theme.colorScheme.outline),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: TextStyle(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              weekendStyle: TextStyle(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                DateFormat.yMMMMd().format(selectedDate),
                style: theme.textTheme.titleMedium,
              ),
            ),
          ),
          Expanded(
            child: remindersForDay.when(
              data: (reminders) => DayRemindersList(reminders: reminders),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final created = await Navigator.of(context).push<bool>(
            MaterialPageRoute(
              builder: (_) => CreateReminderScreen(
                initialDate: selectedDate,
                initialListId: selectedListId,
              ),
            ),
          );
          if (created == true) {
            ref.invalidate(allRemindersProvider);
            ref.invalidate(allTriggersProvider);
            ref.invalidate(remindersByDateProvider);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _AppDrawer extends ConsumerWidget {
  const _AppDrawer();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final selectedListId = ref.watch(selectedListProvider);
    final listsAsync = ref.watch(allReminderListsProvider);

    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
              child: Text(
                'Reminderp',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontSize: 20,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
            const Divider(),

            // Sign in
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'Account',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurfaceVariant,
                  fontSize: 12,
                  letterSpacing: 1,
                ),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.person_outline,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              title: const Text('Sign in to sync'),
              subtitle: Text(
                'Back up & sync across devices',
                style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
              ),
              trailing: Icon(
                Icons.chevron_right,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (_) => const SignInScreen()));
              },
            ),
            const Divider(),

            // Lists
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'Lists',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurfaceVariant,
                  fontSize: 12,
                  letterSpacing: 1,
                ),
              ),
            ),

            // "All" option
            _DrawerListTile(
              icon: Icons.inbox,
              label: 'All Reminders',
              selected: selectedListId == null,
              onTap: () {
                ref.read(selectedListProvider.notifier).state = null;
                Navigator.pop(context);
              },
            ),

            // Data-driven lists
            Expanded(
              child: listsAsync.when(
                data: (lists) => ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: lists.length,
                  itemBuilder: (context, index) {
                    final list = lists[index];
                    return _DrawerListTile(
                      icon: iconFromName(list.iconName),
                      label: list.name,
                      selected: selectedListId == list.id,
                      onTap: () {
                        ref.read(selectedListProvider.notifier).state = list.id;
                        Navigator.pop(context);
                      },
                      onLongPress: () {
                        Navigator.pop(context);
                        _showListOptionsSheet(context, ref, list);
                      },
                    );
                  },
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Error: $e')),
              ),
            ),

            const Divider(),

            // Add list button
            ListTile(
              leading: Icon(Icons.add, color: theme.colorScheme.primary),
              title: Text(
                'New List',
                style: TextStyle(color: theme.colorScheme.primary),
              ),
              onTap: () {
                Navigator.pop(context);
                _showCreateListDialog(context, ref);
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _showListOptionsSheet(
    BuildContext context,
    WidgetRef ref,
    ReminderList list,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: const Text('Rename'),
              onTap: () {
                Navigator.pop(ctx);
                _showRenameDialog(context, ref, list);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.delete_outline,
                color: Theme.of(context).colorScheme.error,
              ),
              title: Text(
                'Delete',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
              onTap: () {
                Navigator.pop(ctx);
                _showDeleteConfirmation(context, ref, list);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateListDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    String selectedIcon = availableListIcons.first.$1;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('New List'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'List name',
                  hintText: 'e.g. Groceries',
                ),
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Icon', style: Theme.of(ctx).textTheme.bodySmall),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: availableListIcons.map((entry) {
                  final (name, icon) = entry;
                  final isSelected = name == selectedIcon;
                  return IconButton(
                    icon: Icon(icon),
                    color: isSelected
                        ? Theme.of(ctx).colorScheme.primary
                        : Theme.of(ctx).colorScheme.onSurfaceVariant,
                    style: isSelected
                        ? IconButton.styleFrom(
                            backgroundColor: Theme.of(
                              ctx,
                            ).colorScheme.primary.withValues(alpha: 0.15),
                          )
                        : null,
                    onPressed: () {
                      setDialogState(() => selectedIcon = name);
                    },
                  );
                }).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () async {
                final name = nameController.text.trim();
                if (name.isEmpty) return;
                final db = ref.read(dbServiceProvider);
                final list = ReminderList()
                  ..name = name
                  ..iconName = selectedIcon
                  ..createdAt = DateTime.now();
                await db.createReminderList(list);
                ref.invalidate(allReminderListsProvider);
                if (ctx.mounted) Navigator.pop(ctx);
              },
              child: const Text('Create'),
            ),
          ],
        ),
      ),
    );
  }

  void _showRenameDialog(
    BuildContext context,
    WidgetRef ref,
    ReminderList list,
  ) {
    final nameController = TextEditingController(text: list.name);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Rename List'),
        content: TextField(
          controller: nameController,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'List name'),
          textCapitalization: TextCapitalization.sentences,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              final name = nameController.text.trim();
              if (name.isEmpty) return;
              final db = ref.read(dbServiceProvider);
              list.name = name;
              await db.updateReminderList(list);
              ref.invalidate(allReminderListsProvider);
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Rename'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    WidgetRef ref,
    ReminderList list,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete List'),
        content: Text(
          'Delete "${list.name}"? Reminders in this list will become uncategorized.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
            ),
            onPressed: () async {
              final db = ref.read(dbServiceProvider);
              await db.unassignRemindersFromList(list.id);
              await db.deleteReminderList(list.id);
              // If we were viewing this list, go back to all
              if (ref.read(selectedListProvider) == list.id) {
                ref.read(selectedListProvider.notifier).state = null;
              }
              ref.invalidate(allReminderListsProvider);
              ref.invalidate(allRemindersProvider);
              ref.invalidate(remindersByDateProvider);
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _DrawerListTile extends StatelessWidget {
  const _DrawerListTile({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
    this.onLongPress,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = selected
        ? theme.colorScheme.primary
        : theme.colorScheme.onSurface;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(label, style: TextStyle(color: color)),
      selected: selected,
      selectedTileColor: theme.colorScheme.primary.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      onTap: onTap,
      onLongPress: onLongPress,
    );
  }
}
