/// Chọn ngôn ngữ hiển thị (hàm thuần, dễ test).
library;

/// Các ngôn ngữ app hỗ trợ, theo thứ tự ưu tiên khi máy dùng ngôn ngữ khác.
const supportedLanguages = ['en', 'vi'];

/// Ngôn ngữ app dùng: [chosen] (người dùng chọn trong Cài đặt, null = theo máy), nếu không thì
/// [deviceLanguage]; máy dùng ngôn ngữ app chưa hỗ trợ thì về tiếng Anh.
String resolveLanguage(String? chosen, String deviceLanguage) {
  if (chosen != null && supportedLanguages.contains(chosen)) return chosen;
  final device = deviceLanguage.toLowerCase();
  return supportedLanguages.contains(device) ? device : 'en';
}
