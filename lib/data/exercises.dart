import '../models/exercise.dart';
import '../models/settings.dart';

/// Thư viện bài giãn cơ ngắn, làm được ngay tại bàn. Tên + các bước: lib/l10n/app_*.arb (`ex<Id>Name/Steps`).
/// Nên nhờ chuyên gia vật lý trị liệu duyệt lại nội dung trước khi phát hành.
const List<Exercise> kExercises = [
  // Cổ
  Exercise(id: 'neck_tilt', area: BodyArea.neck, seconds: 40),
  Exercise(id: 'chin_tuck', area: BodyArea.neck, seconds: 30),
  Exercise(id: 'neck_turn', area: BodyArea.neck, seconds: 30),
  // Vai
  Exercise(id: 'shoulder_roll', area: BodyArea.shoulders, seconds: 30),
  Exercise(id: 'shoulder_shrug', area: BodyArea.shoulders, seconds: 30),
  Exercise(id: 'chest_open', area: BodyArea.shoulders, seconds: 40),
  // Lưng
  Exercise(id: 'overhead_reach', area: BodyArea.back, seconds: 40),
  Exercise(id: 'side_bend', area: BodyArea.back, seconds: 40),
  Exercise(id: 'seated_twist', area: BodyArea.back, seconds: 40),
  Exercise(id: 'cat_cow', area: BodyArea.back, seconds: 40),
  // Cổ tay
  Exercise(id: 'wrist_flex', area: BodyArea.wrists, seconds: 30),
  Exercise(id: 'wrist_ext', area: BodyArea.wrists, seconds: 30),
  Exercise(id: 'fist_spread', area: BodyArea.wrists, seconds: 30),
  // Mắt
  Exercise(id: 'eye_2020', area: BodyArea.eyes, seconds: 25),
  Exercise(id: 'eye_palming', area: BodyArea.eyes, seconds: 30),
  // Chân
  Exercise(id: 'calf_raise', area: BodyArea.legs, seconds: 40),
  Exercise(id: 'ankle_circle', area: BodyArea.legs, seconds: 30),
  Exercise(id: 'figure_four', area: BodyArea.legs, seconds: 40),
];

Exercise exerciseById(String id) => kExercises.firstWhere((e) => e.id == id);

/// Chọn 2 bài từ 2 vùng khác nhau (ưu tiên vùng hay mỏi), đổi dần theo ngày và số lần đã tập.
List<Exercise> buildQuickSession({
  required Set<BodyArea> focus,
  required DateTime now,
  required int doneToday,
}) {
  final areas = (focus.isEmpty ? BodyArea.values.toSet() : focus).toList()
    ..sort((a, b) => a.index.compareTo(b.index));
  final dayOfYear = now.difference(DateTime(now.year)).inDays;
  final seed = dayOfYear * 7 + doneToday * 3;

  final firstArea = areas[seed % areas.length];
  final secondArea = areas.length > 1
      ? areas[(seed + 1) % areas.length]
      : BodyArea.values[(firstArea.index + 2) % BodyArea.values.length];

  Exercise pick(BodyArea area, int s) {
    final pool = kExercises.where((e) => e.area == area).toList();
    return pool[s % pool.length];
  }

  return [pick(firstArea, seed), pick(secondArea, seed ~/ 2 + 1)];
}
