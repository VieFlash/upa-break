class BreakLog {
  final DateTime at;
  final List<String> exerciseIds;
  final int seconds;

  const BreakLog({required this.at, required this.exerciseIds, required this.seconds});

  Map<String, dynamic> toJson() => {
        'at': at.toIso8601String(),
        'ex': exerciseIds,
        's': seconds,
      };

  factory BreakLog.fromJson(Map<String, dynamic> j) => BreakLog(
        at: DateTime.parse(j['at'] as String),
        exerciseIds: (j['ex'] as List).map((e) => e as String).toList(),
        seconds: j['s'] as int? ?? 0,
      );
}

DateTime dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

String dayKey(DateTime d) =>
    '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
