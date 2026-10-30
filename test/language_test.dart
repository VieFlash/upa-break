import 'package:flutter_test/flutter_test.dart';
import 'package:upa_break/logic/language.dart';
import 'package:upa_break/models/settings.dart';

void main() {
  test('chưa chọn thì theo ngôn ngữ máy', () {
    expect(resolveLanguage(null, 'vi'), 'vi');
    expect(resolveLanguage(null, 'en'), 'en');
  });

  test('máy dùng ngôn ngữ chưa hỗ trợ thì về tiếng Anh', () {
    expect(resolveLanguage(null, 'ja'), 'en');
    expect(resolveLanguage(null, 'fr'), 'en');
  });

  test('người dùng chọn thì ưu tiên hơn ngôn ngữ máy', () {
    expect(resolveLanguage('vi', 'en'), 'vi');
    expect(resolveLanguage('en', 'vi'), 'en');
  });

  test('giá trị chọn không hợp lệ thì bỏ qua', () {
    expect(resolveLanguage('xx', 'vi'), 'vi');
  });

  test('không phân biệt hoa thường mã ngôn ngữ máy', () {
    expect(resolveLanguage(null, 'VI'), 'vi');
  });

  test('ngôn ngữ đã chọn được lưu lại và đặt về "theo máy" được', () {
    const s = UserSettings(language: 'en');
    expect(UserSettings.fromJson(s.toJson()).language, 'en');
    expect(s.copyWith(mode: ReminderMode.focus).language, 'en'); // đổi field khác thì giữ nguyên
    final system = s.copyWith(language: null);
    expect(system.language, isNull);
    expect(UserSettings.fromJson(system.toJson()).language, isNull);
  });
}
