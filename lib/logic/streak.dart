import '../models/break_log.dart';
import '../models/settings.dart';

/// Streak = số ngày làm việc liên tiếp đạt mục tiêu.
///
/// Luật "không trách":
/// - Ngày nghỉ (không phải ngày làm việc) không tính, không làm đứt streak.
/// - Hôm nay chưa đạt thì chưa tính là lỡ (ngày còn đang diễn ra).
/// - Khiên streak: mỗi tháng được bỏ qua 1 ngày lỡ, nếu 3 ngày làm việc trước đó đều đạt.
class Streak {
  static int compute({
    required Map<String, int> countsByDay,
    required UserSettings settings,
    required DateTime now,
    int lookbackDays = 400,
  }) {
    final goal = settings.dailyGoal;
    bool met(DateTime d) => (countsByDay[dayKey(d)] ?? 0) >= goal;
    DateTime prev(DateTime d) => DateTime(d.year, d.month, d.day - 1);

    final today = dateOnly(now);
    var streak = 0;
    if (settings.isWorkDay(today) && met(today)) streak++;

    final forgivenMonths = <int>{};
    var d = prev(today);
    for (var i = 0; i < lookbackDays; i++) {
      if (!settings.isWorkDay(d)) {
        d = prev(d);
        continue;
      }
      if (met(d)) {
        streak++;
        d = prev(d);
        continue;
      }
      final monthKey = d.year * 12 + d.month;
      if (!forgivenMonths.contains(monthKey) && _olderWorkdaysMet(d, 3, settings, met, prev)) {
        forgivenMonths.add(monthKey);
        d = prev(d);
        continue;
      }
      break;
    }
    return streak;
  }

  static bool _olderWorkdaysMet(
    DateTime from,
    int n,
    UserSettings s,
    bool Function(DateTime) met,
    DateTime Function(DateTime) prev,
  ) {
    var d = prev(from);
    var found = 0;
    for (var i = 0; i < 30 && found < n; i++) {
      if (s.isWorkDay(d)) {
        if (!met(d)) return false;
        found++;
      }
      d = prev(d);
    }
    return found == n;
  }
}
