import 'dart:io' show Platform;

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

/// Lên lịch thông báo nhắc giãn cơ (local notifications, không cần server).
class NotificationService {
  NotificationService({required this.onTapBreak});

  /// Gọi khi người dùng chạm vào thông báo lúc app đang chạy hoặc chạy nền.
  final void Function() onTapBreak;

  static const _payloadBreak = 'break';
  static const _baseId = 1000;
  static const _testId = 1;
  static const _testScheduledId = 2;

  final _plugin = FlutterLocalNotificationsPlugin();

  static const _android = AndroidNotificationDetails(
    'break_reminders',
    'Nhắc giãn cơ',
    channelDescription: 'Lời nhắc đứng dậy, giãn cơ trong giờ làm việc',
    importance: Importance.high,
    priority: Priority.high,
    category: AndroidNotificationCategory.reminder,
  );
  static const _details = NotificationDetails(
    android: _android,
    iOS: DarwinNotificationDetails(),
  );

  /// Lời nhắc theo giọng Upa, xoay vòng.
  static const _messages = [
    ('Upa gù lưng rồi', 'Đứng dậy duỗi người 1 phút cùng mình nhé.'),
    ('Cổ mỏi chưa?', 'Nghiêng cổ vài nhịp là đỡ ngay.'),
    ('Ngồi lâu rồi đó', 'Upa bắt đầu ngáp… mình giãn cơ chút nha.'),
    ('Giờ nghỉ 60 giây!', 'Xoay vai, hít sâu, rồi làm tiếp.'),
    ('Mắt cần nghỉ 👀', 'Nhìn ra xa 20 giây, Upa đếm cho.'),
    ('Upa đợi bạn nè', 'Một bài nhỏ thôi, ngồi tại chỗ cũng làm được.'),
  ];

  Future<void> init() async {
    tzdata.initializeTimeZones();
    const settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      ),
    );
    await _plugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (resp) {
        if (resp.payload == _payloadBreak) onTapBreak();
      },
    );
  }

  /// App được mở bằng cách chạm vào thông báo (khi app đã bị tắt).
  Future<bool> launchedFromNotification() async {
    final details = await _plugin.getNotificationAppLaunchDetails();
    return (details?.didNotificationLaunchApp ?? false) &&
        details?.notificationResponse?.payload == _payloadBreak;
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
    for (var i = 0; i < times.length; i++) {
      final (title, body) = _messages[(times[i].hour + times[i].minute + i) % _messages.length];
      // Dùng UTC với đúng thời điểm tuyệt đối => không cần biết tên múi giờ của máy.
      final when = tz.TZDateTime.from(times[i], tz.UTC);
      await _plugin.zonedSchedule(
        _baseId + i,
        title,
        body,
        when,
        _details,
        // Không xin quyền báo thức chính xác: lệch vài phút vẫn ổn cho lời nhắc giãn cơ.
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        payload: _payloadBreak,
      );
    }
  }

  Future<void> showTest() => _plugin.show(
        _testId,
        'Upa chào bạn 👋',
        'Thông báo hoạt động tốt. Chạm để thử một bài giãn cơ.',
        _details,
        payload: _payloadBreak,
      );

  /// Hẹn một thông báo thử sau [delay] (màn debug) - kiểm tra lịch hoạt động khi app bị tắt.
  Future<DateTime> scheduleTest(Duration delay) async {
    final at = DateTime.now().add(delay);
    await _plugin.zonedSchedule(
      _testScheduledId,
      'Upa nhắc thử ⏰',
      'Lời nhắc hẹn giờ hoạt động tốt. Chạm để giãn cơ.',
      tz.TZDateTime.from(at, tz.UTC),
      _details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      payload: _payloadBreak,
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
