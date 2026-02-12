import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../models/reminder.dart';
import '../models/trigger.dart';
import '../providers/reminder_provider.dart';
import '../utils/icon_helpers.dart';

class CreateReminderScreen extends ConsumerStatefulWidget {
  const CreateReminderScreen({
    super.key,
    required this.initialDate,
    this.initialListId,
  });

  final DateTime initialDate;
  final int? initialListId;

  @override
  ConsumerState<CreateReminderScreen> createState() =>
      _CreateReminderScreenState();
}

class _CreateReminderScreenState extends ConsumerState<CreateReminderScreen> {
  final _bodyController = TextEditingController();
  late DateTime _selectedDate;
  TimeOfDay _selectedTime = TimeOfDay.now();
  DateTimeRange? _selectedRange;
  List<_SmartSuggestion> _smartSuggestions = [];
  bool _showDateField = false;
  bool _saving = false;
  int? _selectedListId;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    _selectedListId = widget.initialListId;
    _bodyController.addListener(_handleBodyChanged);
    _updateSmartSuggestions(_bodyController.text);
  }

  @override
  void dispose() {
    _bodyController.removeListener(_handleBodyChanged);
    _bodyController.dispose();
    super.dispose();
  }

  void _handleBodyChanged() {
    _updateSmartSuggestions(_bodyController.text);
  }

  void _updateSmartSuggestions(String input) {
    final normalized = input.trim().toLowerCase();
    final currentToken = normalized.split(RegExp(r'\s+')).lastOrNull ?? '';
    final suggestions = <_SmartSuggestion>[];

    void addKeywordSuggestion({
      required String keyword,
      required String label,
      String? completion,
      required VoidCallback apply,
    }) {
      if (currentToken.isEmpty || keyword.startsWith(currentToken)) {
        suggestions.add(
          _SmartSuggestion(
            label: label,
            completion: completion ?? keyword,
            apply: apply,
          ),
        );
      }
    }

    addKeywordSuggestion(
      keyword: 'today',
      label: 'today',
      apply: () => _applyDate(DateTime.now()),
    );
    addKeywordSuggestion(
      keyword: 'tomorrow',
      label: 'tomorrow',
      apply: () => _applyDate(DateTime.now().add(const Duration(days: 1))),
    );
    addKeywordSuggestion(
      keyword: 'tonight',
      label: 'tonight',
      apply: () {
        _applyDate(DateTime.now());
        _applyTime(const TimeOfDay(hour: 20, minute: 0));
      },
    );
    addKeywordSuggestion(
      keyword: 'morning',
      label: 'morning 9:00 AM',
      apply: () => _applyTime(const TimeOfDay(hour: 9, minute: 0)),
    );
    addKeywordSuggestion(
      keyword: 'afternoon',
      label: 'afternoon 2:00 PM',
      apply: () => _applyTime(const TimeOfDay(hour: 14, minute: 0)),
    );
    addKeywordSuggestion(
      keyword: 'evening',
      label: 'evening 6:00 PM',
      apply: () => _applyTime(const TimeOfDay(hour: 18, minute: 0)),
    );
    addKeywordSuggestion(
      keyword: 'next',
      label: 'next week (range)',
      completion: 'next week',
      apply: () {
        final now = DateTime.now();
        final start = DateTime(now.year, now.month, now.day + 1);
        final end = DateTime(now.year, now.month, now.day + 7);
        _applyRange(DateTimeRange(start: start, end: end));
      },
    );

    final explicitDateMatch = RegExp(
      r'\b(\d{1,2})\/(\d{1,2})(?:\/(\d{2,4}))?\b',
    ).firstMatch(input);
    if (explicitDateMatch != null) {
      final month = int.tryParse(explicitDateMatch.group(1)!);
      final day = int.tryParse(explicitDateMatch.group(2)!);
      final yearText = explicitDateMatch.group(3);
      if (month != null && day != null) {
        final now = DateTime.now();
        int year = now.year;
        if (yearText != null) {
          final parsedYear = int.tryParse(yearText);
          if (parsedYear != null) {
            year = parsedYear < 100 ? 2000 + parsedYear : parsedYear;
          }
        }
        final parsedDate = DateTime(year, month, day);
        if (parsedDate.month == month && parsedDate.day == day) {
          suggestions.add(
            _SmartSuggestion(
              label: 'use ${DateFormat.yMMMd().format(parsedDate)}',
              completion: explicitDateMatch.group(0)!,
              apply: () => _applyDate(parsedDate),
            ),
          );
        }
      }
    }

    final explicitTimeMatch = RegExp(
      r'\b(\d{1,2})(?::(\d{2}))?\s?(am|pm)\b',
      caseSensitive: false,
    ).firstMatch(input);
    if (explicitTimeMatch != null) {
      var hour = int.tryParse(explicitTimeMatch.group(1)!);
      final minute = int.tryParse(explicitTimeMatch.group(2) ?? '0');
      final meridiem = explicitTimeMatch.group(3)?.toLowerCase();
      if (hour != null &&
          minute != null &&
          minute >= 0 &&
          minute < 60 &&
          meridiem != null) {
        if (hour == 12) {
          hour = meridiem == 'am' ? 0 : 12;
        } else if (meridiem == 'pm') {
          hour += 12;
        }
        if (hour >= 0 && hour < 24) {
          final parsedTime = TimeOfDay(hour: hour, minute: minute);
          suggestions.add(
            _SmartSuggestion(
              label: 'use ${_formatTime(parsedTime)}',
              completion: explicitTimeMatch.group(0)!,
              apply: () => _applyTime(parsedTime),
            ),
          );
        }
      }
    }

    setState(() {
      _smartSuggestions = suggestions.take(5).toList();
    });
  }

  void _applyDate(DateTime date) {
    setState(() {
      _selectedDate = DateTime(date.year, date.month, date.day);
      _showDateField = true;
    });
  }

  void _applyTime(TimeOfDay time) {
    setState(() {
      _selectedTime = time;
      _showDateField = true;
    });
  }

  void _applyRange(DateTimeRange range) {
    setState(() {
      _selectedRange = range;
      _selectedDate = range.start;
      _showDateField = true;
    });
  }

  void _autocompleteWith(String completion) {
    final text = _bodyController.text;
    final trimmedRight = text.replaceFirst(RegExp(r'\s+$'), '');
    final hasSpace = trimmedRight.contains(' ');
    final beforeLast = hasSpace
        ? trimmedRight.substring(0, trimmedRight.lastIndexOf(' ') + 1)
        : '';
    final newText = '$beforeLast$completion ';
    _bodyController.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }

  String _formatTime(TimeOfDay value) {
    final now = DateTime.now();
    final dateTime = DateTime(
      now.year,
      now.month,
      now.day,
      value.hour,
      value.minute,
    );
    return DateFormat.jm().format(dateTime);
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2040),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  Future<void> _pickDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2040),
      initialDateRange: _selectedRange,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
    );
    if (picked != null) {
      setState(() {
        _selectedRange = picked;
        _selectedDate = picked.start;
      });
    }
  }

  Future<void> _save() async {
    setState(() => _saving = true);

    final db = ref.read(dbServiceProvider);

    final trigger = Trigger()
      ..at = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );
    final triggerId = await db.createTrigger(trigger);

    final reminder = Reminder()
      ..body = _bodyController.text.trim().isEmpty
          ? null
          : _bodyController.text.trim()
      ..createdAt = DateTime.now()
      ..triggerId = triggerId
      ..listId = _selectedListId;
    await db.createReminder(reminder);

    if (mounted) {
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Reminder'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_smartSuggestions.isNotEmpty) ...[
              SizedBox(
                height: 36,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _smartSuggestions.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final suggestion = _smartSuggestions[index];
                    return ActionChip(
                      label: Text(suggestion.label),
                      onPressed: () {
                        _autocompleteWith(suggestion.completion);
                        suggestion.apply();
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
            ],
            TextField(
              controller: _bodyController,
              decoration: const InputDecoration(
                hintText: 'What do you want to be reminded about?',
                border: OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.sentences,
              maxLines: 3,
              autofocus: true,
            ),
            const SizedBox(height: 16),
            _ListPickerDropdown(
              selectedListId: _selectedListId,
              onChanged: (id) => setState(() => _selectedListId = id),
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 8,
              children: [
                ActionChip(
                  avatar: const Icon(Icons.calendar_today, size: 18),
                  label: Text(_showDateField ? 'Date ▲' : 'Date ▼'),
                  onPressed: () {
                    setState(() => _showDateField = !_showDateField);
                  },
                ),
              ],
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOut,
              child: _showDateField
                  ? Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: _pickDate,
                            borderRadius: BorderRadius.circular(4),
                            child: InputDecorator(
                              decoration: const InputDecoration(
                                labelText: 'Date',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.calendar_today),
                                suffixIcon: Icon(Icons.edit_calendar),
                              ),
                              child: Text(
                                DateFormat.yMMMMd().format(_selectedDate),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          InkWell(
                            onTap: _pickTime,
                            borderRadius: BorderRadius.circular(4),
                            child: InputDecorator(
                              decoration: const InputDecoration(
                                labelText: 'Time',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.access_time),
                                suffixIcon: Icon(Icons.edit),
                              ),
                              child: Text(_selectedTime.format(context)),
                            ),
                          ),
                          const SizedBox(height: 12),
                          InkWell(
                            onTap: _pickDateRange,
                            borderRadius: BorderRadius.circular(4),
                            child: InputDecorator(
                              decoration: const InputDecoration(
                                labelText: 'Range',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.date_range),
                                suffixIcon: Icon(Icons.edit_calendar),
                              ),
                              child: Text(
                                _selectedRange == null
                                    ? 'No range selected'
                                    : '${DateFormat.yMMMd().format(_selectedRange!.start)} - ${DateFormat.yMMMd().format(_selectedRange!.end)}',
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AnimatedPadding(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SafeArea(
          top: false,
          minimum: const EdgeInsets.all(16),
          child: FilledButton.icon(
            onPressed: _saving ? null : _save,
            icon: _saving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.check),
            label: const Text('Save Reminder'),
          ),
        ),
      ),
    );
  }
}

class _SmartSuggestion {
  const _SmartSuggestion({
    required this.label,
    required this.completion,
    required this.apply,
  });

  final String label;
  final String completion;
  final VoidCallback apply;
}

class _ListPickerDropdown extends ConsumerWidget {
  const _ListPickerDropdown({
    required this.selectedListId,
    required this.onChanged,
  });

  final int? selectedListId;
  final ValueChanged<int?> onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listsAsync = ref.watch(allReminderListsProvider);

    return listsAsync.when(
      data: (lists) => DropdownButtonFormField<int?>(
        value: lists.any((l) => l.id == selectedListId)
            ? selectedListId
            : null,
        decoration: const InputDecoration(
          labelText: 'List',
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.list),
        ),
        items: [
          const DropdownMenuItem<int?>(
            value: null,
            child: Text('None'),
          ),
          ...lists.map(
            (list) => DropdownMenuItem<int?>(
              value: list.id,
              child: Row(
                children: [
                  Icon(iconFromName(list.iconName), size: 20),
                  const SizedBox(width: 8),
                  Text(list.name),
                ],
              ),
            ),
          ),
        ],
        onChanged: onChanged,
      ),
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}
