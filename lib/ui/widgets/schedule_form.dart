import 'package:flutter/material.dart';

import '../../l10n/l10n.dart';
import '../../models/settings.dart';

/// Các khối nhập liệu dùng chung cho Onboarding và Cài đặt.

Future<int?> pickMinutes(BuildContext context, int current) async {
  final picked = await showTimePicker(
    context: context,
    initialTime: TimeOfDay(hour: current ~/ 60, minute: current % 60),
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
      child: child!,
    ),
  );
  return picked == null ? null : picked.hour * 60 + picked.minute;
}

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 8),
        child: Text(text,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
      );
}

class TimeRangeTile extends StatelessWidget {
  const TimeRangeTile({
    super.key,
    required this.label,
    required this.start,
    required this.end,
    required this.onChanged,
    this.enabled = true,
  });

  final String label;
  final int start;
  final int end;
  final bool enabled;
  final void Function(int start, int end) onChanged;

  @override
  Widget build(BuildContext context) {
    Widget chip(int value, bool isStart) => ActionChip(
          label: Text(formatMinutes(value), style: const TextStyle(fontSize: 16)),
          onPressed: !enabled
              ? null
              : () async {
                  final v = await pickMinutes(context, value);
                  if (v == null) return;
                  isStart ? onChanged(v, end) : onChanged(start, v);
                },
        );
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            Expanded(child: Text(label)),
            chip(start, true),
            const Padding(padding: EdgeInsets.symmetric(horizontal: 6), child: Text('–')),
            chip(end, false),
          ],
        ),
      ),
    );
  }
}

class WorkDaysPicker extends StatelessWidget {
  const WorkDaysPicker({super.key, required this.days, required this.onChanged});
  final Set<int> days;
  final ValueChanged<Set<int>> onChanged;

  @override
  Widget build(BuildContext context) => Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (var wd = 1; wd <= 7; wd++)
            FilterChip(
              label: Text(context.l10n.weekdayShort(wd)),
              selected: days.contains(wd),
              onSelected: (on) {
                final next = {...days};
                on ? next.add(wd) : next.remove(wd);
                if (next.isNotEmpty) onChanged(next);
              },
            ),
        ],
      );
}

class ModePicker extends StatelessWidget {
  const ModePicker({super.key, required this.mode, required this.onChanged});
  final ReminderMode mode;
  final ValueChanged<ReminderMode> onChanged;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          for (final m in ReminderMode.values)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Card(
                color: m == mode ? Theme.of(context).colorScheme.primaryContainer : null,
                child: ListTile(
                  onTap: () => onChanged(m),
                  leading: Icon(
                    m == mode ? Icons.radio_button_checked : Icons.radio_button_off,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  title: Text(context.l10n.modeLabel(m), style: const TextStyle(fontWeight: FontWeight.w700)),
                  subtitle: Text(context.l10n.modeDescription(m)),
                ),
              ),
            ),
        ],
      );
}

class AreaPicker extends StatelessWidget {
  const AreaPicker({super.key, required this.areas, required this.onChanged});
  final Set<BodyArea> areas;
  final ValueChanged<Set<BodyArea>> onChanged;

  @override
  Widget build(BuildContext context) => Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final a in BodyArea.values)
            FilterChip(
              label: Text('${a.emoji} ${context.l10n.areaLabel(a)}'),
              selected: areas.contains(a),
              onSelected: (on) {
                final next = {...areas};
                on ? next.add(a) : next.remove(a);
                onChanged(next);
              },
            ),
        ],
      );
}
