import 'dart:io' show Platform;

import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import '../l10n/l10n.dart';
import '../logic/reminder_planner.dart';

/// Người dùng bấm một action không mở app (vd "Để sau 15'") khi app đang tắt/chạy nền:
/// plugin chạy hàm này trên một background isolate riêng. Ngôn ngữ lấy từ payload của thông báo.
@pragma('vm:entry-point')
Future<void> onBackgroundNotificationResponse(NotificationResponse response) async {
  if (response.actionId != NotificationService.actionSnooze) return;
  WidgetsFlutterBinding.ensureInitialized();
  final l = l10nFor(NotificationService._languageOf(response.payload));
  final plugin = FlutterLocalNotificationsPlugin();
  await plugin.initialize(NotificationService._initSettings(l));
  await NotificationService._scheduleSnooze(plugin, l);
}

/// Lên lịch thông báo nhắc giãn cơ (local notifications, không cần server).
class NotificationService {
  NotificationService({required this.onTapBreak});

  /// Gọi khi người dùng chạm vào thông báo lúc app đang chạy hoặc chạy nền.
  final void Function() onTapBreak;

  /// Payload `break:<ngôn ngữ>`: mở phiên giãn cơ; ngôn ngữ để isolate nền viết lời nhắc lại.
  static const _payloadBreak = 'break';
  static const _baseId = 1000;
  static const _testId = 1;
  static const _testScheduledId = 2;
  /// Lời nhắc lại sau "Để sau": id < [_baseId] nên không bị xóa khi app đặt lại lịch.
  static const _snoozeId = 3;

  static const actionStart = 'start';
  static const actionSnooze = 'snooze';
  static const _category = 'break_reminder';

  final _plugin = FlutterLocalNotificationsPlugin();
  String _language = 'vi';
  late AppLocalizations _l = l10nFor(_language);

  static String _payload(AppLocalizations l) => '$_payloadBreak:${l.localeName}';
  static bool _isBreak(String? payload) => payload?.startsWith(_payloadBreak) ?? false;
  static String _languageOf(String? payload) {
    final parts = payload?.split(':') ?? const [];
    return parts.length > 1 ? parts[1] : 'vi';
  }

  static NotificationDetails _details(AppLocalizations l) => NotificationDetails(
        android: AndroidNotificationDetails(
          'break_reminders',
          l.notifChannelName,
          channelDescription: l.notifChannelDesc,
          importance: Importance.high,
          priority: Priority.high,
          category: AndroidNotificationCategory.reminder,
          actions: [
            AndroidNotificationAction(actionStart, l.notifActionStart, showsUserInterface: true),
            AndroidNotificationAction(actionSnooze, l.notifActionSnooze(ReminderPlanner.snoozeMinutes)),
          ],
        ),
        iOS: const DarwinNotificationDetails(categoryIdentifier: _category),
      );

