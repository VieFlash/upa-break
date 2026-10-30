import 'package:flutter_test/flutter_test.dart';
import 'package:upa_break/logic/break_cues.dart';

void main() {
  test('chỉ "tách" ở 3 giây cuối khi đang tập', () {
    final cues = [for (var r = 29; r >= 1; r--) cueAfterTick(remaining: r, exercising: true)];
    expect(cues.where((c) => c == Cue.tick).length, 3);
    expect(cueAfterTick(remaining: 4, exercising: true), Cue.none);
    expect(cueAfterTick(remaining: 3, exercising: true), Cue.tick);
    expect(cueAfterTick(remaining: 1, exercising: true), Cue.tick);
  });

  test('đếm chuẩn bị cũng "tách" nhưng hết giờ chuẩn bị thì không có chuông', () {
    expect(cueAfterTick(remaining: 2, exercising: false), Cue.tick);
    expect(cueAfterTick(remaining: 0, exercising: false), Cue.none);
  });

  test('hết giờ một bài thì có chuông', () {
    expect(cueAfterTick(remaining: 0, exercising: true), Cue.done);
  });
}
