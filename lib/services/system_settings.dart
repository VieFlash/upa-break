import 'dart:io' show Platform;

import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

import '../logic/battery_guide.dart';

/// Mở các màn cài đặt hệ thống (quyền thông báo, tối ưu pin). Không cần thêm quyền Android/iOS.
class SystemSettings {
  /// Phải khớp `applicationId` trong android/app/build.gradle.kts.
  static const _androidPackage = 'app.upabreak.upa_break';
  static const _newTask = [Flag.FLAG_ACTIVITY_NEW_TASK];

  /// Màn bật/tắt thông báo của app (Android), hoặc trang Cài đặt của app (iOS).
  static Future<void> openNotificationSettings() async {
    if (Platform.isAndroid) {
      await _launchOr(
        const AndroidIntent(
          action: 'android.settings.APP_NOTIFICATION_SETTINGS',
          arguments: {'android.provider.extra.APP_PACKAGE': _androidPackage},
          flags: _newTask,
        ),
        fallback: openAppSettings,
      );
    } else if (Platform.isIOS) {
      await launchUrl(Uri.parse('app-settings:'));
    }
  }

  /// Trang thông tin ứng dụng (pin, tự khởi động, thông báo… tùy hãng).
  static Future<void> openAppSettings() async {
    if (Platform.isAndroid) {
      await const AndroidIntent(
        action: 'android.settings.APPLICATION_DETAILS_SETTINGS',
        data: 'package:$_androidPackage',
        flags: _newTask,
      ).launch();
    } else if (Platform.isIOS) {
      await launchUrl(Uri.parse('app-settings:'));
    }
  }

  /// Danh sách "Tối ưu hóa pin" của hệ thống (Android). Dùng màn danh sách thay vì
  /// REQUEST_IGNORE_BATTERY_OPTIMIZATIONS để không phải xin thêm quyền.
  static Future<void> openBatteryOptimization() => _launchOr(
        const AndroidIntent(action: 'android.settings.IGNORE_BATTERY_OPTIMIZATION_SETTINGS', flags: _newTask),
        fallback: openAppSettings,
      );

  /// Hãng máy hiện tại (chỉ có nghĩa trên Android).
  static Future<OemBrand> oemBrand() async {
    if (!Platform.isAndroid) return OemBrand.other;
    try {
      final info = await DeviceInfoPlugin().androidInfo;
      return oemBrandOf(info.manufacturer, info.brand);
    } catch (e) {
      debugPrint('Không đọc được thông tin máy: $e');
      return OemBrand.other;
    }
  }

  static Future<void> _launchOr(AndroidIntent intent, {required Future<void> Function() fallback}) async {
    try {
      if (await intent.canResolveActivity() ?? false) {
        await intent.launch();
        return;
      }
    } catch (e) {
      debugPrint('Không mở được ${intent.action}: $e');
    }
    await fallback();
  }
}
