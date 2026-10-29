import 'dart:io' show Platform;

import 'package:flutter/material.dart';

import '../../models/settings.dart';
import '../../state/app_state.dart';
import '../widgets/schedule_form.dart';

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
      appBar: AppBar(title: const Text('Cài đặt'), backgroundColor: Colors.transparent),
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
            const SizedBox(height: 8),
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Không nhận được lời nhắc? Trên Xiaomi, Oppo, Vivo, Samsung… hãy vào '
                  'Cài đặt > Ứng dụng > Upa Break > Pin, chọn "Không giới hạn" '
                  'và bật "Tự khởi động" để Upa nhắc đúng giờ.',
                ),
              ),
            ),
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
