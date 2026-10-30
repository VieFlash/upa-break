import 'package:flutter/material.dart';

import '../../l10n/l10n.dart';
import '../../models/break_log.dart';
import '../../models/settings.dart';
import '../../state/app_state.dart';
import '../theme.dart';
import '../widgets/mascot.dart';
import '../widgets/permission_banner.dart';
import 'break_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  String _headline(AppLocalizations l, AppState s) => switch (s.mood) {
        Mood.fresh => l.moodFresh,
        Mood.slouch => l.moodSlouch(s.minutesSitting),
        Mood.sleepy => l.moodSleepy,
        Mood.proud => l.moodProud,
        Mood.offHours => s.isPaused ? l.moodPaused : l.moodOffHours,
        Mood.stretch => l.moodStretch,
      };

  String _hhmm(DateTime t) => formatMinutes(t.hour * 60 + t.minute);

  String? _nextText(AppLocalizations l, AppState s) {
    final n = s.nextReminder;
    if (n == null) return null;
    final today = dateOnly(s.now);
    final day = dateOnly(n);
    if (day == today) return l.nextReminderToday(_hhmm(n));
    if (day.difference(today).inDays == 1) return l.nextReminderTomorrow(_hhmm(n));
    return l.nextReminderDate(_hhmm(n), n.day, n.month);
  }

  Future<void> _showPauseSheet(BuildContext context) async {
    final state = AppScope.read(context);
    final l = context.l10n;
    final choice = await showModalBottomSheet<Duration?>(
      context: context,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(l.pauseSheetTitle, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            ),
            for (final (label, d) in [
              (l.pause30m, const Duration(minutes: 30)),
              (l.pause1h, const Duration(hours: 1)),
              (l.pause2h, const Duration(hours: 2)),
            ])
              ListTile(
                leading: const Icon(Icons.timer_outlined),
                title: Text(label),
                onTap: () => Navigator.pop(ctx, d),
              ),
            ListTile(
              leading: const Icon(Icons.nights_stay_outlined),
              title: Text(l.pauseRestOfDay),
              onTap: () => Navigator.pop(ctx, Duration.zero),
            ),
          ],
        ),
      ),
    );
    if (choice == null) return;
    await state.pause(choice == Duration.zero ? null : choice);
  }

  @override
  Widget build(BuildContext context) {
    final s = AppScope.of(context);
    final l = context.l10n;
    final t = Theme.of(context).textTheme;
    final next = _nextText(l, s);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          children: [
            Row(
              children: [
                Text(l.tabToday, style: t.headlineMedium?.copyWith(fontWeight: FontWeight.w800)),
                const Spacer(),
                _Pill(text: '🐟 ${s.fish}'),
                const SizedBox(width: 8),
                _Pill(text: '🔥 ${s.streak}'),
              ],
            ),
            const SizedBox(height: 8),
            Center(child: Mascot(mood: s.mood, size: 240)),
            Text(_headline(l, s),
                textAlign: TextAlign.center,
                style: t.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 20),
            if (s.notificationsBlocked) ...[
              const PermissionBanner(),
              const SizedBox(height: 12),
            ],
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('${s.todayCount}',
                            style: t.headlineMedium?.copyWith(fontWeight: FontWeight.w800)),
                        Text(l.breaksOfGoal(s.dailyGoal), style: t.titleMedium),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: (s.todayCount / s.dailyGoal).clamp(0, 1).toDouble(),
                        minHeight: 12,
                        backgroundColor: AppColors.fur.withValues(alpha: 0.15),
                      ),
                    ),
                    if (next != null) ...[
                      const SizedBox(height: 10),
                      Text(next, style: t.bodyMedium?.copyWith(color: Colors.brown.shade400)),
                    ],
                  ],
                ),
              ),
            ),
            if (s.isPaused) ...[
              const SizedBox(height: 12),
              Card(
                color: const Color(0xFFE8EEFF),
                child: ListTile(
                  leading: const Icon(Icons.do_not_disturb_on_outlined, color: AppColors.blue),
                  title: Text(l.pausedUntil(_hhmm(s.pausedUntil!))),
                  trailing: TextButton(onPressed: s.resume, child: Text(l.actionResume)),
                ),
              ),
            ],
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: () => openQuickBreak(Navigator.of(context), s),
              icon: const Icon(Icons.self_improvement),
              label: Text(l.stretchNow),
            ),
            const SizedBox(height: 10),
            if (!s.isPaused)
              OutlinedButton.icon(
                onPressed: () => _showPauseSheet(context),
                icon: const Icon(Icons.groups_outlined),
                label: Text(l.inMeeting),
              ),
          ],
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.brown.withValues(alpha: 0.1)),
        ),
        child: Text(text, style: const TextStyle(fontWeight: FontWeight.w700)),
      );
}
