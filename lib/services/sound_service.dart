import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

import '../logic/break_cues.dart';

/// Phát tiếng "tách" / chuông của phiên giãn cơ (assets/sounds, sinh bằng tool/gen_sounds.py).
///
/// Không gây ồn nơi công sở: âm lượng nhỏ; iOS dùng category `ambient` (tự im khi gạt công tắc im lặng,
/// không chen ngang nhạc đang phát); Android phát theo kênh âm thanh hệ thống (tự im khi máy để im lặng / rung),
/// không giành audio focus.
class SoundService {
  static const volume = .35;

  static final _ctx = AudioContext(
    iOS: AudioContextIOS(category: AVAudioSessionCategory.ambient),
    android: const AudioContextAndroid(
      contentType: AndroidContentType.sonification,
      usageType: AndroidUsageType.assistanceSonification,
      audioFocus: AndroidAudioFocus.none,
    ),
  );

  // Mỗi âm một player (low latency) để tiếng "tách" không cắt ngang tiếng chuông. Tạo khi cần lần đầu.
  final _players = <String, AudioPlayer>{};

  Future<void> play(Cue cue) async {
    final file = switch (cue) {
      Cue.tick => 'sounds/tick.wav',
      Cue.done => 'sounds/chime.wav',
      Cue.none => null,
    };
    if (file == null) return;
    try {
      final p = _players[file] ??= await _create();
      await p.stop();
      await p.play(AssetSource(file), volume: volume, ctx: _ctx);
    } catch (e) {
      debugPrint('Không phát được âm thanh: $e');
    }
  }

  /// Đặt kênh âm thanh TRƯỚC chế độ low latency để Android chỉ tạo một bộ phát đúng kênh hệ thống.
  Future<AudioPlayer> _create() async {
    final p = AudioPlayer();
    await p.setAudioContext(_ctx);
    await p.setPlayerMode(PlayerMode.lowLatency);
    return p;
  }

  Future<void> dispose() async {
    for (final p in _players.values) {
      await p.dispose();
    }
    _players.clear();
  }
}
