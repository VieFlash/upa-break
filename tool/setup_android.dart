// Chạy sau `flutter create`:  dart run tool/setup_android.dart
// Thêm quyền thông báo, receiver cho flutter_local_notifications và bật core library desugaring.
import 'dart:io';

void main() {
  _patchManifest();
  _patchGradle();
  stdout.writeln('Xong. Chạy tiếp: flutter pub get && flutter run');
}

void _patchManifest() {
  final f = File('android/app/src/main/AndroidManifest.xml');
  if (!f.existsSync()) {
    stderr.writeln('Không thấy ${f.path}. Hãy chạy `flutter create` trước.');
    exit(1);
  }
  var xml = f.readAsStringSync();

  const permissions = [
    'android.permission.POST_NOTIFICATIONS',
    'android.permission.RECEIVE_BOOT_COMPLETED',
    'android.permission.VIBRATE',
  ];
  final missing = permissions.where((p) => !xml.contains(p)).toList();
  if (missing.isNotEmpty) {
    final lines = missing.map((p) => '    <uses-permission android:name="$p"/>').join('\n');
    xml = xml.replaceFirst('<application', '$lines\n    <application');
  }

  if (!xml.contains('ScheduledNotificationReceiver')) {
    const receivers = '''
        <receiver android:exported="false" android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationReceiver" />
        <receiver android:exported="false" android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationBootReceiver">
            <intent-filter>
                <action android:name="android.intent.action.BOOT_COMPLETED"/>
                <action android:name="android.intent.action.MY_PACKAGE_REPLACED"/>
                <action android:name="android.intent.action.QUICKBOOT_POWERON" />
                <action android:name="com.htc.intent.action.QUICKBOOT_POWERON"/>
            </intent-filter>
        </receiver>
    </application>''';
    xml = xml.replaceFirst('</application>', receivers.trimLeft().replaceFirst('<receiver', '    <receiver'));
  }

  // Tên app hiển thị.
  xml = xml.replaceFirst(RegExp(r'android:label="[^"]*"'), 'android:label="Upa Break"');

  f.writeAsStringSync(xml);
  stdout.writeln('✓ AndroidManifest.xml');
}

void _patchGradle() {
  final kts = File('android/app/build.gradle.kts');
  final groovy = File('android/app/build.gradle');
  const desugar = 'com.android.tools:desugar_jdk_libs:2.1.4';

  if (kts.existsSync()) {
    var s = kts.readAsStringSync();
    if (!s.contains('isCoreLibraryDesugaringEnabled')) {
      s = s.replaceFirst('compileOptions {', 'compileOptions {\n        isCoreLibraryDesugaringEnabled = true');
    }
    if (!s.contains('desugar_jdk_libs')) {
      s += '\ndependencies {\n    coreLibraryDesugaring("$desugar")\n}\n';
    }
    kts.writeAsStringSync(s);
    stdout.writeln('✓ build.gradle.kts');
  } else if (groovy.existsSync()) {
    var s = groovy.readAsStringSync();
    if (!s.contains('coreLibraryDesugaringEnabled')) {
      s = s.replaceFirst('compileOptions {', 'compileOptions {\n        coreLibraryDesugaringEnabled true');
    }
    if (!s.contains('desugar_jdk_libs')) {
      s += "\ndependencies {\n    coreLibraryDesugaring '$desugar'\n}\n";
    }
    groovy.writeAsStringSync(s);
    stdout.writeln('✓ build.gradle');
  } else {
    stderr.writeln('Không thấy android/app/build.gradle(.kts).');
    exit(1);
  }
}
