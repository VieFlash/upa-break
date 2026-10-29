import 'package:flutter/material.dart';

import '../../models/break_log.dart';
import '../../models/settings.dart';
import '../../state/app_state.dart';
import '../theme.dart';
import '../widgets/mascot.dart';
import 'break_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  String _headline(AppState s) => switch (s.mood) {
        Mood.fresh => 'Upa đang tỉnh táo ✨',
        Mood.slouch => 'Ngồi ${s.minutesSitting} phút rồi, Upa bắt đầu gù lưng',
        Mood.sleepy => 'Upa ngủ gục mất rồi… đứng dậy thôi!',
        Mood.proud => 'Đạt mục tiêu hôm nay rồi! 🎉',
        Mood.offHours => s.isPaused ? 'Đang họp, Upa im lặng 🤫' : 'Ngoài giờ làm, nghỉ ngơi thôi',
        Mood.stretch => 'Duỗi người nào!',
      };

  String _hhmm(DateTime t) => formatMinutes(t.hour * 60 + t.minute);

  String? _nextText(AppState s) {
    final n = s.nextReminder;
    if (n == null) return null;
    final today = dateOnly(s.now);
    final day = dateOnly(n);
    if (day == today) return 'Lời nhắc tiếp theo: ${_hhmm(n)}';
    if (day.difference(today).inDays == 1) return 'Lời nhắc tiếp theo: ${_hhmm(n)} ngày mai';
    return 'Lời nhắc tiếp theo: ${_hhmm(n)} ngày ${n.day}/${n.month}';
  }

  Future<void> _showPauseSheet(BuildContext context) async {
    final state = AppScope.read(context);
    final choice = await showModalBottomSheet<Duration?>(
      context: context,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Text('Tạm dừng nhắc trong…',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            ),
            for (final (label, d) in const [
              ('30 phút', Duration(minutes: 30)),
              ('1 tiếng', Duration(hours: 1)),
              ('2 tiếng', Duration(hours: 2)),
            ])
              ListTile(
                leading: const Icon(Icons.timer_outlined),
                title: Text(label),
                onTap: () => Navigator.pop(ctx, d),
              ),
            ListTile(
              leading: const Icon(Icons.nights_stay_outlined),
              title: const Text('Hết hôm nay'),
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
    final t = Theme.of(context).textTheme;
    final next = _nextText(s);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          children: [
            Row(
              children: [
                Text('Hôm nay', style: t.headlineMedium?.copyWith(fontWeight: FontWeight.w800)),
                const Spacer(),
                _Pill(text: '🐟 ${s.fish}'),
                const SizedBox(width: 8),
                _Pill(text: '🔥 ${s.streak}'),
              ],
            ),
            const SizedBox(height: 8),
            Center(child: Mascot(mood: s.mood, size: 240)),
            Text(_headline(s),
                textAlign: TextAlign.center,
                style: t.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 20),
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
                        Text(' / ${s.dailyGoal} lần giãn cơ', style: t.titleMedium),
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
                  title: Text('Tạm dừng tới ${_hhmm(s.pausedUntil!)}'),
                  trailing: TextButton(onPressed: s.resume, child: const Text('Tiếp tục')),
                ),
              ),
            ],
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: () => openQuickBreak(Navigator.of(context), s),
              icon: const Icon(Icons.self_improvement),
              label: const Text('Giãn cơ ngay · 1 phút'),
            ),
            const SizedBox(height: 10),
            if (!s.isPaused)
              OutlinedButton.icon(
                onPressed: () => _showPauseSheet(context),
                icon: const Icon(Icons.groups_outlined),
                label: const Text('Đang họp'),
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