  static InitializationSettings _initSettings(AppLocalizations l) => InitializationSettings(
        android: const AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
          notificationCategories: [
            DarwinNotificationCategory(_category, actions: [
              DarwinNotificationAction.plain(actionStart, l.notifActionStart,
                  options: {DarwinNotificationActionOption.foreground}),
              DarwinNotificationAction.plain(actionSnooze, l.notifActionSnooze(ReminderPlanner.snoozeMinutes)),
            ]),
          ],
        ),
      );

  Future<void> init(String language) async {
    tzdata.initializeTimeZones();
    _language = language;
    _l = l10nFor(language);
    await _plugin.initialize(
      _initSettings(_l),
      onDidReceiveNotificationResponse: (resp) {
        // "Để sau" khi app đang mở: hẹn lại, không mở màn giãn cơ.
        if (resp.actionId == actionSnooze) {
          _scheduleSnooze(_plugin, _l);
        } else if (_isBreak(resp.payload)) {
          onTapBreak();
        }
      },
      onDidReceiveBackgroundNotificationResponse: onBackgroundNotificationResponse,
    );
  }

  /// Đổi ngôn ngữ thông báo; khởi tạo lại để iOS nhận tên nút action mới.
  Future<void> setLanguage(String language) async {
    if (language == _language) return;
    await init(language);
  }

  static Future<void> _scheduleSnooze(FlutterLocalNotificationsPlugin plugin, AppLocalizations l) async {
    tzdata.initializeTimeZones();
    await plugin.zonedSchedule(
      _snoozeId,
      l.notifSnoozeTitle,
      l.notifSnoozeBody(ReminderPlanner.snoozeMinutes),
      tz.TZDateTime.from(ReminderPlanner.snoozeAt(DateTime.now()), tz.UTC),
      _details(l),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      payload: _payload(l),
    );
  }

  /// App được mở bằng cách chạm vào thông báo (khi app đã bị tắt).
  Future<bool> launchedFromNotification() async {
    final details = await _plugin.getNotificationAppLaunchDetails();
    return (details?.didNotificationLaunchApp ?? false) && _isBreak(details?.notificationResponse?.payload);
  }

  Future<bool> requestPermission() async {
    if (Platform.isAndroid) {
      final android = _plugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      return await android?.requestNotificationsPermission() ?? true;
    }
    if (Platform.isIOS) {
      final ios = _plugin
          .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
      return await ios?.requestPermissions(alert: true, badge: true, sound: true) ?? false;
    }
    return true;
  }

  /// Xóa lịch cũ và đặt lại toàn bộ (rolling schedule).
  /// Chỉ hủy lời nhắc của lịch (id >= [_baseId]) để không xóa thông báo thử đang chờ.
  Future<void> scheduleAll(List<DateTime> times) async {
    for (final p in await _plugin.pendingNotificationRequests()) {
      if (p.id >= _baseId) await _plugin.cancel(p.id);
    }
    final messages = _l.reminderMessages;
    for (var i = 0; i < times.length; i++) {
      final (title, body) = messages[(times[i].hour + times[i].minute + i) % messages.length];
      // Dùng UTC với đúng thời điểm tuyệt đối => không cần biết tên múi giờ của máy.
      final when = tz.TZDateTime.from(times[i], tz.UTC);
      await _plugin.zonedSchedule(
        _baseId + i,
        title,
        body,
        when,
        _details(_l),
        // Không xin quyền báo thức chính xác: lệch vài phút vẫn ổn cho lời nhắc giãn cơ.
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        payload: _payload(_l),
      );
    }
  }

  Future<void> showTest() => _plugin.show(
        _testId,
        _l.notifTestTitle,
        _l.notifTestBody,
        _details(_l),
        payload: _payload(_l),
      );

  /// Hẹn một thông báo thử sau [delay] (màn debug) - kiểm tra lịch hoạt động khi app bị tắt.
  Future<DateTime> scheduleTest(Duration delay) async {
    final at = DateTime.now().add(delay);
    await _plugin.zonedSchedule(
      _testScheduledId,
      _l.notifTestScheduledTitle,
      _l.notifTestScheduledBody,
      tz.TZDateTime.from(at, tz.UTC),
      _details(_l),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      payload: _payload(_l),
    );
    return at;
  }

  /// Các thông báo đang chờ trong hệ điều hành.
  Future<List<PendingNotificationRequest>> pending() => _plugin.pendingNotificationRequests();

  /// Quyền hiện thông báo: true/false, hoặc null nếu không xác định được.
  Future<bool?> permissionGranted() async {
    if (Platform.isAndroid) {
      return _plugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.areNotificationsEnabled();
    }
    if (Platform.isIOS) {
      final opts = await _plugin
          .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
          ?.checkPermissions();
      return opts?.isEnabled;
    }
    return null;
  }

  Future<void> cancelAll() => _plugin.cancelAll();
}
