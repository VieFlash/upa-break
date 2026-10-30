import 'package:flutter_test/flutter_test.dart';
import 'package:upa_break/logic/celebration.dart';

void main() {
  final now = DateTime(2026, 11, 2, 15, 30);

  test('lần giãn cơ vừa chạm mục tiêu thì ăn mừng', () {
    expect(shouldCelebrate(wasGoalReached: false, goalReachedNow: true, now: now, lastCelebrated: null), isTrue);
  });

  test('chưa đạt, hoặc đã đạt từ trước (tập thêm) thì không', () {
    expect(shouldCelebrate(wasGoalReached: false, goalReachedNow: false, now: now, lastCelebrated: null), isFalse);
    expect(shouldCelebrate(wasGoalReached: true, goalReachedNow: true, now: now, lastCelebrated: null), isFalse);
  });

  test('mỗi ngày chỉ một lần', () {
    final earlierToday = DateTime(2026, 11, 2, 10);
    expect(shouldCelebrate(wasGoalReached: false, goalReachedNow: true, now: now, lastCelebrated: earlierToday), isFalse);
  });

  test('sang ngày mới thì được ăn mừng lại', () {
    final yesterday = DateTime(2026, 11, 1, 16);
    expect(shouldCelebrate(wasGoalReached: false, goalReachedNow: true, now: now, lastCelebrated: yesterday), isTrue);
  });
}
