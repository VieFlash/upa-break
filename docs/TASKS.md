# Upa Break – Lộ trình đến bản phát hành

> File này dành cho Claude Code. Mỗi task là một đơn vị công việc độc lập, làm theo thứ tự.
> Đánh dấu `[x]` khi xong. Không làm nhiều task trong một lần trừ khi được yêu cầu.

---

## 0. Bối cảnh dự án (đọc trước khi làm bất kỳ task nào)

**Sản phẩm:** App mobile nhắc dân văn phòng đứng dậy giãn cơ 30–90 giây tại bàn. Mascot là Upa - chú kỳ nhông văn phòng đội nón lá,
đổi trạng thái theo thời gian ngồi (tươi tỉnh → gù lưng → ngủ gục → tự hào). Triết lý: **"không bao giờ trách"**
(lỡ một ngày không sao, có khiên streak). Lấy cảm hứng từ app uống nước Glubbo.

**Stack:** Flutter (Dart 3.6+), Material 3, `shared_preferences`, `flutter_local_notifications` ^19, `flutter_svg`.
State: `ChangeNotifier` (`AppState`) + `InheritedNotifier` (`AppScope`). Không dùng thư viện state management khác
trừ khi task yêu cầu.

**Cấu trúc:**
```
lib/main.dart, lib/app.dart
lib/models/            UserSettings, BreakLog, Exercise
lib/data/              exercises.dart (thư viện bài), storage.dart
lib/logic/             reminder_planner.dart, streak.dart  (hàm thuần, có test)
lib/services/          notification_service.dart
lib/state/app_state.dart
lib/ui/screens/, lib/ui/widgets/, lib/ui/theme.dart
assets/mascot/         SVG Upa mascot_*.svg (sinh bằng tool/gen_mascot.py)
test/                  unit test
tool/setup_android.dart
```

**Quy ước bắt buộc:**
- Chuỗi hiển thị: tiếng Việt (sau task 2.1 thì qua file l10n, không hard-code).
- Logic nghiệp vụ đặt trong `lib/logic/` dưới dạng hàm thuần + có unit test. UI không chứa logic tính toán.
- Mọi thời gian trong ngày lưu dạng "số phút từ 0h" (`int`).
- Không thêm quyền Android/iOS nếu task không nói rõ. Không dùng `SCHEDULE_EXACT_ALARM`.
- Không viết nội dung y tế mang tính chẩn đoán/chữa bệnh. Luôn giữ disclaimer.
- Sau mỗi task: `flutter analyze` sạch, `flutter test` pass, cập nhật README nếu thay đổi cách chạy.
- Commit theo dạng: `feat(T1.2): mô tả ngắn` / `fix(...)` / `chore(...)`.

**Định nghĩa "Xong" (DoD) chung cho mọi task:**
1. Đạt toàn bộ tiêu chí trong task.
2. `flutter analyze` không có error/warning mới.
3. `flutter test` pass; logic mới có test.
4. Chạy được trên Android emulator (API 34+) không crash.

---

## Giai đoạn 1 – Chạy ổn định bản MVP

### [x] T1.1 Build và sửa lỗi lần đầu
- Chạy `flutter create` theo README, `dart run tool/setup_android.dart`, `flutter pub get`.
- Sửa mọi lỗi compile/analyze (có thể do lệch phiên bản API của `flutter_local_notifications`, `CardThemeData`, `PopScope`…).
- **Xong khi:** `flutter analyze` sạch, 16 test pass, app chạy trên emulator, đi hết onboarding → Hôm nay → Giãn cơ → Nhật ký.

### [ ] T1.2 Kiểm thử thông báo thực tế
- Thêm màn hình debug ẩn (nhấn giữ tiêu đề "Cài đặt" 3 giây) hiển thị: danh sách mốc nhắc đã lên lịch
  (`ReminderPlanner.plan`), `pendingNotificationRequests()`, trạng thái quyền thông báo.
