import 'package:flutter/material.dart';

import '../../models/settings.dart';
import '../../state/app_state.dart';
import '../widgets/mascot.dart';
import '../widgets/schedule_form.dart';
import '../widgets/upa_rig.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _page = PageController();
  int _index = 0;
  late UserSettings _s = AppScope.read(context).settings;
  bool _saving = false;

  static const _pages = 4;

  void _next() {
    if (_index < _pages - 1) {
      _page.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {
      _finish();
    }
  }

  Future<void> _finish() async {
    if (_s.workEnd <= _s.workStart) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Giờ tan làm phải sau giờ vào làm nhé.')),
      );
      return;
    }
    setState(() => _saving = true);
    await AppScope.read(context).completeOnboarding(_s);
  }

  @override
  void dispose() {
    _page.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
              child: Row(
                children: List.generate(
                  _pages,
                  (i) => Expanded(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      height: 6,
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      decoration: BoxDecoration(
                        color: i <= _index
                            ? Theme.of(context).colorScheme.primary
                            : Colors.brown.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: PageView(
                controller: _page,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (i) => setState(() => _index = i),
                children: [
                  _welcome(context),
                  _schedule(context),
                  _style(context),
                  _permission(context),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
              child: Row(
                children: [
                  if (_index > 0)
                    TextButton(
                      onPressed: () => _page.previousPage(
                          duration: const Duration(milliseconds: 300), curve: Curves.easeOut),
                      child: const Text('Quay lại'),
                    ),
                  if (_index > 0) const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: _saving ? null : _next,
                      child: Text(_index == _pages - 1 ? 'Cho phép Upa nhắc' : 'Tiếp tục'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _welcome(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Mascot(mood: Mood.stretch, size: 240),
          const SizedBox(height: 24),
          Text('Ngồi lâu thì Upa cũng mỏi',
              textAlign: TextAlign.center,
              style: t.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          Text(
            'Upa sẽ nhắc bạn đứng dậy, giãn cơ 1 phút ngay tại bàn.\n'
            'Lỡ một lần cũng không sao, Upa không bao giờ trách.',
            textAlign: TextAlign.center,
            style: t.bodyLarge,
          ),
        ],
      ),
    );
  }

  /// Giải thích trước, rồi mới hiện hộp thoại xin quyền của hệ điều hành (khi bấm nút cuối).
  Widget _permission(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const UpaRig(state: 'bell', size: 240),
          const SizedBox(height: 24),
          Text('Cho Upa nhắc bạn nhé?',
              textAlign: TextAlign.center,
              style: t.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          Text(
            'Upa chỉ lắc chuông trong giờ làm, khi bạn đã ngồi lâu - không spam, không quảng cáo.\n'
            'Bước tiếp theo điện thoại sẽ hỏi quyền gửi thông báo.',
            textAlign: TextAlign.center,
            style: t.bodyLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Không cho phép cũng không sao, bạn vẫn dùng app và bật lại sau trong Cài đặt.',
            textAlign: TextAlign.center,
            style: t.bodySmall?.copyWith(color: Colors.brown.shade400),
          ),
        ],
      ),
    );
  }

  Widget _schedule(BuildContext context) => ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text('Bạn làm việc lúc nào?',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          const Text('Upa chỉ nhắc trong giờ làm, không làm phiền buổi tối.'),
          const SectionTitle('Giờ làm việc'),
          TimeRangeTile(
            label: 'Vào làm – tan làm',
            start: _s.workStart,
            end: _s.workEnd,
            onChanged: (a, b) => setState(() => _s = _s.copyWith(workStart: a, workEnd: b)),
          ),
          const SectionTitle('Nghỉ trưa'),
          Card(
            child: SwitchListTile(
              title: const Text('Không nhắc giờ nghỉ trưa'),
              value: _s.lunchEnabled,
              onChanged: (v) => setState(() => _s = _s.copyWith(lunchEnabled: v)),
            ),
          ),
          const SizedBox(height: 8),
          TimeRangeTile(
            label: 'Giờ nghỉ trưa',
            start: _s.lunchStart,
            end: _s.lunchEnd,
            enabled: _s.lunchEnabled,
            onChanged: (a, b) => setState(() => _s = _s.copyWith(lunchStart: a, lunchEnd: b)),
          ),
          const SectionTitle('Ngày làm việc'),
          WorkDaysPicker(
            days: _s.workDays,
            onChanged: (d) => setState(() => _s = _s.copyWith(workDays: d)),
          ),
        ],
      );

  Widget _style(BuildContext context) => ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text('Upa nhắc kiểu nào?',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          ModePicker(mode: _s.mode, onChanged: (m) => setState(() => _s = _s.copyWith(mode: m))),
          const SectionTitle('Bạn hay mỏi ở đâu?'),
          AreaPicker(
            areas: _s.focusAreas,
            onChanged: (a) => setState(() => _s = _s.copyWith(focusAreas: a)),
          ),
          const SizedBox(height: 16),
          Text(
            'Mục tiêu: ${_s.dailyGoal} lần giãn cơ mỗi ngày.',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      );
}
