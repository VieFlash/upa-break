import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upa_break/data/storage.dart';
import 'package:upa_break/logic/break_cues.dart';
import 'package:upa_break/models/settings.dart';
import 'package:upa_break/services/notification_service.dart';
import 'package:upa_break/services/sound_service.dart';
import 'package:upa_break/state/app_state.dart';

/// Ghi lại âm đã phát thay vì phát thật.
class _FakeSounds extends SoundService {
  final played = <Cue>[];

  @override
  Future<void> play(Cue cue) async => played.add(cue);
}

class _QuietNotifications extends NotificationService {
  _QuietNotifications() : super(onTapBreak: () {});

  @override
  Future<void> scheduleAll(List<DateTime> times) async {}

  @override
  Future<void> setLanguage(String language) async {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<(AppState, _FakeSounds)> make() async {
    SharedPreferences.setMockInitialValues({});
    final sounds = _FakeSounds();
    return (AppState(await Storage.open(), _QuietNotifications(), sounds: sounds), sounds);
  }

  test('mặc định: âm thanh và rung đều bật, lưu/đọc lại được', () {
    const s = UserSettings();
    expect(s.soundOn, isTrue);
    expect(s.vibrateOn, isTrue);
    final off = UserSettings.fromJson(s.copyWith(soundOn: false, vibrateOn: false).toJson());
    expect(off.soundOn, isFalse);
    expect(off.vibrateOn, isFalse);
    expect(UserSettings.fromJson(const {}).soundOn, isTrue); // dữ liệu cũ chưa có key
  });

  test('bật âm thanh: tín hiệu được phát, Cue.none thì không', () async {
    final (state, sounds) = await make();
    state.cue(Cue.tick);
    state.cue(Cue.none);
    state.cue(Cue.done);
    expect(sounds.played, [Cue.tick, Cue.done]);
  });

  test('tắt âm thanh trong Cài đặt thì không phát gì', () async {
    final (state, sounds) = await make();
    await state.updateSettings(state.settings.copyWith(soundOn: false));
    state.cue(Cue.tick);
    state.cue(Cue.done);
    expect(sounds.played, isEmpty);
  });
}
