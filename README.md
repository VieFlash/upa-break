# Upa Break

App nhắc giãn cơ cho dân văn phòng. Upa - chú kỳ nhông văn phòng đội nón lá - gù lưng dần khi bạn ngồi lâu, và duỗi người khi bạn giãn cơ.

## Chạy app (lần đầu)

Yêu cầu: Flutter 3.38+ (project ghim bản stable qua FVM, chạy lệnh bằng `fvm flutter` / `fvm dart`), Android Studio / Android SDK, Xcode.
iOS 27 bắt buộc UIScene lifecycle nên Flutter cũ hơn 3.38 sẽ crash khi mở app.
Android SDK cần có *Command-line Tools* và đã chấp nhận license (`fvm flutter doctor --android-licenses`),
nếu không Gradle không tự tải được NDK (lỗi `NDK ... did not have a source.properties file`; cũng xảy ra khi ổ đĩa đầy).

```bash
cd upa_break

# 1. Sinh thư mục android/ và ios/ (không ghi đè lib/, pubspec.yaml, test/)
fvm flutter create --org app.upabreak --project-name upa_break --platforms android,ios .

# 2. Cấu hình native: Android (quyền thông báo, receiver, desugaring),
#    iOS (UIScene lifecycle, delegate thông báo, iOS 15+), tên app hiển thị
fvm dart run tool/setup_android.dart
fvm dart run tool/setup_ios.dart

# 3. Sinh icon app Android + iOS từ assets/upa_assets (cần Pillow)
python3 tool/gen_icons.py

# 4. Cài thư viện, chạy test, chạy app
fvm flutter pub get
fvm flutter test
fvm flutter run
```

## Thử nhanh lịch nhắc

- Cài đặt → **Gửi thông báo thử**: kiểm tra quyền thông báo.
- Muốn thấy lời nhắc thật nhanh: chọn kiểu **Chăm chỉ** và đặt giờ vào làm sớm hơn giờ hiện tại khoảng 50 phút.
- Máy Xiaomi/Oppo/Vivo: bật "Pin: Không giới hạn" và "Tự khởi động" cho app, nếu không lời nhắc có thể bị chặn.

## Cấu trúc

```
lib/
  main.dart                     Khởi tạo storage, notification, state
  app.dart                      MaterialApp, điều hướng, tab bar, vòng đời app
  models/                       UserSettings, BreakLog, Exercise
  data/exercises.dart           18 bài giãn cơ + chọn phiên nhanh 2 bài
  data/storage.dart             Lưu local bằng shared_preferences
  logic/reminder_planner.dart   Tính các mốc nhắc (hàm thuần, có test)
  logic/streak.dart             Streak + khiên streak (hàm thuần, có test)
  services/notification_service.dart  Lên lịch local notification
  state/app_state.dart          ChangeNotifier: trạng thái Upa, số liệu, hành động
  ui/screens/                   Onboarding, Hôm nay, Bài tập, Nhật ký, Cài đặt, Phiên tập
  ui/widgets/                   Mascot + UpaRig (chuyển động theo trạng thái), form giờ làm
assets/mascot/                  SVG Upa: mascot_{fresh,slouch,sleepy,stretch,proud}, app_icon
assets/mascot/rig/              Các lớp SVG cho chuyển động (sinh từ tool/gen_mascot.py)
assets/upa_assets/              Bản gốc SVG/PNG + icon 1024 (nguồn cho tool/gen_icons.py)
tool/                           setup_android/ios, gen_icons, gen_mascot, render_mascot
```

## Cách hoạt động

- **Trạng thái Upa** theo số phút ngồi liên tục trong giờ làm (trừ giờ trưa):
  < 75% khoảng nhắc → tươi tỉnh, < 150% → gù lưng, còn lại → ngủ gục. Đạt mục tiêu → tự hào.
- **Lịch nhắc kiểu rolling**: mỗi lần mở app, giãn cơ xong, đổi cài đặt hoặc bấm "Đang họp",
  app hủy và đặt lại tối đa 40 thông báo cho 7 ngày tới (iOS giới hạn 64).
- **Thông minh**: đang vượt tiến độ thì nhắc thưa hơn 30 phút, bị chậm thì nhắc sớm hơn 20 phút.
- **Khiên streak**: mỗi tháng tha 1 ngày lỡ nếu 3 ngày làm việc trước đó đều đạt. Cuối tuần không tính.
- Dùng `inexactAllowWhileIdle` nên không cần quyền báo thức chính xác (lệch vài phút).

## Việc tiếp theo

- [ ] Ảnh minh họa riêng cho từng bài tập (hiện dùng chung Upa giãn cơ)
- [ ] Nút "Nhắc sau 15 phút" ngay trên thông báo
- [ ] Góc làm việc của Upa lên cấp, huy chương
- [ ] Premium (RevenueCat), widget màn hình chính
