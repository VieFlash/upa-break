import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';

import '../../l10n/l10n.dart';
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
    final l = context.l10n;

    void save(UserSettings next) {
      if (next.workEnd <= next.workStart) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l.workEndBeforeStart)),
        );
        return;
      }
      state.updateSettings(next);
    }

    return Scaffold(
      appBar: AppBar(
        title: _HoldToOpen(
          onOpen: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const DebugScreen())),
          child: Text(l.tabSettings),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
        children: [
          SectionTitle(l.sectionWorkHours),
          TimeRangeTile(
            label: l.workStartEnd,
            start: s.workStart,
            end: s.workEnd,
            onChanged: (a, b) => save(s.copyWith(workStart: a, workEnd: b)),
          ),
          const SizedBox(height: 8),
          Card(
            child: SwitchListTile(
              title: Text(l.noRemindLunch),
              value: s.lunchEnabled,
              onChanged: (v) => save(s.copyWith(lunchEnabled: v)),
            ),
          ),
          const SizedBox(height: 8),
          TimeRangeTile(
            label: l.lunchTime,
            start: s.lunchStart,
            end: s.lunchEnd,
            enabled: s.lunchEnabled,
            onChanged: (a, b) => save(s.copyWith(lunchStart: a, lunchEnd: b)),
          ),
          SectionTitle(l.sectionWorkDays),
          WorkDaysPicker(days: s.workDays, onChanged: (d) => save(s.copyWith(workDays: d))),
          SectionTitle(l.sectionReminderStyle),
          ModePicker(mode: s.mode, onChanged: (m) => save(s.copyWith(mode: m))),
          SectionTitle(l.sectionAreas),
          AreaPicker(areas: s.focusAreas, onChanged: (a) => save(s.copyWith(focusAreas: a))),
          const SizedBox(height: 8),
          Text(l.currentGoal(s.dailyGoal)),
          SectionTitle(l.sectionLanguage),
          _LanguagePicker(
            language: s.language,
            onChanged: (lang) => state.updateSettings(s.copyWith(language: lang)),
          ),
          SectionTitle(l.sectionNotifications),
          Card(
            child: ListTile(
              leading: Icon(
                state.notificationsBlocked ? Icons.notifications_off_outlined : Icons.notifications_outlined,
              ),
              title: Text(state.notificationsBlocked ? l.notifOff : l.notifOn),
              subtitle: Text(state.notificationsBlocked ? l.notifOffSub : l.notifOnSub),
              trailing: state.notificationsBlocked
                  ? TextButton(onPressed: () => PermissionBanner.enable(state), child: Text(l.actionEnable))
                  : null,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.notifications_active_outlined),
              title: Text(l.sendTestNotification),
              subtitle: Text(l.sendTestNotificationSub),
              onTap: () async {
                await state.notifications.requestPermission();
                await state.notifications.showTest();
              },
            ),
          ),
          if (Platform.isAndroid) ...[
            SectionTitle(l.sectionOnTime),
            const _BatteryGuideCard(),
          ],
          const SizedBox(height: 24),
          Text(l.disclaimer, style: Theme.of(context).textTheme.bodySmall),
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
    final l = context.l10n;
    return FutureBuilder<OemBrand>(
      future: SystemSettings.oemBrand(),
      builder: (context, snap) {
        final brand = snap.data ?? OemBrand.other;
        final steps = l.batteryGuide(brand);
        return Card(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l.batteryIntro),
                const SizedBox(height: 8),
                Text(l.onBrand(oemBrandName(brand)), style: t.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
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
                      label: Text(l.disableBatteryOpt),
                    ),
                    OutlinedButton.icon(
                      onPressed: SystemSettings.openAppSettings,
                      icon: const Icon(Icons.app_settings_alt_outlined),
                      label: Text(l.appSettings),
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

/// Chọn ngôn ngữ: theo máy (null) / Tiếng Việt / English.
class _LanguagePicker extends StatelessWidget {
  const _LanguagePicker({required this.language, required this.onChanged});
  final String? language;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Card(
      child: Column(
        children: [
          for (final (code, label) in [(null, l.languageSystem), ('vi', l.languageVi), ('en', l.languageEn)])
            ListTile(
              title: Text(label),
              trailing: code == language ? Icon(Icons.check, color: Theme.of(context).colorScheme.primary) : null,
              onTap: () => onChanged(code),
            ),
        ],
      ),
    );
  }
}
