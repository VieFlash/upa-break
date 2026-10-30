import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../l10n/l10n.dart';
import '../../state/app_state.dart';
import '../widgets/schedule_form.dart';

/// Màn debug ẩn (nhấn giữ tiêu đề "Cài đặt" 3 giây): kiểm tra lịch nhắc và thông báo thực tế.
class DebugScreen extends StatefulWidget {
  const DebugScreen({super.key});

  @override
  State<DebugScreen> createState() => _DebugScreenState();
}

class _DebugScreenState extends State<DebugScreen> {
  bool? _permission;
  List<PendingNotificationRequest> _pending = const [];
  bool _loading = true;
  String? _error;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _load();
  }

  Future<void> _load() async {
    final n = AppScope.of(context).notifications;
    try {
      final permission = await n.permissionGranted();
      final pending = await n.pending();
      if (!mounted) return;
      setState(() {
        _permission = permission;
        _pending = [...pending]..sort((a, b) => a.id.compareTo(b.id));
        _error = null;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = '$e';
        _loading = false;
      });
    }
  }

  Future<void> _scheduleTest() async {
    final at = await AppScope.of(context).notifications.scheduleTest(const Duration(minutes: 1));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.l10n.debugScheduledAt(_time(at)))));
    await _load();
  }

  static String _two(int v) => v.toString().padLeft(2, '0');
  static String _time(DateTime t) => '${_two(t.hour)}:${_two(t.minute)}:${_two(t.second)}';
  static String _dayTime(AppLocalizations l, DateTime t) =>
      '${l.weekdayShort(t.weekday)} ${_two(t.day)}/${_two(t.month)} ${_two(t.hour)}:${_two(t.minute)}';

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final l = context.l10n;
    final planned = state.plannedReminders();
    final permissionText = switch (_permission) {
      true => l.permAllowed,
      false => l.permDenied,
      null => l.permUnknown,
    };

    return Scaffold(
      appBar: AppBar(
        title: Text(l.debugTitle),
        actions: [IconButton(tooltip: l.actionRefresh, icon: const Icon(Icons.refresh), onPressed: _load)],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
              children: [
                SectionTitle(l.debugStatus),
                if (_error != null)
                  Card(child: ListTile(leading: const Icon(Icons.warning_amber), title: Text(l.debugError(_error!)))),
                Card(
                  child: Column(children: [
                    ListTile(
                      leading: Icon(_permission == true ? Icons.check_circle : Icons.error_outline),
                      title: Text(l.debugPermission),
                      trailing: Text(permissionText),
                    ),
                    ListTile(
                      leading: const Icon(Icons.schedule),
                      title: Text(l.debugNow),
                      trailing: Text(_dayTime(l, state.now)),
                    ),
                  ]),
                ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: _scheduleTest,
                  icon: const Icon(Icons.alarm_add),
                  label: Text(l.debugTestIn1Min),
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: () async {
                    await state.reschedule();
                    await _load();
                  },
                  icon: const Icon(Icons.restart_alt),
                  label: Text(l.debugReschedule),
                ),
                SectionTitle(l.debugPlanned(planned.length)),
                Card(
                  child: planned.isEmpty
                      ? ListTile(title: Text(l.debugPlannedEmpty))
                      : Column(children: [
                          for (final t in planned) ListTile(dense: true, title: Text(_dayTime(l, t))),
                        ]),
                ),
                SectionTitle(l.debugPending(_pending.length)),
                Card(
                  child: _pending.isEmpty
                      ? ListTile(title: Text(l.debugPendingEmpty))
                      : Column(children: [
                          for (final p in _pending)
                            ListTile(
                              dense: true,
                              leading: Text('#${p.id}'),
                              title: Text(p.title ?? ''),
                              subtitle: Text(p.body ?? ''),
                            ),
                        ]),
                ),
              ],
            ),
    );
  }
}
