import '../models/exercise.dart';
import '../models/settings.dart';

/// Thư viện bài giãn cơ ngắn, làm được ngay tại bàn.
/// Nên nhờ chuyên gia vật lý trị liệu duyệt lại nội dung trước khi phát hành.
const List<Exercise> kExercises = [
  // Cổ
  Exercise(id: 'neck_tilt', name: 'Nghiêng cổ', area: BodyArea.neck, seconds: 40, steps: [
    'Ngồi thẳng, thả lỏng hai vai.',
    'Nghiêng tai phải về phía vai phải, giữ 10 giây.',
    'Về giữa, nghiêng sang trái, giữ 10 giây.',
    'Thở đều, làm chậm, không gây đau.',
  ]),
  Exercise(id: 'chin_tuck', name: 'Thu cằm', area: BodyArea.neck, seconds: 30, steps: [
    'Ngồi thẳng, mắt nhìn về phía trước.',
    'Kéo cằm lùi ra sau như đang tạo cằm đôi.',
    'Giữ 5 giây rồi thả lỏng.',
    'Lặp lại khoảng 5 lần.',
  ]),
  Exercise(id: 'neck_turn', name: 'Quay cổ trái phải', area: BodyArea.neck, seconds: 30, steps: [
    'Từ từ quay đầu sang phải, giữ 5 giây.',
    'Quay về giữa.',
    'Quay sang trái, giữ 5 giây.',
    'Chỉ quay trái phải, không xoay tròn cả vòng.',
  ]),
  // Vai
  Exercise(id: 'shoulder_roll', name: 'Xoay vai', area: BodyArea.shoulders, seconds: 30, steps: [
    'Nhún hai vai lên gần tai.',
    'Đưa vai ra sau rồi hạ xuống.',
    'Xoay 5 vòng ra sau.',
    'Đổi chiều, xoay 5 vòng ra trước.',
  ]),
  Exercise(id: 'shoulder_shrug', name: 'Nhún vai thả lỏng', area: BodyArea.shoulders, seconds: 30, steps: [
    'Hít vào, nhún hai vai lên cao.',
    'Giữ 3 giây.',
    'Thở ra, thả vai rơi xuống thật thả lỏng.',
    'Lặp lại khoảng 6 lần.',
  ]),
  Exercise(id: 'chest_open', name: 'Mở ngực', area: BodyArea.shoulders, seconds: 40, steps: [
    'Đan hai bàn tay ra sau lưng.',
    'Kéo hai bả vai lại gần nhau.',
    'Ưỡn nhẹ ngực, mắt nhìn hơi lên.',
    'Giữ và thở đều.',
  ]),
  // Lưng
  Exercise(id: 'overhead_reach', name: 'Vươn người lên cao', area: BodyArea.back, seconds: 40, steps: [
    'Đan hai tay, lật lòng bàn tay lên trên.',
    'Vươn thẳng tay qua đầu.',
    'Kéo dài cột sống, giữ 10 giây.',
    'Thả lỏng rồi lặp lại.',
  ]),
  Exercise(id: 'side_bend', name: 'Nghiêng người', area: BodyArea.back, seconds: 40, steps: [
    'Giơ tay phải lên cao.',
    'Nghiêng người sang trái, giữ 10 giây.',
    'Đổi tay, nghiêng sang phải, giữ 10 giây.',
    'Giữ mông luôn chạm ghế.',
  ]),
  Exercise(id: 'seated_twist', name: 'Vặn mình trên ghế', area: BodyArea.back, seconds: 40, steps: [
    'Ngồi thẳng, hai bàn chân đặt trên sàn.',
    'Xoay thân sang phải, tay trái đặt lên gối phải.',
    'Giữ 10 giây, thở đều.',
    'Đổi bên.',
  ]),
  Exercise(id: 'cat_cow', name: 'Cong lưng kiểu mèo', area: BodyArea.back, seconds: 40, steps: [
    'Ngồi mép ghế, hai tay đặt lên đùi.',
    'Hít vào: ưỡn ngực, nhìn lên.',
    'Thở ra: cong tròn lưng, cúi đầu.',
    'Lặp lại thật chậm, như một chú mèo.',
  ]),
  // Cổ tay
  Exercise(id: 'wrist_flex', name: 'Giãn cổ tay (ngửa)', area: BodyArea.wrists, seconds: 30, steps: [
    'Duỗi tay phải ra trước, lòng bàn tay ngửa.',
    'Tay trái kéo nhẹ các ngón tay xuống.',
    'Giữ 10 giây rồi đổi tay.',
    'Kéo nhẹ nhàng, không kéo mạnh.',
  ]),
  Exercise(id: 'wrist_ext', name: 'Giãn cổ tay (úp)', area: BodyArea.wrists, seconds: 30, steps: [
    'Duỗi tay ra trước, lòng bàn tay úp.',
    'Tay kia ấn nhẹ mu bàn tay xuống.',
    'Giữ 10 giây rồi đổi tay.',
    'Thả lỏng các ngón tay.',
  ]),
  Exercise(id: 'fist_spread', name: 'Nắm – xòe tay', area: BodyArea.wrists, seconds: 30, steps: [
    'Nắm chặt hai bàn tay.',
    'Xòe rộng hết cỡ các ngón.',
    'Lặp lại khoảng 10 lần.',
    'Xoay cổ tay vài vòng mỗi chiều.',
  ]),
  // Mắt
  Exercise(id: 'eye_2020', name: 'Nhìn xa 20 giây', area: BodyArea.eyes, seconds: 25, steps: [
    'Rời mắt khỏi màn hình.',
    'Nhìn một vật ở xa khoảng 6 mét.',
    'Chớp mắt chậm vài lần.',
    'Thả lỏng cơ mặt.',
  ]),
  Exercise(id: 'eye_palming', name: 'Úp tay nghỉ mắt', area: BodyArea.eyes, seconds: 30, steps: [
    'Xoa hai lòng bàn tay cho ấm.',
    'Úp nhẹ lên mắt, không ấn vào mắt.',
    'Hít thở chậm trong bóng tối.',
    'Bỏ tay ra, mở mắt từ từ.',
  ]),
  // Chân
  Exercise(id: 'calf_raise', name: 'Kiễng gót', area: BodyArea.legs, seconds: 40, steps: [
    'Đứng dậy, vịn nhẹ vào bàn.',
    'Kiễng gót lên cao, giữ 2 giây.',
    'Hạ gót xuống từ từ.',
    'Lặp lại khoảng 12 lần.',
  ]),
  Exercise(id: 'ankle_circle', name: 'Xoay cổ chân', area: BodyArea.legs, seconds: 30, steps: [
    'Duỗi chân phải, nhấc nhẹ khỏi sàn.',
    'Xoay cổ chân 5 vòng mỗi chiều.',
    'Đổi sang chân trái.',
    'Ngồi thẳng lưng khi làm.',
  ]),
  Exercise(id: 'figure_four', name: 'Giãn hông số 4', area: BodyArea.legs, seconds: 40, steps: [
    'Gác mắt cá chân phải lên gối trái.',
    'Lưng thẳng, nghiêng nhẹ người về trước.',
    'Giữ khoảng 15 giây.',
    'Đổi chân.',
  ]),
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