- Thêm nút "Nhắc thử sau 1 phút" (lên lịch 1 thông báo sau 60 giây).
- **Xong khi:** thông báo hiện khi app bị kill, chạm vào mở đúng màn giãn cơ; sau khi reboot máy lịch vẫn còn.

### [ ] T1.3 Quyền thông báo & tối ưu pin
- Onboarding bước cuối: màn giải thích trước khi xin quyền (Upa cầm chuông), sau đó mới gọi `requestPermission()`.
- Nếu người dùng từ chối: banner trên màn Hôm nay "Upa chưa được phép nhắc bạn" + nút mở cài đặt app.
- Android: nút mở màn tối ưu pin (dùng `android_intent_plus` hoặc tương đương) + hướng dẫn theo hãng
  (Xiaomi, Oppo, Vivo, Samsung) dựa trên `device_info_plus`.
- **Xong khi:** từ chối quyền vẫn dùng app được, có đường dẫn rõ ràng để bật lại.

### [ ] T1.4 Nút "Nhắc sau 15 phút" trên thông báo
- Thêm notification action "Bắt đầu" và "Để sau 15'" (Android + iOS category).
- Action "Để sau" xử lý ở background (`onDidReceiveBackgroundNotificationResponse`, hàm top-level
  `@pragma('vm:entry-point')`): lên lịch lại 1 thông báo sau 15 phút, không mở app.
- **Xong khi:** bấm "Để sau 15'" khi app đã kill vẫn nhận lại thông báo sau 15 phút.

### [ ] T1.5 App icon & splash
- Xuất `assets/mascot/app_icon.svg` ra PNG 1024 (foreground + background cho adaptive icon).
- Dùng `flutter_launcher_icons` và `flutter_native_splash` (nền kem `#FFF8F0`, mặt Upa ở giữa).
- **Xong khi:** icon và splash đúng trên Android 12+ và iOS.

---

## Giai đoạn 2 – Hoàn thiện trải nghiệm

### [ ] T2.1 Đa ngôn ngữ (vi, en)
- Dùng `flutter_localizations` + `gen-l10n` (`l10n.yaml`, `lib/l10n/app_vi.arb`, `app_en.arb`).
- Chuyển toàn bộ chuỗi UI, tên/bước bài tập, nội dung thông báo sang ARB.
- Mặc định theo ngôn ngữ máy, cho phép đổi trong Cài đặt.
- **Xong khi:** không còn chuỗi hiển thị hard-code (grep tiếng Việt có dấu trong `lib/ui` ra rỗng).

### [ ] T2.2 Hình minh họa riêng cho từng bài tập
- Mỗi bài có 2–3 khung SVG (vd: `assets/exercises/neck_tilt_1.svg`, `_2.svg`), phát luân phiên mỗi 1–1.5 giây.
- Hướng: người cách điệu đơn giản thể hiện đúng động tác + Upa nhỏ làm theo ở góc.
- Thêm trường `frames` vào `Exercise`; fallback về `mascot_stretch.svg` nếu thiếu.
- **Xong khi:** 18 bài đều có khung riêng; người chưa đọc hướng dẫn vẫn hiểu động tác.

### [ ] T2.3 Âm thanh & giọng đếm
- Tiếng "tách" nhẹ mỗi giây cuối, tiếng chuông khi xong bài (`audioplayers` hoặc `just_audio`).
- Tùy chọn trong Cài đặt: Âm thanh bật/tắt, Rung bật/tắt. Tôn trọng chế độ im lặng.
- **Xong khi:** mặc định không gây ồn nơi công sở (âm lượng nhỏ, có thể tắt).

### [ ] T2.4 Mascot sống động hơn
- Chớp mắt ngẫu nhiên (tách nhóm `eyes` trong SVG hoặc chuyển mascot sang Rive với state machine
  input `sitMinutes` và trigger `stretch`).
