import '../models/settings.dart';

/// Tính trước các mốc giờ cần nhắc (hàm thuần, dễ test).
///
/// - Chỉ nhắc trong giờ làm, bỏ qua giờ nghỉ trưa và ngày nghỉ.
/// - Đạt mục tiêu ngày thì thôi nhắc ngày đó.
/// - Bỏ qua khoảng đang tạm dừng ("Đang họp").
/// - Tối đa [maxScheduled] lời nhắc (iOS chỉ giữ 64 thông báo chờ).
class ReminderPlanner {
  static const maxScheduled = 40;

  /// Nếu lời nhắc đầu tiên đã trễ (ngồi quá lâu), nhắc lại sau bấy nhiêu phút.
  static const overdueDelayMinutes = 10;

  static List<DateTime> plan({
    required UserSettings settings,
    required DateTime now,
    required DateTime? lastBreak,
    required int doneToday,
    DateTime? pausedUntil,
    int horizonDays = 7,
  }) {
    final s = settings;
    final out = <DateTime>[];
    final interval = s.mode.intervalMinutes;
    final goal = s.dailyGoal;

    for (var d = 0; d <= horizonDays && out.length < maxScheduled; d++) {
      final date = DateTime(now.year, now.month, now.day + d);
      if (!s.isWorkDay(date)) continue;

      final start = date.add(Duration(minutes: s.workStart));
      final end = date.add(Duration(minutes: s.workEnd));
      final lunchStart = date.add(Duration(minutes: s.lunchStart));
      final lunchEnd = date.add(Duration(minutes: s.lunchEnd));

      var count = d == 0 ? doneToday : 0;
      if (count >= goal) continue;

      var ref = start;
      if (d == 0 && lastBreak != null && lastBreak.isAfter(start)) ref = lastBreak;

      var gap = interval;
      if (d == 0 && s.mode == ReminderMode.smart) {
        gap = _smartGap(s, now, start, end, doneToday, interval);
      }

      var t = ref.add(Duration(minutes: gap));
      if (d == 0 && t.isBefore(now)) {
        t = now.add(const Duration(minutes: overdueDelayMinutes));
      }

      var guard = 0;
      while (t.isBefore(end) && count < goal && out.length < maxScheduled && guard++ < 200) {
        if (pausedUntil != null && t.isBefore(pausedUntil)) {
          t = pausedUntil.add(const Duration(minutes: 5));
          continue;
        }
        if (s.lunchEnabled && !t.isBefore(lunchStart) && t.isBefore(lunchEnd)) {
          t = lunchEnd.add(const Duration(minutes: 30));
          continue;
        }
        if (t.isBefore(start)) {
          t = start.add(Duration(minutes: interval));
          continue;
        }
        if (t.isAfter(now)) {
          out.add(t);
          count++;
        }
        t = t.add(Duration(minutes: interval));
      }
    }
    return out;
  }

  /// Thông minh: đang vượt tiến độ thì giãn ra, bị chậm thì nhắc sớm hơn.
  static int _smartGap(
    UserSettings s,
    DateTime now,
    DateTime start,
    DateTime end,
    int done,
    int interval,
  ) {
    if (now.isBefore(start) || !now.isBefore(end)) return interval;
    final elapsed = now.difference(start).inMinutes;
    final total = end.difference(start).inMinutes;
    final expected = s.dailyGoal * elapsed / total;
    if (done >= expected + 1) return interval + 30;
    if (done < expected - 1) return interval - 20;
    return interval;
  }
}
