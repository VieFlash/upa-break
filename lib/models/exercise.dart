import 'settings.dart';

/// Một bài giãn cơ. Tên và các bước nằm trong file dịch (lib/l10n), tra theo [id]:
/// `l10n.exerciseName(id)`, `l10n.exerciseSteps(id)`.
class Exercise {
  final String id;
  final BodyArea area;
  final int seconds;

  const Exercise({required this.id, required this.area, required this.seconds});
}