- Hiệu ứng confetti/sao khi đạt mục tiêu (Lottie).
- **Xong khi:** màn Hôm nay có Upa chớp mắt, đạt mục tiêu có hiệu ứng ăn mừng 1 lần/ngày.

### [ ] T2.5 Lời nhắc thông minh hơn
- Mỗi thông báo chọn câu theo ngữ cảnh: sáng sớm, sau giờ trưa, gần tan làm, đã ngồi rất lâu, sắp đạt mục tiêu.
- Tối thiểu 30 câu, không lặp lại câu trong cùng một ngày.
- Logic chọn câu là hàm thuần trong `lib/logic/`, có test.
- **Xong khi:** test chứng minh không trùng câu trong ngày và đúng ngữ cảnh.

### [ ] T2.6 Chế độ tối & khả năng truy cập
- Dark theme (Upa giữ nguyên màu, nền tối ấm).
- Kiểm tra text scale 1.3x không vỡ layout; tất cả nút có `Semantics`/tooltip.
- **Xong khi:** chạy ổn ở dark mode và text scale lớn.

---

## Giai đoạn 3 – Gamification

### [ ] T3.1 Góc làm việc của Upa lên cấp
- Tích lũy tổng số lần giãn cơ → 6 cấp: bàn trống → cây xanh → đèn bàn → ghế công thái học → cửa sổ → Upa phụ.
- Màn Hôm nay vẽ cảnh nền theo cấp phía sau Upa.
- Logic cấp trong `lib/logic/levels.dart` + test.
- **Xong khi:** lên cấp có màn chúc mừng, cảnh nền thay đổi.

### [ ] T3.2 Huy chương
- 20 huy chương: lần đầu tiên, đạt mục tiêu lần đầu, 3/7/30 ngày liên tiếp, tuần trọn vẹn, quay lại sau khi lỡ,
  thử đủ 6 vùng, 100 lần giãn cơ…
- Màn "Huy chương" (lưới, cái chưa đạt thì làm mờ + gợi ý cách đạt).
- **Xong khi:** huy chương được trao đúng thời điểm (test cho từng điều kiện).

### [ ] T3.3 Sổ tay "Upa biết tuốt"
- Mỗi ngày đạt mục tiêu mở khóa 1 mẹo về tư thế/công thái học (vd: chiều cao màn hình chuẩn).
- 40 mẹo, viết ngắn, có nguồn tham khảo uy tín.
- **Xong khi:** mẹo mở khóa theo ngày đạt mục tiêu, xem lại được trong sổ tay.

### [ ] T3.4 Thẻ chia sẻ
- Tạo ảnh thẻ (Upa + thành tích) khi đạt huy chương/streak, chia sẻ qua `share_plus`.
- **Xong khi:** ảnh chia sẻ đẹp trên story 9:16 và feed 1:1.

---

## Giai đoạn 4 – Dữ liệu & thống kê

### [ ] T4.1 Chuyển lưu trữ sang database
- Chuyển `BreakLog` sang `drift` (SQLite); `UserSettings` giữ ở `shared_preferences`.
- Viết migration đọc dữ liệu cũ từ `shared_preferences` một lần rồi xóa key cũ.
- **Xong khi:** dữ liệu cũ được giữ nguyên sau khi cập nhật app; test migration.

### [ ] T4.2 Insights
- Tab Nhật ký: chọn tuần/tháng; so sánh với kỳ trước ("+3 ngày đạt so với tuần trước");
  giờ hay nghỉ nhất; vùng tập nhiều nhất.
- **Xong khi:** số liệu đúng (test với dữ liệu mẫu).

### [ ] T4.3 Health Connect / Apple Health (tùy chọn)
- Ghi mỗi phiên giãn cơ vào Health Connect (Exercise session) / HealthKit (Mindful/Workout).
- Chỉ ghi, không đọc. Có công tắc trong Cài đặt, mặc định tắt.
- **Xong khi:** phiên hiện trong Health Connect/Apple Health với đúng thời lượng.

