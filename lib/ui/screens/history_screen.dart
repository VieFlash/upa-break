import 'package:flutter/material.dart';

import '../../data/exercises.dart';
import '../../models/settings.dart';
import '../../state/app_state.dart';
import '../theme.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  static const _wd = {1: 'T2', 2: 'T3', 3: 'T4', 4: 'T5', 5: 'T6', 6: 'T7', 7: 'CN'};

  @override
  Widget build(BuildContext context) {
    final s = AppScope.of(context);
    final t = Theme.of(context).textTheme;
    final days = s.last7Days;
    final goal = s.dailyGoal;
    final maxV = days.fold<int>(goal, (m, e) => e.$2 > m ? e.$2 : m);
    final metDays = days.where((e) => e.$2 >= goal).length;

    return Scaffold(
      appBar: AppBar(title: const Text('Nhật ký'), backgroundColor: Colors.transparent),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        children: [
          Row(
            children: [
              Expanded(child: _Stat(value: '🔥 ${s.streak}', label: 'ngày liên tiếp')),
              const SizedBox(width: 12),
              Expanded(child: _Stat(value: '🐟 ${s.fish}', label: 'cá khô')),
              const SizedBox(width: 12),
              Expanded(child: _Stat(value: '$metDays/7', label: 'ngày đạt')),
            ],
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('7 ngày gần nhất', style: t.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 160,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        for (final (day, count) in days)
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text('$count', style: t.labelMedium),
                                const SizedBox(height: 4),
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 400),
                                  width: 26,
                                  height: 110 * (count / maxV).clamp(0.04, 1.0),
                                  decoration: BoxDecoration(
                                    color: count >= goal
                                        ? AppColors.furDark
                                        : AppColors.fur.withValues(alpha: count == 0 ? 0.2 : 0.55),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(_wd[day.weekday]!, style: t.labelMedium),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('Mục tiêu: $goal lần/ngày', style: t.bodySmall),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text('Hôm nay', style: t.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          if (s.todayLogs.isEmpty)
            const Card(child: ListTile(title: Text('Chưa có lần giãn cơ nào. Upa đang chờ nè!')))
          else
            for (final log in s.todayLogs)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Card(
                  child: ListTile(
                    leading: const Text('🐾', style: TextStyle(fontSize: 22)),
                    title: Text(log.exerciseIds.map((id) => exerciseById(id).name).join(' · ')),
                    trailing: Text(formatMinutes(log.at.hour * 60 + log.at.minute)),
                  ),
                ),
              ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label});
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
          child: Column(
            children: [
              Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
              const SizedBox(height: 2),
              Text(label, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      );
}
