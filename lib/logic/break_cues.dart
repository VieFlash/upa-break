/// Tín hiệu âm thanh / rung trong phiên giãn cơ (hàm thuần, dễ test).
library;

enum Cue {
  /// Không làm gì.
  none,

  /// "Tách" nhẹ ở các giây cuối (lúc chuẩn bị lẫn lúc tập).
  tick,

  /// Chuông: vừa tập xong một bài (hết giờ, không tính bấm "Bỏ qua").
  done,
}

/// Số giây cuối có tiếng "tách".
const tickSeconds = 3;

/// Tín hiệu cho nhịp đếm vừa xong: [remaining] = số giây còn lại SAU khi trừ 1;
/// [exercising] = đang tập (false = đang đếm chuẩn bị).
Cue cueAfterTick({required int remaining, required bool exercising}) {
  if (remaining > 0 && remaining <= tickSeconds) return Cue.tick;
  if (remaining <= 0 && exercising) return Cue.done;
  return Cue.none;
}