### [ ] T4.4 Sao lưu & khôi phục
- Xuất/nhập dữ liệu ra file JSON (không cần tài khoản).
- (Tùy chọn sau) Đăng nhập Google/Apple để đồng bộ.
- **Xong khi:** đổi máy vẫn khôi phục được lịch sử bằng file.

---

## Giai đoạn 5 – Kiếm tiền

### [ ] T5.1 Tách Free / Premium
- Tạo `lib/logic/entitlements.dart`: danh sách tính năng Premium.
- Free: nhắc 3 kiểu, 20 bài cơ bản, lịch sử 30 ngày, khiên/tháng.
- Premium: thêm mascot (corgi, gấu trúc, rái cá, mèo đen), 60+ bài và routine theo vấn đề,
  lịch sử không giới hạn, khiên/tuần, chủ đề góc làm việc (Tết, Noel), widget, không quảng cáo.
- **Xong khi:** mọi chỗ khóa tính năng đi qua một hàm `isPremium`/`can(Feature)` duy nhất.

### [ ] T5.2 Thanh toán bằng RevenueCat
- `purchases_flutter`: gói tháng, gói năm, trọn đời. Khôi phục giao dịch.
- Màn paywall: Upa đội vương miện, so sánh Free/Premium, nút khôi phục, link điều khoản/riêng tư.
- **Xong khi:** mua thử bằng tài khoản sandbox (Android test track + iOS sandbox) mở khóa đúng.

### [ ] T5.3 Quảng cáo (bản Free)
- `google_mobile_ads`: chỉ 1 banner/native nhỏ ở màn "Xong" sau phiên tập. Không quảng cáo trong lúc tập,
  không interstitial, không trong thông báo.
- Hỏi đồng ý theo UMP (GDPR) nếu cần.
- **Xong khi:** Premium không thấy quảng cáo; Free chỉ thấy ở màn kết thúc.

### [ ] T5.4 Widget màn hình chính (Premium)
- `home_widget`: hiển thị Upa theo trạng thái + x/mục tiêu; nút "Giãn cơ" mở thẳng phiên tập.
- Android (Glance hoặc RemoteViews) + iOS (WidgetKit).
- **Xong khi:** widget cập nhật sau mỗi lần giãn cơ và mỗi 30 phút.

---

## Giai đoạn 6 – Chất lượng

### [ ] T6.1 Test mở rộng
- Widget test cho: onboarding, màn Hôm nay (từng mood), phiên tập (đếm ngược, bỏ qua, thoát giữa chừng).
- Golden test cho mascot 5 trạng thái.
- Cho `AppState` nhận `clock` giả để test theo thời gian.
- **Xong khi:** coverage `lib/logic` ≥ 90%, `lib/state` ≥ 70%.

### [ ] T6.2 CI
- GitHub Actions: `flutter analyze`, `flutter test`, build APK debug cho mỗi PR.
- **Xong khi:** PR mới tự chạy CI và báo đỏ khi test fail.

### [ ] T6.3 Crash & analytics (tôn trọng riêng tư)
- Firebase Crashlytics + Analytics, chỉ sự kiện ẩn danh: `onboarding_done`, `break_started`,
  `break_completed` (nguồn: notification/manual), `reminder_snoozed`, `paused`, `paywall_viewed`, `purchase`.
- Công tắc tắt analytics trong Cài đặt.
- **Xong khi:** đo được tỷ lệ chạm thông báo → hoàn thành bài, D1/D7 retention.

### [ ] T6.4 Hiệu năng & pin
- Kiểm tra app không giữ wakelock, không chạy timer khi ở background.
- Profile màn Hôm nay và phiên tập: 60fps trên máy tầm trung.
- **Xong khi:** không có cảnh báo pin trong Android vitals ở bản test nội bộ.

---

## Giai đoạn 7 – Phát hành

