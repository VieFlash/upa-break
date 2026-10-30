import 'package:flutter_test/flutter_test.dart';
import 'package:upa_break/data/exercises.dart';
import 'package:upa_break/l10n/l10n.dart';
import 'package:upa_break/models/settings.dart';

void main() {
  for (final lang in ['vi', 'en']) {
    final l = l10nFor(lang);

    test('[$lang] mọi bài tập đều có tên và các bước (không lọt id thô)', () {
      for (final e in kExercises) {
        expect(l.exerciseName(e.id), isNot(e.id), reason: e.id);
        final steps = l.exerciseSteps(e.id);
        expect(steps.length, greaterThanOrEqualTo(3), reason: e.id);
        expect(steps.every((s) => s.trim().isNotEmpty), isTrue, reason: e.id);
      }
    });

    test('[$lang] đủ nhãn cho vùng, kiểu nhắc, thứ và lời nhắc', () {
      for (final a in BodyArea.values) {
        expect(l.areaLabel(a), isNotEmpty);
      }
      for (final m in ReminderMode.values) {
        expect(l.modeLabel(m), isNotEmpty);
        expect(l.modeDescription(m), isNotEmpty);
      }
      expect({for (var d = 1; d <= 7; d++) l.weekdayShort(d)}.length, 7);
      expect(l.reminderMessages.length, 6);
    });
  }

  test('tiếng Anh có số nhiều đúng', () {
    final en = l10nFor('en');
    expect(en.secondsLeft(1), '1 second');
    expect(en.secondsLeft(30), '30 seconds');
    expect(en.streakSuffix(1), ' · 🔥 1 day');
    expect(en.streakSuffix(4), ' · 🔥 4 days');
  });

  test('hai ngôn ngữ thực sự khác nhau', () {
    expect(l10nFor('vi').tabToday, 'Hôm nay');
    expect(l10nFor('en').tabToday, 'Today');
  });
}
