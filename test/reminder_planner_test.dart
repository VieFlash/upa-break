import 'package:flutter_test/flutter_test.dart';
import 'package:upa_break/logic/reminder_planner.dart';
import 'package:upa_break/models/settings.dart';

void main() {
  // 8:30–17:30, nghỉ trưa 12:00–13:00, T2–T6, Thông minh (60 phút), mục tiêu 8.
  const s = UserSettings(onboarded: true);
  // 2026-11-02 là Thứ 2.
  final monday = DateTime(2026, 11, 2);

  DateTime at(int h, int m, [DateTime? day]) => (day ?? monday).add(Duration(hours: h, minutes: m));

  test('mục tiêu mặc định = 8 lần/ngày', () {
    expect(s.dailyGoal, 8);
  });

  test('lời nhắc đầu tiên = giờ vào làm + 60 phút', () {
    final plan = ReminderPlanner.plan(settings: s, now: at(7, 0), lastBreak: null, doneToday: 0);
    expect(plan.first, at(9, 30));
  });

  test('không nhắc trong giờ nghỉ trưa', () {
    final plan = ReminderPlanner.plan(settings: s, now: at(7, 0), lastBreak: null, doneToday: 0);
    for (final t in plan) {
      final m = t.hour * 60 + t.minute;
      expect(m >= 12 * 60 && m < 13 * 60, isFalse, reason: '$t rơi vào giờ nghỉ trưa');
    }
  });

  test('chỉ nhắc trong giờ làm và ngày làm việc', () {
    final plan = ReminderPlanner.plan(settings: s, now: at(7, 0), lastBreak: null, doneToday: 0);
    for (final t in plan) {
      expect(t.weekday <= 5, isTrue, reason: '$t là cuối tuần');
      final m = t.hour * 60 + t.minute;
      expect(m >= s.workStart && m < s.workEnd, isTrue, reason: '$t ngoài giờ làm');
    }
  });

  test('đạt mục tiêu thì hôm nay thôi nhắc', () {
    final plan = ReminderPlanner.plan(settings: s, now: at(15, 0), lastBreak: at(14, 50), doneToday: 8);
    expect(plan.every((t) => t.day != monday.day), isTrue);
  });

  test('ngồi quá lâu thì nhắc lại sau 10 phút', () {
    final plan = ReminderPlanner.plan(
      settings: s.copyWith(mode: ReminderMode.focus),
      now: at(11, 0),
      lastBreak: null,
      doneToday: 0,
    );
    expect(plan.first, at(11, 10));
  });

  test('bỏ qua khoảng đang họp', () {
    final plan = ReminderPlanner.plan(
      settings: s.copyWith(mode: ReminderMode.focus),
      now: at(9, 0),
      lastBreak: at(9, 0),
      doneToday: 1,
      pausedUntil: at(11, 0),
    );
    expect(plan.first.isAfter(at(11, 0)), isTrue);
  });

  test('không vượt quá giới hạn thông báo', () {
    final plan = ReminderPlanner.plan(
      settings: s.copyWith(mode: ReminderMode.focus),
      now: at(7, 0),
      lastBreak: null,
      doneToday: 0,
      horizonDays: 30,
    );
    expect(plan.length, lessThanOrEqualTo(ReminderPlanner.maxScheduled));
  });

  test('thứ 6 sau giờ làm thì nhắc tiếp vào thứ 2', () {
    final friday = DateTime(2026, 11, 6);
    final plan = ReminderPlanner.plan(settings: s, now: at(18, 0, friday), lastBreak: null, doneToday: 0);
    expect(plan.first, at(9, 30, DateTime(2026, 11, 9)));
  });

  test('"Để sau" nhắc lại đúng 15 phút sau, kể cả qua mốc giờ', () {
    expect(ReminderPlanner.snoozeAt(DateTime(2026, 11, 2, 10, 50)), DateTime(2026, 11, 2, 11, 5));
    expect(ReminderPlanner.snoozeMinutes, 15);
  });
}
