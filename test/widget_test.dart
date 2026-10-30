import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:upa_break/data/exercises.dart';
import 'package:upa_break/models/exercise.dart';
import 'package:upa_break/models/settings.dart';

void main() {
  test('phiên nhanh có 2 bài từ 2 vùng khác nhau', () {
    final session = buildQuickSession(
      focus: {BodyArea.neck, BodyArea.back},
      now: DateTime(2026, 11, 2, 10),
      doneToday: 2,
    );
    expect(session.length, 2);
    expect(session[0].area != session[1].area, isTrue);
  });

  test('mỗi vùng đều có bài tập', () {
    for (final a in BodyArea.values) {
      expect(kExercises.any((e) => e.area == a), isTrue, reason: a.name);
    }
  });

  test('mọi bài tập có 2-3 khung minh họa và file SVG tồn tại', () {
    for (final e in kExercises) {
      expect(e.frames, inInclusiveRange(2, 3), reason: e.id);
      for (final a in e.frameAssets) {
        expect(File(a).existsSync(), isTrue, reason: a);
      }
    }
  });

  test('bài chưa có khung riêng thì dùng Upa giãn cơ', () {
    const e = Exercise(id: 'new_one', area: BodyArea.neck, seconds: 30);
    expect(e.frameAssets, [Exercise.fallbackFrame]);
    expect(File(Exercise.fallbackFrame).existsSync(), isTrue);
  });
}
