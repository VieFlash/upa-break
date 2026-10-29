// Chạy sau `flutter create`:  dart run tool/setup_ios.dart
// Chuyển sang UIScene lifecycle, gắn UNUserNotificationCenter delegate cho flutter_local_notifications, đặt tên app.
import 'dart:io';

void main() {
  _patchAppDelegate();
  _patchInfoPlist();
  _patchDeploymentTarget();
  stdout.writeln('Xong. Chạy tiếp: flutter pub get && flutter run');
}

void _patchAppDelegate() {
  final f = File('ios/Runner/AppDelegate.swift');
  if (!f.existsSync()) {
    stderr.writeln('Không thấy ${f.path}. Hãy chạy `flutter create` trước.');
    exit(1);
  }
  // iOS 27 bắt buộc UIScene lifecycle (cần Flutter >= 3.38): plugin đăng ký qua implicit engine.
  // Đồng thời cho phép hiện thông báo khi app đang mở, và đăng ký plugin cho isolate chạy nền.
  const appDelegate = '''
import Flutter
import UIKit
import flutter_local_notifications

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { registry in
      GeneratedPluginRegistrant.register(with: registry)
    }
    UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
  }
}
''';
  f.writeAsStringSync(appDelegate.trimLeft());
  stdout.writeln('✓ AppDelegate.swift');
}

const _sceneManifest = '''
	<key>UIApplicationSceneManifest</key>
	<dict>
		<key>UIApplicationSupportsMultipleScenes</key>
		<false/>
		<key>UISceneConfigurations</key>
		<dict>
			<key>UIWindowSceneSessionRoleApplication</key>
			<array>
				<dict>
					<key>UISceneClassName</key>
					<string>UIWindowScene</string>
					<key>UISceneConfigurationName</key>
					<string>flutter</string>
					<key>UISceneDelegateClassName</key>
					<string>FlutterSceneDelegate</string>
					<key>UISceneStoryboardFile</key>
					<string>Main</string>
				</dict>
			</array>
		</dict>
	</dict>''';

void _patchInfoPlist() {
  final f = File('ios/Runner/Info.plist');
  if (!f.existsSync()) {
    stderr.writeln('Không thấy ${f.path}.');
    exit(1);
  }
  var xml = f.readAsStringSync();

  final displayName = RegExp(r'(<key>CFBundleDisplayName</key>\s*<string>)[^<]*(</string>)');
  if (displayName.hasMatch(xml)) {
    xml = xml.replaceFirstMapped(displayName, (m) => '${m[1]}Upa Break${m[2]}');
  } else {
    xml = xml.replaceFirst(
        '<dict>', '<dict>\n\t<key>CFBundleDisplayName</key>\n\t<string>Upa Break</string>');
  }

  if (!xml.contains('UIApplicationSceneManifest')) {
    xml = xml.replaceFirst(RegExp(r'</dict>\s*</plist>'), '$_sceneManifest\n</dict>\n</plist>');
  }

  f.writeAsStringSync(xml);
  stdout.writeln('✓ Info.plist');
}

// Xcode mới chỉ hỗ trợ deployment target >= 15.0.
const _minIos = '15.0';

void _patchDeploymentTarget() {
  final pbx = File('ios/Runner.xcodeproj/project.pbxproj');
  if (pbx.existsSync()) {
    pbx.writeAsStringSync(pbx.readAsStringSync().replaceAll(
        RegExp(r'IPHONEOS_DEPLOYMENT_TARGET = [\d.]+;'), 'IPHONEOS_DEPLOYMENT_TARGET = $_minIos;'));
    stdout.writeln('✓ project.pbxproj (iOS $_minIos)');
  }

  final info = File('ios/Flutter/AppFrameworkInfo.plist');
  if (info.existsSync()) {
    info.writeAsStringSync(info.readAsStringSync().replaceFirstMapped(
        RegExp(r'(<key>MinimumOSVersion</key>\s*<string>)[^<]*(</string>)'),
        (m) => '${m[1]}$_minIos${m[2]}'));
    stdout.writeln('✓ AppFrameworkInfo.plist');
  }

  // Podfile chỉ có sau lần build/pod install đầu tiên.
  final podfile = File('ios/Podfile');
  if (podfile.existsSync()) {
    podfile.writeAsStringSync(podfile.readAsStringSync().replaceFirst(
        RegExp(r"^#?\s*platform :ios, '[\d.]+'", multiLine: true), "platform :ios, '$_minIos'"));
    stdout.writeln('✓ Podfile');
  }
}
