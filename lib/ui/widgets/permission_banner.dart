import 'package:flutter/material.dart';

import '../../services/system_settings.dart';
import '../../state/app_state.dart';

/// Banner khi thông báo bị tắt: app vẫn dùng được, chỉ là Upa không nhắc được.
/// Bấm nút: xin lại quyền; nếu hệ điều hành không hỏi nữa thì mở Cài đặt hệ thống.
class PermissionBanner extends StatelessWidget {
  const PermissionBanner({super.key});

  static Future<void> enable(AppState state) async {
    if (!await state.askPermissionAgain()) await SystemSettings.openNotificationSettings();
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    if (!state.notificationsBlocked) return const SizedBox.shrink();
    final t = Theme.of(context).textTheme;
    return Card(
      color: const Color(0xFFFFF1D6),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 12, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.notifications_off_outlined, color: Color(0xFFB7791F)),
                const SizedBox(width: 10),
                Expanded(
                  child: Text('Upa chưa được phép nhắc bạn',
                      style: t.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                ),
              ],
            ),
            const SizedBox(height: 6),
            const Text('Bật thông báo để Upa nhắc bạn đứng dậy đúng giờ. '
                'Không bật cũng không sao, bạn vẫn tự giãn cơ được.'),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () => enable(state),
                icon: const Icon(Icons.settings_outlined),
                label: const Text('Bật thông báo'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
