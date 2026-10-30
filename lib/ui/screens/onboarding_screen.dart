import 'package:flutter/material.dart';

import '../../l10n/l10n.dart';
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
        SnackBar(content: Text(context.l10n.workEndBeforeStart)),
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
    final l = context.l10n;
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
                      child: Text(l.actionBack),
                    ),
                  if (_index > 0) const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: _saving ? null : _next,
                      child: Text(_index == _pages - 1 ? l.allowReminders : l.actionContinue),
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
    final l = context.l10n;
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Mascot(mood: Mood.stretch, size: 240),
          const SizedBox(height: 24),
          Text(l.onbWelcomeTitle,
              textAlign: TextAlign.center,
              style: t.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          Text(
            l.onbWelcomeBody,
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
    final l = context.l10n;
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const UpaRig(state: 'bell', size: 240),
          const SizedBox(height: 24),
          Text(l.onbPermissionTitle,
              textAlign: TextAlign.center,
              style: t.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          Text(
            l.onbPermissionBody,
            textAlign: TextAlign.center,
            style: t.bodyLarge,
          ),
          const SizedBox(height: 8),
          Text(
            l.onbPermissionNote,
            textAlign: TextAlign.center,
            style: t.bodySmall?.copyWith(color: Colors.brown.shade400),
          ),
        ],
      ),
    );
  }

  Widget _schedule(BuildContext context) {
    final l = context.l10n;
    return ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(l.onbScheduleTitle,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          Text(l.onbScheduleSubtitle),
          SectionTitle(l.sectionWorkHours),
          TimeRangeTile(
            label: l.workStartEnd,
            start: _s.workStart,
            end: _s.workEnd,
            onChanged: (a, b) => setState(() => _s = _s.copyWith(workStart: a, workEnd: b)),
          ),
          SectionTitle(l.sectionLunch),
          Card(
            child: SwitchListTile(
              title: Text(l.noRemindLunch),
              value: _s.lunchEnabled,
              onChanged: (v) => setState(() => _s = _s.copyWith(lunchEnabled: v)),
            ),
          ),
          const SizedBox(height: 8),
          TimeRangeTile(
            label: l.lunchTime,
            start: _s.lunchStart,
            end: _s.lunchEnd,
            enabled: _s.lunchEnabled,
            onChanged: (a, b) => setState(() => _s = _s.copyWith(lunchStart: a, lunchEnd: b)),
          ),
          SectionTitle(l.sectionWorkDays),
          WorkDaysPicker(
            days: _s.workDays,
            onChanged: (d) => setState(() => _s = _s.copyWith(workDays: d)),
          ),
        ],
      );
  }

  Widget _style(BuildContext context) {
    final l = context.l10n;
    return ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(l.onbStyleTitle,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          ModePicker(mode: _s.mode, onChanged: (m) => setState(() => _s = _s.copyWith(mode: m))),
          SectionTitle(l.sectionFocusAreas),
          AreaPicker(
            areas: _s.focusAreas,
            onChanged: (a) => setState(() => _s = _s.copyWith(focusAreas: a)),
          ),
          const SizedBox(height: 16),
          Text(
            l.dailyGoalLine(_s.dailyGoal),
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      );
  }
}
