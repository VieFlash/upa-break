/// Ăn mừng khi đạt mục tiêu ngày (hàm thuần, dễ test).
library;

/// Có bắn pháo giấy không: lần giãn cơ vừa xong đưa số lần trong ngày từ "chưa đạt" lên "đạt" mục tiêu,
/// và hôm nay chưa ăn mừng lần nào (đổi cài đặt làm mục tiêu tụt rồi đạt lại cũng không ăn mừng lần hai).
bool shouldCelebrate({
  required bool wasGoalReached,
  required bool goalReachedNow,
  required DateTime now,
  required DateTime? lastCelebrated,
}) {
  if (wasGoalReached || !goalReachedNow) return false;
  if (lastCelebrated == null) return true;
  return !(lastCelebrated.year == now.year && lastCelebrated.month == now.month && lastCelebrated.day == now.day);
}
