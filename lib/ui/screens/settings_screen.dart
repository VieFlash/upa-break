import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';

import '../../logic/battery_guide.dart';
import '../../models/settings.dart';
import '../../services/system_settings.dart';
import '../../state/app_state.dart';
import '../widgets/permission_banner.dart';
import '../widgets/schedule_form.dart';
import 'debug_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final s = state.settings;

    void save(UserSettings next) {
      if (next.workEnd <= next.workStart) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Giờ tan làm phải sau giờ vào làm nhé.')),
        );
        return;
      }
      state.updateSettings(next);
    }

    return Scaffold(
      appBar: AppBar(
        title: _HoldToOpen(
          onOpen: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const DebugScreen())),
          child: const Text('Cài đặt'),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
        children: [
          const SectionTitle('Giờ làm việc'),
          TimeRangeTile(
            label: 'Vào làm – tan làm',
            start: s.workStart,
            end: s.workEnd,
            onChanged: (a, b) => save(s.copyWith(workStart: a, workEnd: b)),
          ),
          const SizedBox(height: 8),
          Card(
            child: SwitchListTile(
              title: const Text('Không nhắc giờ nghỉ trưa'),
              value: s.lunchEnabled,
              onChanged: (v) => save(s.copyWith(lunchEnabled: v)),
            ),
          ),
          const SizedBox(height: 8),
          TimeRangeTile(
            label: 'Giờ nghỉ trưa',
            start: s.lunchStart,
            end: s.lunchEnd,
            enabled: s.lunchEnabled,
            onChanged: (a, b) => save(s.copyWith(lunchStart: a, lunchEnd: b)),
          ),
          const SectionTitle('Ngày làm việc'),
          WorkDaysPicker(days: s.workDays, onChanged: (d) => save(s.copyWith(workDays: d))),
          const SectionTitle('Kiểu nhắc'),
          ModePicker(mode: s.mode, onChanged: (m) => save(s.copyWith(mode: m))),
          const SectionTitle('Vùng hay mỏi'),
          AreaPicker(areas: s.focusAreas, onChanged: (a) => save(s.copyWith(focusAreas: a))),
          const SizedBox(height: 8),
          Text('Mục tiêu hiện tại: ${s.dailyGoal} lần/ngày'),
          const SectionTitle('Thông báo'),
          Card(
            child: ListTile(
              leading: Icon(
                state.notificationsBlocked ? Icons.notifications_off_outlined : Icons.notifications_outlined,
              ),
              title: Text(state.notificationsBlocked ? 'Thông báo đang tắt' : 'Thông báo đang bật'),
              subtitle: Text(state.notificationsBlocked
                  ? 'Upa không nhắc được cho tới khi bạn bật lại'
                  : 'Upa sẽ nhắc trong giờ làm'),
              trailing: state.notificationsBlocked
                  ? TextButton(onPressed: () => PermissionBanner.enable(state), child: const Text('Bật'))
                  : null,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.notifications_active_outlined),
              title: const Text('Gửi thông báo thử'),
              subtitle: const Text('Kiểm tra xem điện thoại có hiện lời nhắc không'),
              onTap: () async {
                await state.notifications.requestPermission();
                await state.notifications.showTest();
              },
            ),
          ),
          if (Platform.isAndroid) ...[
            const SectionTitle('Nhắc đúng giờ'),
            const _BatteryGuideCard(),
          ],
          const SizedBox(height: 24),
          Text(
            'Upa Break là app tạo thói quen, không phải lời khuyên y tế. '
            'Nếu bị đau kéo dài, hãy gặp bác sĩ hoặc chuyên gia vật lý trị liệu.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

/// Nhấn giữ [child] đủ 3 giây thì gọi [onOpen] (lối vào màn debug ẩn).
class _HoldToOpen extends StatefulWidget {
  const _HoldToOpen({required this.onOpen, required this.child});

  final VoidCallback onOpen;
  final Widget child;

  @override
  State<_HoldToOpen> createState() => _HoldToOpenState();
}

class _HoldToOpenState extends State<_HoldToOpen> {
  static const _hold = Duration(seconds: 3);
  Timer? _timer;

  void _cancel([_]) => _timer?.cancel();

  @override
  void dispose() {
    _cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Listener(
        behavior: HitTestBehavior.opaque,
        onPointerDown: (_) {
          _cancel();
          _timer = Timer(_hold, widget.onOpen);
        },
        onPointerUp: _cancel,
        onPointerCancel: _cancel,
        child: widget.child,
      );
}

/// Hướng dẫn tắt tối ưu pin theo hãng máy (Android) + lối tắt tới màn cài đặt tương ứng.
class _BatteryGuideCard extends StatelessWidget {
  const _BatteryGuideCard();

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return FutureBuilder<OemBrand>(
      future: SystemSettings.oemBrand(),
      builder: (context, snap) {
        final brand = snap.data ?? OemBrand.other;
        final steps = batteryGuideSteps(brand);
        return Card(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Không nhận được lời nhắc? Máy có thể đang chặn Upa chạy nền.'),
                const SizedBox(height: 8),
                Text('Trên ${oemBrandName(brand)}:', style: t.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                for (var i = 0; i < steps.length; i++)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Text('${i + 1}. ${steps[i]}'),
                  ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    OutlinedButton.icon(
                      onPressed: SystemSettings.openBatteryOptimization,
                      icon: const Icon(Icons.battery_saver_outlined),
                      label: const Text('Tắt tối ưu pin'),
                    ),
                    OutlinedButton.icon(
                      onPressed: SystemSettings.openAppSettings,
                      icon: const Icon(Icons.app_settings_alt_outlined),
                      label: const Text('Cài đặt ứng dụng'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
