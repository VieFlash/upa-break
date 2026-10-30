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

# 3. Icon app + splash (PNG nguồn đã có sẵn trong assets/icon/, cấu hình trong pubspec.yaml)
fvm dart run flutter_launcher_icons
fvm dart run flutter_native_splash:create

# 4. Cài thư viện, chạy test, chạy app
fvm flutter pub get
fvm flutter test
fvm flutter run
```

## Thử nhanh lịch nhắc

- Cài đặt → **Gửi thông báo thử**: kiểm tra quyền thông báo.
- Màn debug ẩn: **nhấn giữ tiêu đề "Cài đặt" 3 giây** → xem quyền thông báo, các mốc nhắc theo kế hoạch,
  thông báo đang chờ trong hệ thống, và nút **Nhắc thử sau 1 phút** (tắt app để thử lịch hẹn thật).
- Muốn thấy lời nhắc thật nhanh: chọn kiểu **Chăm chỉ** và đặt giờ vào làm sớm hơn giờ hiện tại khoảng 50 phút.
- Máy Xiaomi/Oppo/Vivo/Samsung: Cài đặt → **Nhắc đúng giờ** hiện hướng dẫn theo đúng hãng máy + nút mở màn tối ưu pin
  và cài đặt ứng dụng (bật "Không hạn chế" pin, "Tự khởi động"), nếu không lời nhắc có thể bị chặn.
- Từ chối quyền thông báo vẫn dùng app bình thường; màn Hôm nay có banner **Bật thông báo**
  (xin lại quyền, hoặc mở Cài đặt hệ thống nếu máy không hỏi nữa).

## Cấu trúc

```
lib/
  main.dart                     Khởi tạo storage, notification, state
  app.dart                      MaterialApp, điều hướng, tab bar, vòng đời app
  models/                       UserSettings, BreakLog, Exercise
  data/exercises.dart           18 bài giãn cơ (id, vùng, thời lượng) + chọn phiên nhanh 2 bài
  l10n/                         Chuỗi hiển thị: app_vi.arb (gốc), app_en.arb; l10n.dart = tra tên bài/vùng/kiểu nhắc
  data/storage.dart             Lưu local bằng shared_preferences
  logic/reminder_planner.dart   Tính các mốc nhắc (hàm thuần, có test)
  logic/streak.dart             Streak + khiên streak (hàm thuần, có test)
  logic/battery_guide.dart      Nhận diện hãng máy để hiện hướng dẫn tắt tối ưu pin (hàm thuần, có test)
  logic/language.dart           Chọn ngôn ngữ: người dùng chọn > ngôn ngữ máy > tiếng Anh (có test)
  logic/break_cues.dart         Lúc nào kêu "tách" / chuông trong phiên tập (hàm thuần, có test)
  services/notification_service.dart  Lên lịch local notification
  services/system_settings.dart       Mở cài đặt thông báo / tối ưu pin / ứng dụng (Android + iOS)
  services/sound_service.dart         Phát tick/chuông (audioplayers, âm lượng nhỏ, tôn trọng chế độ im lặng)
  state/app_state.dart          ChangeNotifier: trạng thái Upa, số liệu, hành động
  ui/screens/                   Onboarding, Hôm nay, Bài tập, Nhật ký, Cài đặt, Phiên tập
  ui/widgets/                   Mascot + UpaRig (chuyển động theo trạng thái), form giờ làm
