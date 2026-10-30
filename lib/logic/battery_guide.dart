/// Hướng dẫn tắt tối ưu pin theo hãng máy Android (hàm thuần, dễ test).
///
/// Nhiều hãng (ROM tùy biến) chặn app chạy nền và hủy lời nhắc đã hẹn nếu không được cho phép.
enum OemBrand { xiaomi, oppo, vivo, samsung, other }

/// Nhận diện hãng từ `Build.MANUFACTURER` / `Build.BRAND` (không phân biệt hoa thường).
OemBrand oemBrandOf(String manufacturer, [String brand = '']) {
  final s = '${manufacturer.toLowerCase()} ${brand.toLowerCase()}';
  bool has(List<String> names) => names.any(s.contains);
  if (has(['xiaomi', 'redmi', 'poco'])) return OemBrand.xiaomi;
  if (has(['oppo', 'realme', 'oneplus'])) return OemBrand.oppo; // cùng nền ColorOS
  if (has(['vivo', 'iqoo'])) return OemBrand.vivo;
  if (has(['samsung'])) return OemBrand.samsung;
  return OemBrand.other;
}

/// Tên hiển thị của nhóm hãng.
String oemBrandName(OemBrand b) => switch (b) {
      OemBrand.xiaomi => 'Xiaomi / Redmi / POCO',
      OemBrand.oppo => 'Oppo / Realme / OnePlus',
      OemBrand.vivo => 'Vivo / iQOO',
      OemBrand.samsung => 'Samsung',
      OemBrand.other => 'Android',
    };

// Các bước hướng dẫn theo hãng (đã dịch): `l10n.batteryGuide(brand)` trong lib/l10n/l10n.dart.
