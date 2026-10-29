import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upa_break/data/storage.dart';
import 'package:upa_break/services/notification_service.dart';
import 'package:upa_break/state/app_state.dart';
import 'package:upa_break/ui/screens/home_screen.dart';

/// Giả lập quyền thông báo mà không cần plugin native.
class _FakeNotifications extends NotificationService {
  _FakeNotifications(this.allowed) : super(onTapBreak: () {});
  bool allowed;

  @override
  Future<bool?> permissionGranted() async => allowed;

  @override
  Future<bool> requestPermission() async => allowed;

  @override
  Future<void> scheduleAll(List<DateTime> times) async {}
}

void main() {
  Future<AppState> pumpHome(WidgetTester tester, {required bool allowed}) async {
    // khung cao để cả nút "Giãn cơ ngay" nằm trong màn; rộng hơn điện thoại một chút vì font test (Ahem)
    // vẽ mỗi ký tự thành ô vuông, rộng hơn font thật (độ co giãn chữ kiểm tra riêng ở T2.6)
    tester.view
      ..physicalSize = const Size(1080, 2400)
      ..devicePixelRatio = 2;
    addTearDown(tester.view.reset);
    SharedPreferences.setMockInitialValues({});
    final state = AppState(await Storage.open(), _FakeNotifications(allowed));
    await state.refreshPermission();
    await tester.pumpWidget(AppScope(state: state, child: const MaterialApp(home: HomeScreen())));
    await tester.pump();
    return state;
  }

  testWidgets('từ chối quyền: hiện banner, app vẫn dùng được', (tester) async {
    await pumpHome(tester, allowed: false);
    expect(find.text('Upa chưa được phép nhắc bạn'), findsOneWidget);
    expect(find.text('Bật thông báo'), findsOneWidget);
    expect(find.textContaining('Giãn cơ ngay'), findsOneWidget);
  });

  testWidgets('có quyền: không hiện banner', (tester) async {
    await pumpHome(tester, allowed: true);
    expect(find.text('Upa chưa được phép nhắc bạn'), findsNothing);
  });

  testWidgets('bật lại quyền trong Cài đặt hệ thống rồi quay về: banner tự ẩn', (tester) async {
    final state = await pumpHome(tester, allowed: false);
    (state.notifications as _FakeNotifications).allowed = true;
    await state.refreshPermission(); // app gọi khi quay lại foreground
    await tester.pump();
    expect(find.text('Upa chưa được phép nhắc bạn'), findsNothing);
  });
}
