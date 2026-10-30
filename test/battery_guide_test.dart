import 'package:flutter_test/flutter_test.dart';
import 'package:upa_break/l10n/l10n.dart';
import 'package:upa_break/logic/battery_guide.dart';

void main() {
  test('nhận diện hãng theo manufacturer, không phân biệt hoa thường', () {
    expect(oemBrandOf('Xiaomi'), OemBrand.xiaomi);
    expect(oemBrandOf('OPPO'), OemBrand.oppo);
    expect(oemBrandOf('vivo'), OemBrand.vivo);
    expect(oemBrandOf('samsung'), OemBrand.samsung);
    expect(oemBrandOf('Google'), OemBrand.other);
  });

  test('các thương hiệu con được gộp đúng nhóm ROM', () {
    expect(oemBrandOf('Xiaomi', 'Redmi'), OemBrand.xiaomi);
    expect(oemBrandOf('Xiaomi', 'POCO'), OemBrand.xiaomi);
    expect(oemBrandOf('realme', 'realme'), OemBrand.oppo);
    expect(oemBrandOf('OnePlus'), OemBrand.oppo);
    expect(oemBrandOf('vivo', 'iQOO'), OemBrand.vivo);
  });

  test('mọi hãng đều có hướng dẫn (cả tiếng Việt lẫn tiếng Anh) và tên hiển thị', () {
    for (final lang in ['vi', 'en']) {
      final l = l10nFor(lang);
      for (final b in OemBrand.values) {
        expect(l.batteryGuide(b), isNotEmpty, reason: '$lang ${b.name}');
        expect(l.batteryGuide(b).every((s) => s.trim().isNotEmpty), isTrue, reason: '$lang ${b.name}');
      }
    }
    for (final b in OemBrand.values) {
      expect(oemBrandName(b), isNotEmpty, reason: b.name);
    }
  });

  test('hướng dẫn Xiaomi nhắc tới tự khởi động', () {
    expect(l10nFor('vi').batteryGuide(OemBrand.xiaomi).any((s) => s.contains('Tự khởi động')), isTrue);
    expect(l10nFor('en').batteryGuide(OemBrand.xiaomi).any((s) => s.contains('Autostart')), isTrue);
  });
}
