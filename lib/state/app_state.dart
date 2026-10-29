import 'package:flutter/widgets.dart';

import '../data/storage.dart';
import '../logic/reminder_planner.dart';
import '../logic/streak.dart';
import '../models/break_log.dart';
import '../models/settings.dart';
import '../services/notification_service.dart';

enum Mood { fresh, slouch, sleepy, stretch, proud, offHours }

class AppState extends ChangeNotifier {
  AppState(this._storage, this.notifications)
      : _settings = _storage.loadSettings(),
        _logs = _storage.loadLogs(),
        _pausedUntil = _storage.loadPausedUntil(),
        _fish = _storage.loadFish();

  final Storage _storage;
  final NotificationService notifications;

  UserSettings _settings;
  List<BreakLog> _logs;
  DateTime? _pausedUntil;
  int _fish;
  DateTime? _nextReminder;

  /// Cho phép test "giả" thời gian.
  DateTime Function() clock = DateTime.now;

  UserSettings get settings => _settings;
  List<BreakLog> get logs => List.unmodifiable(_logs);
  int get fish => _fish;
  DateTime? get nextReminder => _nextReminder;
  DateTime get now => clock();

  // ---------- Số liệu ----------

  Map<String, int> get countsByDay {
    final m = <String, int>{};
    for (final l in _logs) {
      final k = dayKey(l.at);
      m[k] = (m[k] ?? 0) + 1;
    }
    return m;
  }

  int countOn(DateTime day) => countsByDay[dayKey(day)] ?? 0;
  int get todayCount => countOn(now);
  int get dailyGoal => _settings.dailyGoal;
  bool get goalReachedToday => todayCount >= dailyGoal;

  List<BreakLog> get todayLogs {
    final k = dayKey(now);
    return _logs.where((l) => dayKey(l.at) == k).toList()..sort((a, b) => b.at.compareTo(a.at));
  }

  DateTime? get lastBreak =>
      _logs.isEmpty ? null : _logs.map((l) => l.at).reduce((a, b) => a.isAfter(b) ? a : b);

  int get streak => Streak.compute(countsByDay: countsByDay, settings: _settings, now: now);

  DateTime? get pausedUntil =>
      (_pausedUntil != null && _pausedUntil!.isAfter(now)) ? _pausedUntil : null;
  bool get isPaused => pausedUntil != null;

  /// Số phút đã ngồi liên tục trong giờ làm (trừ giờ nghỉ trưa).
  int get minutesSitting {
    final n = now;
    if (!_settings.isWorkingAt(n)) return 0;
    final today = dateOnly(n);
    final start = today.add(Duration(minutes: _settings.workStart));
    var ref = start;
    final lb = lastBreak;
    if (lb != null && lb.isAfter(ref)) ref = lb;
    if (_pausedUntil != null && _pausedUntil!.isAfter(ref) && _pausedUntil!.isBefore(n)) {
      ref = _pausedUntil!;
    }
    var mins = n.difference(ref).inMinutes;
    if (_settings.lunchEnabled) {
      final ls = today.add(Duration(minutes: _settings.lunchStart));
      final le = today.add(Duration(minutes: _settings.lunchEnd));
      if (ref.isBefore(le) && n.isAfter(ls)) {
        final s = ref.isAfter(ls) ? ref : ls;
        final e = n.isBefore(le) ? n : le;
        mins -= e.difference(s).inMinutes;
      }
    }
    return mins < 0 ? 0 : mins;
  }

  Mood get mood {
    if (goalReachedToday) return Mood.proud;
    if (!_settings.isWorkingAt(now) || isPaused) return Mood.offHours;
    final interval = _settings.mode.intervalMinutes;
    final m = minutesSitting;
    if (m < interval * 0.75) return Mood.fresh;
    if (m < interval * 1.5) return Mood.slouch;
    return Mood.sleepy;
  }

  /// Số lần giãn cơ trong 7 ngày gần nhất (cũ -> mới).
  List<(DateTime, int)> get last7Days {
    final counts = countsByDay;
    final today = dateOnly(now);
    return List.generate(7, (i) {
      final d = DateTime(today.year, today.month, today.day - 6 + i);
      return (d, counts[dayKey(d)] ?? 0);
    });
  }

  // ---------- Hành động ----------

  Future<void> completeOnboarding(UserSettings s) async {
    await notifications.requestPermission();
    await updateSettings(s.copyWith(onboarded: true));
  }

  Future<void> updateSettings(UserSettings s) async {
    _settings = s;
    await _storage.saveSettings(s);
    await reschedule();
    notifyListeners();
  }

  /// Trả về số cá khô nhận được.
  Future<int> logBreak(List<String> exerciseIds, int seconds) async {
    final wasGoalReached = goalReachedToday;
    _logs = [..._logs, BreakLog(at: now, exerciseIds: exerciseIds, seconds: seconds)];
    var reward = 1;
    if (!wasGoalReached && goalReachedToday) reward += 3; // thưởng thêm khi đạt mục tiêu
    _fish += reward;
    await _storage.saveLogs(_logs);
    await _storage.saveFish(_fish);
    await reschedule();
    notifyListeners();
    return reward;
  }

  /// [duration] = null nghĩa là tạm dừng tới hết giờ làm hôm nay.
  Future<void> pause(Duration? duration) async {
    final n = now;
    _pausedUntil = duration != null
        ? n.add(duration)
        : dateOnly(n).add(Duration(minutes: _settings.workEnd));
    await _storage.savePausedUntil(_pausedUntil);
    await reschedule();
    notifyListeners();
  }

  Future<void> resume() async {
    _pausedUntil = null;
    await _storage.savePausedUntil(null);
    await reschedule();
    notifyListeners();
  }

  /// Các mốc nhắc theo kế hoạch hiện tại (dùng cho lịch thông báo và màn debug).
  List<DateTime> plannedReminders() => ReminderPlanner.plan(
        settings: _settings,
        now: now,
        lastBreak: lastBreak,
        doneToday: todayCount,
        pausedUntil: pausedUntil,
      );

  Future<void> reschedule() async {
    if (!_settings.onboarded) {
      _nextReminder = null;
      return;
    }
    final times = plannedReminders();
    _nextReminder = times.isEmpty ? null : times.first;
    try {
      await notifications.scheduleAll(times);
    } catch (e) {
      debugPrint('Không lên lịch được thông báo: $e');
    }
  }

  /// Gọi mỗi phút / khi app quay lại foreground để cập nhật trạng thái Upa.
  void tick() => notifyListeners();

  Future<void> refresh() async {
    await reschedule();
    notifyListeners();
  }
}

/// Đưa AppState xuống cây widget, widget nào dùng `AppScope.of` sẽ tự rebuild.
class AppScope extends InheritedNotifier<AppState> {
  const AppScope({super.key, required AppState state, required super.child})
      : super(notifier: state);

  static AppState of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppScope>()!.notifier!;

  static AppState read(BuildContext context) =>
      context.getInheritedWidgetOfExactType<AppScope>()!.notifier!;
}