assets/mascot/                  SVG Upa: mascot_{fresh,slouch,sleepy,stretch,proud,bell}, app_icon
assets/mascot/rig/              Các lớp SVG cho chuyển động (sinh từ tool/gen_mascot.py)
assets/exercises/               Hình minh họa bài tập <id>_<n>.svg, 2-3 khung/bài (sinh từ tool/gen_exercises.py)
assets/sounds/                  tick.wav, chime.wav (sinh từ tool/gen_sounds.py)
assets/icon/                    Nguồn icon app + splash (SVG từ gen_mascot.py → PNG 1024 bằng render_mascot.py --icons)
assets/upa_assets/              Bản gốc SVG/PNG đời đầu (không còn dùng trong build)
tool/                           setup_android/ios, gen_mascot, gen_exercises, gen_sounds, render_mascot
```

## Cách hoạt động

- **Trạng thái Upa** theo số phút ngồi liên tục trong giờ làm (trừ giờ trưa):
  < 75% khoảng nhắc → tươi tỉnh, < 150% → gù lưng, còn lại → ngủ gục. Đạt mục tiêu → tự hào.
- **Lịch nhắc kiểu rolling**: mỗi lần mở app, giãn cơ xong, đổi cài đặt hoặc bấm "Đang họp",
  app hủy và đặt lại tối đa 40 thông báo cho 7 ngày tới (iOS giới hạn 64).
- **Thông minh**: đang vượt tiến độ thì nhắc thưa hơn 30 phút, bị chậm thì nhắc sớm hơn 20 phút.
- **Khiên streak**: mỗi tháng tha 1 ngày lỡ nếu 3 ngày làm việc trước đó đều đạt. Cuối tuần không tính.
- Dùng `inexactAllowWhileIdle` nên không cần quyền báo thức chính xác (lệch vài phút).
- **Nút trên thông báo**: "Bắt đầu" mở phiên giãn cơ; "Để sau 15'" xử lý ở background isolate
  (`onBackgroundNotificationResponse`), hẹn lại 1 lời nhắc sau 15 phút mà không mở app.
  Android cần `ActionBroadcastReceiver` trong manifest (đã có trong `tool/setup_android.dart`).

## Việc tiếp theo

- [ ] Góc làm việc của Upa lên cấp, huy chương
- [ ] Premium (RevenueCat), widget màn hình chính

## Đổi icon / splash

```bash
python3 tool/gen_mascot.py                      # sinh lại SVG (gồm assets/icon/*.svg)
python3 tool/render_mascot.py --icons           # SVG -> PNG 1024 + icon_monochrome (cần cairosvg)
fvm dart run flutter_launcher_icons
fvm dart run flutter_native_splash:create
git checkout ios/Runner/Info.plist ios/Runner.xcodeproj/project.pbxproj   # 2 tool trên format lại / sửa nhầm 1 cờ build
```

Icon iOS dùng `icon_full.png` (không alpha). Android adaptive icon: nền gradient + mặt Upa nằm trong vùng an toàn 66dp
(+ monochrome cho themed icon Android 13+). Splash: nền kem `#FFF8F0`, mặt Upa ở giữa (Android 12+ dùng ảnh riêng
vừa vòng tròn 2/3). Simulator iOS hay giữ ảnh khởi động cũ: khởi động lại simulator nếu splash vẫn trắng.

## Đa ngôn ngữ (vi, en)

- Mọi chuỗi hiển thị nằm trong `lib/l10n/app_vi.arb` (bản gốc) và `app_en.arb`; không hard-code trong `lib/ui`.
  Thêm/sửa chuỗi: sửa cả 2 file ARB rồi `fvm flutter gen-l10n` (cũng tự chạy khi build).
- Tên + các bước bài tập: key `ex<Id>Name` / `ex<Id>Steps` (mỗi bước một dòng); thêm bài mới thì thêm vào
  `exerciseName`/`exerciseSteps` trong `lib/l10n/l10n.dart` (test `l10n_test.dart` sẽ báo nếu quên).
- Ngôn ngữ mặc định theo máy (máy dùng ngôn ngữ khác thì tiếng Anh); đổi trong Cài đặt → Ngôn ngữ.
  Thông báo đã hẹn được đặt lại theo ngôn ngữ mới; nút "Để sau" chạy nền lấy ngôn ngữ từ payload `break:<lang>`.

## Âm thanh & rung

- Tiếng "tách" ở 3 giây cuối (cả lúc chuẩn bị) và chuông khi tập xong một bài (bấm "Bỏ qua" thì không có chuông).
- Âm lượng 35%; iOS dùng category `ambient` (tự im theo công tắc im lặng, không ngắt nhạc đang phát);
  Android phát kênh `USAGE_ASSISTANCE_SONIFICATION` (tự im khi máy để im lặng / rung), không giành audio focus.
- Cài đặt → Âm thanh & rung: tắt âm thanh, tắt rung (mặc định bật). Sinh lại âm: `python3 tool/gen_sounds.py`.
