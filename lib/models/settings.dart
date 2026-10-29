/// Cài đặt người dùng: giờ làm, giờ nghỉ trưa, ngày làm việc, kiểu nhắc, vùng hay mỏi.
library;

enum ReminderMode { gentle, smart, focus }

extension ReminderModeX on ReminderMode {
  /// Khoảng cách cơ bản giữa hai lần nhắc (phút).
  int get intervalMinutes => switch (this) {
        ReminderMode.gentle => 90,
        ReminderMode.smart => 60,
        ReminderMode.focus => 45,
      };

  String get label => switch (this) {
        ReminderMode.gentle => 'Nhẹ nhàng',
        ReminderMode.smart => 'Thông minh',
        ReminderMode.focus => 'Chăm chỉ',
      };

  String get description => switch (this) {
        ReminderMode.gentle => 'Nhắc mỗi 90 phút, ít làm phiền.',
        ReminderMode.smart =>
          'Khoảng 60 phút. Đang làm tốt thì nhắc thưa hơn, bị chậm thì nhắc sớm hơn.',
        ReminderMode.focus => 'Nhắc đều mỗi 45 phút cho tới khi đạt mục tiêu.',
      };
}

enum BodyArea { neck, shoulders, back, wrists, eyes, legs }

extension BodyAreaX on BodyArea {
  String get label => switch (this) {
        BodyArea.neck => 'Cổ',
        BodyArea.shoulders => 'Vai',
        BodyArea.back => 'Lưng',
        BodyArea.wrists => 'Cổ tay',
        BodyArea.eyes => 'Mắt',
        BodyArea.legs => 'Chân',
      };

  String get emoji => switch (this) {
        BodyArea.neck => '🦒',
        BodyArea.shoulders => '💪',
        BodyArea.back => '🪑',
        BodyArea.wrists => '⌨️',
        BodyArea.eyes => '👀',
        BodyArea.legs => '🦵',
      };
}

/// Thời gian trong ngày lưu dạng "số phút tính từ 0h".
String formatMinutes(int m) =>
    '${(m ~/ 60).toString().padLeft(2, '0')}:${(m % 60).toString().padLeft(2, '0')}';

class UserSettings {
  final int workStart;
  final int workEnd;
  final bool lunchEnabled;
  final int lunchStart;
  final int lunchEnd;

  /// Theo DateTime.weekday: 1 = Thứ 2 ... 7 = Chủ nhật.
  final Set<int> workDays;
  final ReminderMode mode;
  final Set<BodyArea> focusAreas;
  final bool onboarded;

  const UserSettings({
    this.workStart = 8 * 60 + 30,
    this.workEnd = 17 * 60 + 30,
    this.lunchEnabled = true,
    this.lunchStart = 12 * 60,
    this.lunchEnd = 13 * 60,
    this.workDays = const {1, 2, 3, 4, 5},
    this.mode = ReminderMode.smart,
    this.focusAreas = const {BodyArea.neck, BodyArea.shoulders, BodyArea.back},
    this.onboarded = false,
  });

  int get workMinutes {
    var total = workEnd - workStart;
    if (lunchEnabled) {
      final overlap = _overlap(workStart, workEnd, lunchStart, lunchEnd);
      total -= overlap;
    }
    return total < 0 ? 0 : total;
  }

  /// Số lần giãn cơ mục tiêu mỗi ngày.
  int get dailyGoal => (workMinutes / mode.intervalMinutes).floor().clamp(3, 10);

  bool isWorkDay(DateTime d) => workDays.contains(d.weekday);

  bool isLunchAt(DateTime t) {
    if (!lunchEnabled) return false;
    final m = t.hour * 60 + t.minute;
    return m >= lunchStart && m < lunchEnd;
  }

  bool isWorkingAt(DateTime t) {
    if (!isWorkDay(t)) return false;
    final m = t.hour * 60 + t.minute;
    if (m < workStart || m >= workEnd) return false;
    return !isLunchAt(t);
  }

  UserSettings copyWith({
    int? workStart,
    int? workEnd,
    bool? lunchEnabled,
    int? lunchStart,
    int? lunchEnd,
    Set<int>? workDays,
    ReminderMode? mode,
    Set<BodyArea>? focusAreas,
    bool? onboarded,
  }) =>
      UserSettings(
        workStart: workStart ?? this.workStart,
        workEnd: workEnd ?? this.workEnd,
        lunchEnabled: lunchEnabled ?? this.lunchEnabled,
        lunchStart: lunchStart ?? this.lunchStart,
        lunchEnd: lunchEnd ?? this.lunchEnd,
        workDays: workDays ?? this.workDays,
        mode: mode ?? this.mode,
        focusAreas: focusAreas ?? this.focusAreas,
        onboarded: onboarded ?? this.onboarded,
      );

  Map<String, dynamic> toJson() => {
        'workStart': workStart,
        'workEnd': workEnd,
        'lunchEnabled': lunchEnabled,
        'lunchStart': lunchStart,
        'lunchEnd': lunchEnd,
        'workDays': workDays.toList()..sort(),
        'mode': mode.name,
        'focusAreas': focusAreas.map((a) => a.name).toList(),
        'onboarded': onboarded,
      };

  factory UserSettings.fromJson(Map<String, dynamic> j) {
    const d = UserSettings();
    return UserSettings(
      workStart: j['workStart'] as int? ?? d.workStart,
      workEnd: j['workEnd'] as int? ?? d.workEnd,
      lunchEnabled: j['lunchEnabled'] as bool? ?? d.lunchEnabled,
      lunchStart: j['lunchStart'] as int? ?? d.lunchStart,
      lunchEnd: j['lunchEnd'] as int? ?? d.lunchEnd,
      workDays: (j['workDays'] as List?)?.map((e) => e as int).toSet() ?? d.workDays,
      mode: ReminderMode.values.firstWhere(
        (m) => m.name == j['mode'],
        orElse: () => d.mode,
      ),
      focusAreas: (j['focusAreas'] as List?)
              ?.map((e) => BodyArea.values.where((a) => a.name == e))
              .expand((x) => x)
              .toSet() ??
          d.focusAreas,
      onboarded: j['onboarded'] as bool? ?? false,
    );
  }
}

int _overlap(int a1, int a2, int b1, int b2) {
  final s = a1 > b1 ? a1 : b1;
  final e = a2 < b2 ? a2 : b2;
  return e > s ? e - s : 0;
}
