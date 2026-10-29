import 'package:flutter_test/flutter_test.dart';
import 'package:upa_break/logic/streak.dart';
import 'package:upa_break/models/break_log.dart';
import 'package:upa_break/models/settings.dart';

void main() {
  const s = UserSettings(onboarded: true); // mục tiêu 8, T2–T6
  final goal = s.dailyGoal;

  Map<String, int> met(List<DateTime> days) => {for (final d in days) dayKey(d): goal};

  test('chưa có gì thì streak = 0', () {
    expect(Streak.compute(countsByDay: {}, settings: s, now: DateTime(2026, 11, 4, 10)), 0);
  });

  test('cuối tuần không làm đứt streak', () {
    // T5 29/10, T6 30/10 đạt; T7, CN nghỉ; hôm nay T2 2/11 đang làm dở.
    final counts = met([DateTime(2026, 10, 29), DateTime(2026, 10, 30)]);
    expect(Streak.compute(countsByDay: counts, settings: s, now: DateTime(2026, 11, 2, 10)), 2);
  });

  test('hôm nay đạt thì tính luôn hôm nay', () {
    final counts = met([DateTime(2026, 10, 30), DateTime(2026, 11, 2)]);
    expect(Streak.compute(countsByDay: counts, settings: s, now: DateTime(2026, 11, 2, 16)), 2);
  });

  test('khiên streak bỏ qua 1 ngày lỡ nếu 3 ngày trước đó đều đạt', () {
    // Đạt: T2 26, T3 27, T4 28; lỡ T5 29; đạt T6 30. Hôm nay T2 2/11.
    final counts = met([
      DateTime(2026, 10, 26),
      DateTime(2026, 10, 27),
      DateTime(2026, 10, 28),
      DateTime(2026, 10, 30),
    ]);
    expect(Streak.compute(countsByDay: counts, settings: s, now: DateTime(2026, 11, 2, 9)), 4);
  });

  test('lỡ 2 ngày trong cùng tháng thì đứt', () {
    final counts = met([
      DateTime(2026, 10, 19),
      DateTime(2026, 10, 20),
      DateTime(2026, 10, 21),
      // lỡ 22
      DateTime(2026, 10, 23),
      DateTime(2026, 10, 26),
      DateTime(2026, 10, 27),
      // lỡ 28
      DateTime(2026, 10, 29),
      DateTime(2026, 10, 30),
    ]);
    // Từ 30 lùi về: 30, 29 đạt; 28 lỡ -> khiên tháng 10 (26, 27, 23 đạt) ; 27, 26, 23 đạt; 22 lỡ -> đã dùng khiên tháng 10 -> dừng.
    expect(Streak.compute(countsByDay: counts, settings: s, now: DateTime(2026, 11, 2, 9)), 5);
  });
}
