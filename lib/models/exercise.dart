import 'settings.dart';

/// Một bài giãn cơ. Tên và các bước nằm trong file dịch (lib/l10n), tra theo [id]:
/// `l10n.exerciseName(id)`, `l10n.exerciseSteps(id)`.
class Exercise {
  final String id;
  final BodyArea area;
  final int seconds;

  /// Số khung hình minh họa `assets/exercises/<id>_<n>.svg` (sinh bằng tool/gen_exercises.py); 0 = chưa có.
  final int frames;

  const Exercise({required this.id, required this.area, required this.seconds, this.frames = 0});

  /// Hình hiển thị khi tập, luân phiên theo thứ tự; chưa có hình riêng thì dùng Upa giãn cơ.
  List<String> get frameAssets => frames == 0
      ? const [fallbackFrame]
      : [for (var n = 1; n <= frames; n++) 'assets/exercises/${id}_$n.svg'];

  static const fallbackFrame = 'assets/mascot/mascot_stretch.svg';
}
