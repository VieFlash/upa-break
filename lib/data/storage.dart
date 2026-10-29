import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/break_log.dart';
import '../models/settings.dart';

/// Lưu mọi thứ trên máy (không cần tài khoản).
class Storage {
  static const _kSettings = 'settings_v1';
  static const _kLogs = 'logs_v1';
  static const _kPausedUntil = 'paused_until_v1';
  static const _kFish = 'fish_v1';

  /// Giữ lại tối đa 120 ngày lịch sử trên máy.
  static const keepDays = 120;

  final SharedPreferences _prefs;
  Storage._(this._prefs);

  static Future<Storage> open() async => Storage._(await SharedPreferences.getInstance());

  UserSettings loadSettings() {
    final raw = _prefs.getString(_kSettings);
    if (raw == null) return const UserSettings();
    try {
      return UserSettings.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return const UserSettings();
    }
  }

  Future<void> saveSettings(UserSettings s) =>
      _prefs.setString(_kSettings, jsonEncode(s.toJson()));

  List<BreakLog> loadLogs() {
    final raw = _prefs.getString(_kLogs);
    if (raw == null) return [];
    try {
      return (jsonDecode(raw) as List)
          .map((e) => BreakLog.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveLogs(List<BreakLog> logs) {
    final cutoff = DateTime.now().subtract(const Duration(days: keepDays));
    final kept = logs.where((l) => l.at.isAfter(cutoff)).map((l) => l.toJson()).toList();
    return _prefs.setString(_kLogs, jsonEncode(kept));
  }

  DateTime? loadPausedUntil() {
    final raw = _prefs.getString(_kPausedUntil);
    return raw == null ? null : DateTime.tryParse(raw);
  }

  Future<void> savePausedUntil(DateTime? t) => t == null
      ? _prefs.remove(_kPausedUntil)
      : _prefs.setString(_kPausedUntil, t.toIso8601String());

  int loadFish() => _prefs.getInt(_kFish) ?? 0;

  Future<void> saveFish(int v) => _prefs.setInt(_kFish, v);
}
