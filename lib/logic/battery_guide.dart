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

/// Các bước để Upa nhắc đúng giờ trên từng hãng (đường dẫn menu có thể khác đôi chút theo phiên bản).
List<String> batteryGuideSteps(OemBrand b) => switch (b) {
      OemBrand.xiaomi => const [
          'Mở Cài đặt ứng dụng của Upa Break.',
          'Tiết kiệm pin → chọn "Không hạn chế".',
          'Bật "Tự khởi động".',
          'Ở màn đa nhiệm, nhấn giữ Upa Break → chọn biểu tượng ổ khóa để không bị dọn.',
        ],
      OemBrand.oppo => const [
          'Mở Cài đặt ứng dụng của Upa Break.',
          'Mức sử dụng pin → bật "Cho phép hoạt động nền" và "Cho phép tự khởi chạy".',
          'Ở màn đa nhiệm, nhấn giữ Upa Break → "Khóa" để không bị dọn.',
        ],
      OemBrand.vivo => const [
          'Cài đặt → Pin → Mức tiêu thụ điện năng nền cao → bật cho Upa Break.',
          'i Manager → Quản lý ứng dụng → Tự khởi động → bật Upa Break.',
          'Ở màn đa nhiệm, kéo Upa Break xuống để khóa.',
        ],
      OemBrand.samsung => const [
          'Mở Cài đặt ứng dụng của Upa Break → Pin → chọn "Không hạn chế".',
          'Cài đặt → Chăm sóc thiết bị → Pin → Giới hạn sử dụng nền: đảm bảo Upa Break '
              'không nằm trong "Ứng dụng ngủ" hoặc "Ứng dụng ngủ sâu".',
        ],
      OemBrand.other => const [
          'Bấm "Tắt tối ưu pin" bên dưới → tìm Upa Break → chọn "Không tối ưu hóa".',
          'Nếu máy có mục "Tự khởi động" hoặc "Chạy nền", hãy bật cho Upa Break.',
        ],
    };
