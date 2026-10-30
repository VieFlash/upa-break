import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upa_break/data/storage.dart';
import 'package:upa_break/logic/break_cues.dart';
import 'package:upa_break/services/notification_service.dart';
import 'package:upa_break/services/sound_service.dart';
import 'package:upa_break/state/app_state.dart';
import 'package:upa_break/ui/widgets/celebration.dart';

class _QuietNotifications extends NotificationService {
  _QuietNotifications() : super(onTapBreak: () {});

  @override
  Future<void> scheduleAll(List<DateTime> times) async {}

  @override
  Future<void> setLanguage(String language) async {}
}

class _SilentSounds extends SoundService {
  @override
  Future<void> play(Cue cue) async {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('đạt mục tiêu thì ăn mừng đúng 1 lần/ngày, sang ngày mới thì lại có', () async {
    SharedPreferences.setMockInitialValues({});
    final storage = await Storage.open();
    var now = DateTime(2026, 11, 2, 10);
    final state = AppState(storage, _QuietNotifications(), sounds: _SilentSounds())..clock = () => now;
    final goal = state.dailyGoal;

    final results = <bool>[];
    for (var i = 0; i < goal + 2; i++) {
      now = now.add(const Duration(minutes: 20));
      results.add((await state.logBreak(['neck_tilt'], 30)).celebrate);
    }
    expect(results.where((c) => c).length, 1);
    expect(results.indexOf(true), goal - 1); // đúng lần chạm mục tiêu

    // mở lại app cùng ngày (đọc lại từ storage) rồi tập tiếp: không ăn mừng lần nữa
    final reopened = AppState(storage, _QuietNotifications(), sounds: _SilentSounds())..clock = () => now;
    expect((await reopened.logBreak(['neck_tilt'], 30)).celebrate, isFalse);

    // ngày hôm sau
    now = DateTime(2026, 11, 3, 9);
    final next = <bool>[];
    for (var i = 0; i < goal; i++) {
      now = now.add(const Duration(minutes: 20));
      next.add((await reopened.logBreak(['neck_tilt'], 30)).celebrate);
    }
    expect(next.last, isTrue);
  });

  testWidgets('pháo giấy chạy hết mà không lỗi', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: Scaffold(body: Celebration())));
    for (var i = 0; i < 30; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    expect(tester.takeException(), isNull);
  });
}
