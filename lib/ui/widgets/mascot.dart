import 'package:flutter/material.dart';

import '../../state/app_state.dart';
import 'upa_rig.dart';

String mascotAsset(Mood mood) => 'assets/mascot/mascot_${_rigState(mood)}.svg';

String _rigState(Mood mood) => switch (mood) {
      Mood.fresh => 'fresh',
      Mood.slouch => 'slouch',
      Mood.sleepy => 'sleepy',
      Mood.stretch => 'stretch',
      Mood.proud => 'proud',
      Mood.offHours => 'fresh',
    };

/// Upa chuyển động theo trạng thái (xem [UpaRig]); đổi trạng thái có hiệu ứng mờ dần.
class Mascot extends StatelessWidget {
  const Mascot({super.key, required this.mood, this.size = 220});

  final Mood mood;
  final double size;

  @override
  Widget build(BuildContext context) {
    final state = _rigState(mood);
    return SizedBox(
      width: size,
      height: size,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 450),
        switchInCurve: Curves.easeOutBack,
        transitionBuilder: (child, anim) => FadeTransition(
          opacity: anim,
          child: ScaleTransition(scale: Tween(begin: 0.92, end: 1.0).animate(anim), child: child),
        ),
        child: UpaRig(key: ValueKey(state), state: state, size: size),
      ),
    );
  }
}
