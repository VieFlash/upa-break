import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../data/exercises.dart';
import '../../l10n/l10n.dart';
import '../../models/exercise.dart';
import '../../models/settings.dart';
import '../../state/app_state.dart';
import '../theme.dart';
import '../widgets/mascot.dart';

/// Mở phiên giãn cơ nhanh (2 bài) theo vùng hay mỏi.
Future<void> openQuickBreak(NavigatorState nav, AppState state) {
  final session = buildQuickSession(
    focus: state.settings.focusAreas,
    now: state.now,
    doneToday: state.todayCount,
  );
  return nav.push(MaterialPageRoute(
    fullscreenDialog: true,
    builder: (_) => BreakScreen(exercises: session),
  ));
}

enum _Phase { ready, exercise, done }

class BreakScreen extends StatefulWidget {
  const BreakScreen({super.key, required this.exercises});
  final List<Exercise> exercises;

  @override
  State<BreakScreen> createState() => _BreakScreenState();
}

class _BreakScreenState extends State<BreakScreen> {
  static const _readySeconds = 3;

  _Phase _phase = _Phase.ready;
  int _current = 0;
  int _remaining = _readySeconds;
  int _elapsedTotal = 0;
  bool _paused = false;
  int _completed = 0;
  int _reward = 0;
  bool _logged = false;
  Timer? _timer;

  Exercise get _ex => widget.exercises[_current];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _tick() {
    if (_paused || _phase == _Phase.done) return;
    setState(() {
      _remaining--;
      if (_phase == _Phase.exercise) _elapsedTotal++;
      if (_remaining > 0) {
        if (_remaining <= 3) HapticFeedback.selectionClick();
        return;
      }
      if (_phase == _Phase.ready) {
        _phase = _Phase.exercise;
        _remaining = _ex.seconds;
      } else {
        _completed++;
        HapticFeedback.mediumImpact();
        _goNext();
      }
    });
  }

  void _goNext() {
    if (_current < widget.exercises.length - 1) {
      _current++;
      _phase = _Phase.ready;
      _remaining = _readySeconds;
    } else {
      _phase = _Phase.done;
      _log();
    }
  }

  void _skip() => setState(() {
        if (_phase == _Phase.exercise) _completed++;
        _goNext();
      });

  Future<void> _log() async {
    if (_logged || _completed == 0) return;
    _logged = true;
    final ids = widget.exercises.take(_completed).map((e) => e.id).toList();
    final r = await AppScope.read(context).logBreak(ids, _elapsedTotal);
    if (mounted) setState(() => _reward = r);
  }

  Future<void> _exit() async {
    if (_phase != _Phase.done) await _log();
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _exit();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(icon: const Icon(Icons.close), onPressed: _exit),
          title: _phase == _Phase.done
              ? null
              : Text(context.l10n.exerciseProgress(_current + 1, widget.exercises.length)),
          centerTitle: true,
        ),
        body: SafeArea(
          child: _phase == _Phase.done ? _doneView(context) : _exerciseView(context),
        ),
      ),
    );
  }

  Widget _exerciseView(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final l = context.l10n;
    final steps = l.exerciseSteps(_ex.id);
    final ready = _phase == _Phase.ready;
    final total = ready ? _readySeconds : _ex.seconds;
    final progress = 1 - _remaining / total;
    final stepIndex = ready
        ? 0
        : ((_ex.seconds - _remaining) * steps.length ~/ _ex.seconds).clamp(0, steps.length - 1);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Chip(label: Text('${_ex.area.emoji} ${l.areaLabel(_ex.area)}')),
          const SizedBox(height: 4),
          Text(l.exerciseName(_ex.id), style: t.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
          const Spacer(),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 260,
                height: 260,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 10,
                  strokeCap: StrokeCap.round,
                  backgroundColor: AppColors.fur.withValues(alpha: 0.15),
                ),
              ),
              Mascot(mood: ready ? Mood.fresh : Mood.stretch, size: 200),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            ready ? l.getReady(_remaining) : l.secondsLeft(_remaining),
            style: t.displaySmall?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 16),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Text(
              steps[stepIndex],
              key: ValueKey('$_current-$stepIndex'),
              textAlign: TextAlign.center,
              style: t.titleMedium,
            ),
          ),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => setState(() => _paused = !_paused),
                  icon: Icon(_paused ? Icons.play_arrow : Icons.pause),
                  label: Text(_paused ? l.actionContinue : l.actionPause),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _skip,
                  icon: const Icon(Icons.skip_next),
                  label: Text(l.actionSkip),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _doneView(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final l = context.l10n;
    final state = AppScope.of(context);
    final nothing = _completed == 0;
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Spacer(),
          Mascot(mood: nothing ? Mood.fresh : Mood.proud, size: 240),
          const SizedBox(height: 16),
          Text(
            nothing ? l.doneNothing : l.doneGreat,
            textAlign: TextAlign.center,
            style: t.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          if (!nothing) ...[
            Text(l.fishReward(_reward), style: t.titleLarge),
            const SizedBox(height: 8),
            Text(l.todayProgress(state.todayCount, state.dailyGoal) +
                (state.streak > 0 ? l.streakSuffix(state.streak) : '')),
            if (state.goalReachedToday) ...[
              const SizedBox(height: 8),
              Text(l.goalReachedNote, textAlign: TextAlign.center),
            ],
          ],
          const Spacer(),
          FilledButton(onPressed: () => Navigator.of(context).pop(), child: Text(l.actionDone)),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
