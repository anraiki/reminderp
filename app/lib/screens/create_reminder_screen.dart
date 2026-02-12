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
    this.existingReminderId,
    this.startInViewMode = false,
  });

  final DateTime initialDate;
  final int? initialListId;
  final int? existingReminderId;
  final bool startInViewMode;

  @override
  ConsumerState<CreateReminderScreen> createState() =>
      _CreateReminderScreenState();
}

class _CreateReminderScreenState extends ConsumerState<CreateReminderScreen> {
  final _bodyController = TextEditingController();
  late DateTime _selectedDate;
  TimeOfDay _selectedTime = TimeOfDay.now();
  DateTimeRange? _selectedRange;
  bool _isRecurring = false;
  String _recurrence = 'daily';
  List<_SmartSuggestion> _smartSuggestions = [];
  bool _saving = false;
  bool _loadingExisting = false;
  bool _viewMode = false;
  int? _selectedListId;
  Reminder? _editingReminder;
  Trigger? _editingTrigger;
  int? _editingTriggerId;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    _selectedListId = widget.initialListId;
    _viewMode = widget.startInViewMode;
    _bodyController.addListener(_handleBodyChanged);
    _updateSmartSuggestions(_bodyController.text);
    if (widget.existingReminderId != null) {
      _loadExistingReminder(widget.existingReminderId!);
    }
  }

  @override
  void dispose() {
    _bodyController.removeListener(_handleBodyChanged);
    _bodyController.dispose();
    super.dispose();
  }

  void _handleBodyChanged() {
    if (_viewMode) return;
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

    if (!mounted) return;
    setState(() {
      _smartSuggestions = suggestions.take(5).toList();
    });
  }

  Future<void> _loadExistingReminder(int id) async {
    setState(() => _loadingExisting = true);
    final db = ref.read(dbServiceProvider);
    final reminder = await db.getReminder(id);
    if (!mounted) return;
    if (reminder == null) {
      setState(() => _loadingExisting = false);
      return;
    }

    Trigger? trigger;
    if (reminder.triggerId != null) {
      trigger = await db.getTrigger(reminder.triggerId!);
    }
    if (!mounted) return;

    _editingReminder = reminder;
    _editingTrigger = trigger;
    _editingTriggerId = reminder.triggerId;
    _bodyController.text = reminder.body ?? '';
    _selectedListId = reminder.listId;
    if (trigger != null) {
      _selectedDate = DateTime(
        trigger.at.year,
        trigger.at.month,
        trigger.at.day,
      );
      _selectedTime = TimeOfDay(
        hour: trigger.at.hour,
        minute: trigger.at.minute,
      );
      _isRecurring = trigger.every != null;
      _recurrence = trigger.every ?? _recurrence;
    }
    setState(() => _loadingExisting = false);
  }

  void _applyDate(DateTime date) {
    setState(() {
      _selectedDate = DateTime(date.year, date.month, date.day);
    });
  }

  void _applyTime(TimeOfDay time) {
    setState(() {
      _selectedTime = time;
    });
  }

  void _applyRange(DateTimeRange range) {
    setState(() {
      _selectedRange = range;
      _selectedDate = range.start;
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

    final trigger = _editingTrigger ?? Trigger()
      ..at = DateTime.now();
    trigger.at = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );
    trigger.every = _isRecurring ? _recurrence : null;
    trigger.times = null;

    final triggerId = _editingTriggerId != null
        ? await db.updateTrigger(trigger)
        : await db.createTrigger(trigger);

    final reminder = _editingReminder ?? Reminder()
      ..createdAt = DateTime.now();

    reminder
      ..body = _bodyController.text.trim().isEmpty
          ? null
          : _bodyController.text.trim()
      ..updatedAt = DateTime.now()
      ..triggerId = triggerId
      ..listId = _selectedListId;

    if (_editingReminder != null) {
      await db.updateReminder(reminder);
    } else {
      await db.createReminder(reminder);
    }

    if (mounted) {
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingReminderId != null;
    final title = switch ((isEditing, _viewMode)) {
      (false, _) => 'New Reminder',
      (true, true) => 'Reminder Details',
      (true, false) => 'Edit Reminder',
    };

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          if (isEditing)
            IconButton(
              tooltip: _viewMode ? 'Edit reminder' : 'View mode',
              icon: Icon(_viewMode ? Icons.edit_outlined : Icons.visibility),
              onPressed: () {
                final nextViewMode = !_viewMode;
                if (!nextViewMode) {
                  _updateSmartSuggestions(_bodyController.text);
                }
                setState(() => _viewMode = nextViewMode);
              },
            ),
        ],
      ),
      body: _loadingExisting
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AnimatedSize(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOut,
                    child: (!_viewMode && _smartSuggestions.isNotEmpty)
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: SizedBox(
                              height: 36,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: _smartSuggestions.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(width: 8),
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
                          )
                        : const SizedBox.shrink(),
                  ),
                  TextField(
                    controller: _bodyController,
                    enabled: !_viewMode,
                    readOnly: _viewMode,
                    decoration: const InputDecoration(
                      hintText: 'What do you want to be reminded about?',
                      border: OutlineInputBorder(),
                    ),
                    textCapitalization: TextCapitalization.sentences,
                    maxLines: 3,
                    autofocus: widget.existingReminderId == null,
                  ),
                  const SizedBox(height: 16),
                  _ListPickerDropdown(
                    selectedListId: _selectedListId,
                    enabled: !_viewMode,
                    onChanged: (id) => setState(() => _selectedListId = id),
                  ),
                  const SizedBox(height: 24),
                  InkWell(
                    onTap: _viewMode ? null : _pickDate,
                    borderRadius: BorderRadius.circular(4),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Date',
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.calendar_today),
                        suffixIcon: _viewMode
                            ? null
                            : const Icon(Icons.edit_calendar),
                      ),
                      child: Text(DateFormat.yMMMMd().format(_selectedDate)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: _viewMode ? null : _pickTime,
                    borderRadius: BorderRadius.circular(4),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Time',
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.access_time),
                        suffixIcon: _viewMode ? null : const Icon(Icons.edit),
                      ),
                      child: Text(_selectedTime.format(context)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: _viewMode ? null : _pickDateRange,
                    borderRadius: BorderRadius.circular(4),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Range',
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.date_range),
                        suffixIcon: _viewMode
                            ? null
                            : const Icon(Icons.edit_calendar),
                      ),
                      child: Text(
                        _selectedRange == null
                            ? 'No range selected'
                            : '${DateFormat.yMMMd().format(_selectedRange!.start)} - ${DateFormat.yMMMd().format(_selectedRange!.end)}',
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (!_viewMode) ...[
                    SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Recurring'),
                      subtitle: Text(
                        _isRecurring ? 'Repeat $_recurrence' : 'Remind once',
                      ),
                      value: _isRecurring,
                      onChanged: (value) =>
                          setState(() => _isRecurring = value),
                    ),
                    if (_isRecurring) ...[
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        initialValue: _recurrence,
                        decoration: const InputDecoration(
                          labelText: 'Repeat',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.repeat),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'daily',
                            child: Text('Daily'),
                          ),
                          DropdownMenuItem(
                            value: 'weekly',
                            child: Text('Weekly'),
                          ),
                          DropdownMenuItem(
                            value: 'monthly',
                            child: Text('Monthly'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _recurrence = value);
                          }
                        },
                      ),
                    ],
                  ],
                ],
              ),
            ),
      bottomNavigationBar: _viewMode
          ? null
          : AnimatedPadding(
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
                  label: Text(isEditing ? 'Save Changes' : 'Save Reminder'),
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
    this.enabled = true,
  });

  final int? selectedListId;
  final ValueChanged<int?> onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listsAsync = ref.watch(allReminderListsProvider);

    return listsAsync.when(
      data: (lists) => DropdownButtonFormField<int?>(
        initialValue: lists.any((l) => l.id == selectedListId)
            ? selectedListId
            : null,
        decoration: const InputDecoration(
          labelText: 'List',
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.list),
        ),
        items: [
          const DropdownMenuItem<int?>(value: null, child: Text('None')),
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
        onChanged: enabled ? onChanged : null,
      ),
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}