### [ ] T7.1 Pháp lý & riêng tư
- Viết Privacy Policy, Terms (tiếng Việt + Anh), trang xóa dữ liệu/tài khoản.
- Disclaimer y tế ở onboarding, Cài đặt và mô tả store.
- Nhờ chuyên gia vật lý trị liệu duyệt nội dung bài tập; ghi nhận trong app nếu được phép.
- **Xong khi:** có URL công khai cho Privacy Policy và trang xóa dữ liệu.

### [ ] T7.2 Cấu hình build release
- Android: keystore, `key.properties` (không commit), `applicationId` chính thức, versioning tự động.
- iOS: bundle id, signing, `Info.plist` (mô tả quyền thông báo), AppDelegate cho notification.
- **Xong khi:** build được `appbundle` và `ipa` release.

### [ ] T7.3 Tài nguyên store
- Tên, mô tả ngắn/dài (vi, en) tối ưu từ khóa: "nhắc giãn cơ", "đau cổ vai gáy", "dân văn phòng".
- 6–8 ảnh chụp màn hình có khung + chú thích, feature graphic 1024x500, video ngắn 15–30 giây.
- Điền Data safety (Google) và App Privacy (Apple) đúng với dữ liệu thực tế.
- **Xong khi:** đủ tài nguyên cho cả hai store.

### [ ] T7.4 Thử nghiệm kín
- Google Play: internal testing → closed testing (tài khoản cá nhân mới phải có số tester tối thiểu chạy
  liên tục một số ngày theo quy định hiện hành của Google Play – kiểm tra lại trước khi nộp).
- iOS: TestFlight.
- Thu thập phản hồi qua form trong app (Cài đặt → Góp ý).
- **Xong khi:** đạt điều kiện lên production và sửa xong các lỗi nghiêm trọng.

### [ ] T7.5 Ra mắt
- Phát hành production Android, nộp App Review iOS.
- Bật in-app review (`in_app_review`) sau ngày đạt mục tiêu thứ 5.
- **Xong khi:** app có mặt trên cả hai store.

---

## Giai đoạn 8 – Tăng trưởng (sau ra mắt)

### [ ] T8.1 Landing page
- Trang web tĩnh (Astro hoặc Next.js, deploy Vercel): hero với Upa, demo giãn cơ chạy trên web,
  bảng Free/Premium, FAQ, link store, vi + en.
- **Xong khi:** Lighthouse ≥ 90 cả 4 mục.

### [ ] T8.2 Công cụ miễn phí (SEO)
- Tính số giờ ngồi mỗi năm; tính chiều cao bàn/ghế/màn hình theo chiều cao người; hẹn giờ giãn cơ trên web;
  lịch giãn cơ in ra.
- **Xong khi:** mỗi công cụ là 1 trang riêng, có CTA cài app.

### [ ] T8.3 Cẩm nang SEO
- 4 cụm nội dung: đau theo vùng, bài tập tại bàn, tư thế & setup, thói quen. Mỗi cụm bắt đầu với 5 bài.
- Mỗi bài có tác giả, ngày cập nhật, nguồn tham khảo, disclaimer.
- **Xong khi:** 20 bài đầu được index.

### [ ] T8.4 Gói doanh nghiệp (thử nghiệm)
- Thử thách theo phòng ban, bảng xếp hạng nhóm, mã mời công ty. Bắt đầu bằng pilot với 1 công ty.

---

## Cách giao việc cho Claude Code

Đặt file này ở thư mục gốc dự án, rồi dùng prompt mẫu:

```
Đọc TASKS.md, làm task T1.1.
Trước khi code: nêu ngắn gọn kế hoạch và các file sẽ sửa.
Sau khi code: chạy flutter analyze và flutter test, sửa đến khi sạch,
đánh dấu [x] cho task trong TASKS.md, rồi commit theo quy ước.
```

Khi task lớn (T2.2, T3.1, T5.2, T5.4), yêu cầu tách nhỏ trước:

```
Đọc TASKS.md task T5.2. Chia thành các bước nhỏ có thể commit riêng,
chờ mình duyệt rồi mới làm từng bước.
```
