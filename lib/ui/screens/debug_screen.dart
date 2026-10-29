import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Đã hẹn lúc ${_time(at)}. Có thể tắt app để thử (Android có thể lệch vài phút).'),
    ));
    await _load();
  }

  static String _two(int v) => v.toString().padLeft(2, '0');
  static String _time(DateTime t) => '${_two(t.hour)}:${_two(t.minute)}:${_two(t.second)}';
  static String _dayTime(DateTime t) =>
      '${const ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'][t.weekday - 1]} '
      '${_two(t.day)}/${_two(t.month)} ${_two(t.hour)}:${_two(t.minute)}';

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final planned = state.plannedReminders();
    final permissionText = switch (_permission) {
      true => 'Đã cho phép',
      false => 'Bị từ chối / đang tắt',
      null => 'Không xác định',
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Debug thông báo'),
        actions: [IconButton(tooltip: 'Làm mới', icon: const Icon(Icons.refresh), onPressed: _load)],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
              children: [
                const SectionTitle('Trạng thái'),
                if (_error != null)
                  Card(child: ListTile(leading: const Icon(Icons.warning_amber), title: Text('Lỗi: $_error'))),
                Card(
                  child: Column(children: [
                    ListTile(
                      leading: Icon(_permission == true ? Icons.check_circle : Icons.error_outline),
                      title: const Text('Quyền thông báo'),
                      trailing: Text(permissionText),
                    ),
                    ListTile(
                      leading: const Icon(Icons.schedule),
                      title: const Text('Bây giờ'),
                      trailing: Text(_dayTime(state.now)),
                    ),
                  ]),
                ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: _scheduleTest,
                  icon: const Icon(Icons.alarm_add),
                  label: const Text('Nhắc thử sau 1 phút'),
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: () async {
                    await state.reschedule();
                    await _load();
                  },
                  icon: const Icon(Icons.restart_alt),
                  label: const Text('Lên lịch lại'),
                ),
                SectionTitle('Mốc nhắc theo kế hoạch (${planned.length})'),
                Card(
                  child: planned.isEmpty
                      ? const ListTile(title: Text('Không có mốc nào (đã đạt mục tiêu / ngoài giờ làm?)'))
                      : Column(children: [
                          for (final t in planned) ListTile(dense: true, title: Text(_dayTime(t))),
                        ]),
                ),
                SectionTitle('Đang chờ trong hệ thống (${_pending.length})'),
                Card(
                  child: _pending.isEmpty
                      ? const ListTile(title: Text('Không có thông báo nào đang chờ'))
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
