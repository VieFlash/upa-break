import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upa_break/data/storage.dart';
import 'package:upa_break/services/notification_service.dart';
import 'package:upa_break/state/app_state.dart';
import 'package:upa_break/ui/screens/debug_screen.dart';
import 'package:upa_break/ui/screens/settings_screen.dart';

void main() {
  Future<void> pumpSettings(WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final state = AppState(await Storage.open(), NotificationService(onTapBreak: () {}));
    // giống app.dart: AppScope bọc MaterialApp để route mới (DebugScreen) cũng đọc được state
    await tester.pumpWidget(AppScope(state: state, child: const MaterialApp(home: SettingsScreen())));
  }

  testWidgets('nhấn giữ tiêu đề "Cài đặt" 3 giây thì mở màn debug', (tester) async {
    await pumpSettings(tester);
    final g = await tester.startGesture(tester.getCenter(find.text('Cài đặt')));
    await tester.pump(const Duration(seconds: 2));
    expect(find.byType(DebugScreen), findsNothing);
    await tester.pump(const Duration(milliseconds: 1100));
    await tester.pumpAndSettle();
    expect(find.byType(DebugScreen), findsOneWidget);
    await g.up();
  });

  testWidgets('giữ chưa đủ 3 giây thì không mở', (tester) async {
    await pumpSettings(tester);
    final g = await tester.startGesture(tester.getCenter(find.text('Cài đặt')));
    await tester.pump(const Duration(milliseconds: 2500));
    await g.up();
    await tester.pump(const Duration(seconds: 2));
    expect(find.byType(DebugScreen), findsNothing);
  });
}
